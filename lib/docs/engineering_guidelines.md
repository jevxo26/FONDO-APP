# FONDO Flutter — Engineering Guidelines

> Companion to `Project-Blueprint.md`. This file is the "how we write code" reference — check it before starting any feature.

---

## 1. Naming Conventions

| Item | Convention | Example |
|---|---|---|
| Files | `snake_case.dart` | `food_detail_screen.dart` |
| Classes | `UpperCamelCase` | `FoodDetailScreen`, `AuthController` |
| Variables/functions | `lowerCamelCase` | `fetchFoodList()`, `isLoading` |
| Constants | `lowerCamelCase` with `k` prefix only for true compile-time constants in a shared const file | `kDefaultPadding` |
| Riverpod providers | `camelCaseProvider` | `authControllerProvider`, `foodListProvider` |
| Screens | suffix `Screen` | `LoginScreen` |
| Reusable widgets | no suffix needed, descriptive noun | `FoodCard`, `PriceTag` |
| Repositories | suffix `Repository` | `AuthRepository` |
| DTOs (raw API shape) | suffix `Dto` or `Response`/`Request` | `LoginRequestDto`, `UserResponseDto` |
| Domain models (app-facing, if added) | plain noun, no suffix | `User`, `FoodItem` |

---

## 2. Project Structure Rules (do/don't)

**Do**
- One screen = one file under `presentation/screens/`.
- Keep widgets under ~150 lines; extract sub-widgets into `presentation/widgets/` when a `build()` method grows unwieldy.
- Repositories only talk to Dio — never call Dio directly from a screen or controller.
- Controllers (Riverpod `Notifier`/`AsyncNotifier`) hold state and call repositories — screens call controllers, never repositories directly.

**Don't**
- Don't put business logic (price calculation, discount rules) inside a widget's `build()` method — put it in the controller or a plain function in `domain/` (or `data/` if no domain layer exists yet for that feature).
- Don't create a `domain` layer for a feature until it actually needs one (see Blueprint §4) — don't add ceremony preemptively.
- Don't store the JWT anywhere but `flutter_secure_storage`.

---

## 3. State Management Rules

- Global providers (auth session, theme) live in `core/` or app root — not duplicated per feature.
- Feature-local providers live inside that feature's `presentation/controllers/`.
- Prefer `AsyncNotifier`/`FutureProvider` over manually managing `isLoading`/`error` booleans — let Riverpod's `AsyncValue` (`.when(data:, loading:, error:)`) drive the UI state, same contract as a React Query `{ data, isLoading, error }` object.
- A screen should never hold `late` mutable business state outside a controller "just to make it compile" — if it needs state beyond ephemeral UI (a `TextEditingController`, a `PageController`), that's fine in the widget; anything that survives navigation or is shared belongs in a provider.

---

## 4. UI Principles

- All colors, spacing, radius, and type styles come from `core/theme/` — **never hardcode a hex color or a raw font size in a screen/widget.** If `DESIGN.md` doesn't have a token for something you need, that's a signal to extend the theme file, not to inline a value.
- Match `DESIGN.md`'s radius conventions: dashboards/tables → `rounded-3xl` equivalent; cards → the `radius-lg` equivalent; pills/badges → fully rounded. Translate these into named `BorderRadius` constants in the theme, not magic numbers per widget.
- Every list screen (catalog, orders, addresses) needs three states handled explicitly: loading (skeleton or spinner), empty (friendly empty-state widget, not a blank screen), error (retry action) — this is a "don't" if skipped, not optional polish.
- Buttons/interactive elements: consistent tap feedback (Flutter's `InkWell`/`ElevatedButton` defaults are fine — don't hand-roll custom press animations unless `DESIGN.md`'s spring-transition style is a hard requirement for mobile too — **[CONFIRM]** if the web's `cubic-bezier` micro-interactions need mobile parity, or if platform-native feel is preferred).

---

## 5. Package Decision Log

| Decision | Reason | Alternative considered | Tradeoff |
|---|---|---|---|
| Riverpod over Bloc/Provider | Closest to React Query mental model, compile-safe, less boilerplate | Bloc | Bloc is more rigid/testable for very large teams; overkill here |
| go_router over Navigator 1.0/auto_route | Declarative + officially maintained by Flutter team + deep link support | auto_route | auto_route needs code-gen setup; go_router's manual config is more transparent for learning |
| Dio over `http` package | Interceptors needed for auth + refresh + logging | `http` | `http` would require hand-rolled interceptor-equivalent boilerplate per call |
| flutter_secure_storage over shared_preferences for tokens | Tokens need OS-level secure storage, not plaintext prefs | shared_preferences | None acceptable — this isn't a style choice, it's a security requirement |
| `--dart-define` over `flutter_dotenv` | Compile-time, doesn't ship a plaintext `.env` asset in the bundle | flutter_dotenv | Slightly more setup (launch configs/scripts) for a real security benefit |

---

## 6. Git Workflow (detail)

**Commit format**: `type(scope): summary`
Types: `feat`, `fix`, `chore`, `refactor`, `docs`, `test`, `style`.
Scope: feature folder name (`auth`, `cart`, `checkout`, `foods`, `orders`, `core`).

Examples:
- `feat(auth): implement login screen and controller`
- `fix(checkout): prevent double order submission on network retry`
- `refactor(core): extract Dio refresh interceptor into its own file`
- `chore(deps): add cached_network_image`

**Before every commit**: `flutter analyze` clean, `dart format .` run. Don't commit commented-out code — delete it (git history has it if needed).

**PR/merge to `main`**: only at the end of a Phase (per Blueprint §11) — this is a solo project, so this is about keeping `main` always in a demo-able state, not process for its own sake.

---

## 7. Error Handling Rules

- Every repository method that calls Dio wraps failures into a typed `AppException` (mirroring your backend's `{ success: false, message, error }` shape) — screens never see a raw `DioException`.
- User-facing error messages come from the API's `message` field when present; a generic fallback ("Something went wrong, please try again") only when the API gives nothing usable (e.g., no connectivity).
- 401 handling is centralized in the Dio interceptor (refresh-and-retry) — no screen should manually catch a 401 and redirect to login itself.

---

## 8. Testing Priorities (when we get there)

Not blocking MVP, but in priority order once testing starts:
1. Repository methods (mock Dio, verify correct parsing of the `{ success, message, data }` envelope and error mapping)
2. Controllers (verify state transitions: loading → data / loading → error)
3. Critical widget tests: checkout flow, login form validation
4. Golden tests — skip for MVP, revisit only if visual regression becomes a real problem

---

## 9. Do / Don't Summary

**Do**
- Keep screens dumb; put logic in controllers/repositories.
- Use theme tokens for every visual value.
- Handle loading/empty/error on every data-driven screen.
- Re-validate each feature's request/response shape against `API.md` right before building it (docs may be ahead of or behind actual backend behavior).

**Don't**
- Don't hardcode colors, fonts, spacing.
- Don't call Dio from a widget.
- Don't build a feature whose API status is unconfirmed (Wallet, Subscriptions, Packages) without checking first.
- Don't add an abstraction (domain layer, DI container, code-gen) before a concrete need shows up for it.