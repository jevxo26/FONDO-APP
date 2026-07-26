# FONDO — Flutter Migration: Project Blueprint

> Status: **Draft v1** — based on partial API docs (`API_REFERENCE.md`, part of `API.md`, `DESIGN.md`, web folder structure). Sections marked **[CONFIRM]** need your answer or more docs before implementation starts on that part.

---

## 1. Project Overview

**Summary**: Build the customer-facing mobile app for FONDO (a subscription food-delivery platform) in Flutter, consuming the existing Express + Prisma REST API. This is a migration/adaptation of an existing Next.js web product, not a greenfield app.

**Objectives**
- Ship a Customer-role mobile app covering the confirmed-built API surface first (Auth, Profile, Food Catalog, Cart/Checkout, Orders).
- Learn Flutter properly while building — decisions explained, not just handed to you.
- Keep the app extensible so Vendor/Rider/Admin apps (if ever needed) can reuse the same core (networking, theme, auth) later.

**Success Criteria (MVP)**
- A user can register → verify OTP → log in → browse food catalog → add to cart → checkout → place an order → view order status.
- Auth session survives app restarts and refreshes correctly.
- UI visually matches the FONDO design system (`DESIGN.md` tokens), adapted for mobile.

**Target Users**: End customers of FONDO ordering food via mobile. **[CONFIRM]** — see Open Question #1 below; if Rider also needs a Flutter app, that's a second, separate app sharing the core package, not a bolt-on to this one.

**Out of scope for MVP** (⚪ Planned / unconfirmed in API): Subscriptions, Meal Plans/Packages, Riders, Live Tracking, Notifications (push), Support Tickets, CMS, Reports. Wallet/Payments/Vendor Settlements are **[CONFIRM]** — conflicting status across your two docs.

---

## 2. Flutter Project Type

**Recommendation: Application** (`flutter create --org com.fondo app`).

| Type | What it is | Why not this one |
|---|---|---|
| Application | Standard runnable app | ✅ This is what you need |
| Empty Application | App with no starter boilerplate/tests | Marginal benefit; standard template is fine, we delete the counter demo anyway |
| Module | Embeds Flutter inside an existing native (Android/iOS) app | You're not embedding into an existing native app |
| Package | Pure Dart, no platform channels, for sharing logic | Could matter *later* if you split a `core` package (auth/network/theme) for reuse across a future Rider app — not needed at MVP |
| Plugin | Package that wraps native platform APIs | Not applicable — you're not building a reusable native-bridge library |

If a Rider app is confirmed as in-scope later, the right move is to extract a local `packages/core` package (auth, Dio client, theme, models) that both apps depend on — not to duplicate code. Flagging now so the folder structure below is ready for that split without a rewrite.

---

## 3. Recommended Tech Stack

| Concern | Recommendation | Why |
|---|---|---|
| State management | **Riverpod** (`flutter_riverpod` + `riverpod_generator`) | Closest mental model to your React Query + Redux hybrid: `Provider`/`AsyncNotifier` ≈ a hook-like unit that caches, refetches, and exposes loading/error/data — same shape as a React Query hook. Compile-time safe (no `BuildContext` lookups failing at runtime like `Provider` package can). Bloc is more boilerplate-heavy and event-driven, a bigger jump from React than Riverpod. |
| Navigation | **go_router** | Declarative, URL-based routing — the closest match to Next.js's file-based routing mental model. Supports nested routes/shells (maps well to your `(main)` layout + `dashboard` layout split), deep linking, and auth redirects (guarding routes) out of the box. |
| Networking | **Dio** | Interceptors (for attaching the JWT, handling 401 → refresh → retry automatically) map directly to what you're doing in `api-client.ts`/`api.ts` today. Plain `http` package lacks interceptors and would mean hand-rolling that logic per-call. |
| Local storage (tokens) | **flutter_secure_storage** | Access token must not sit in plain `SharedPreferences` — this uses Keychain (iOS) / Keystore (Android). Direct equivalent of *not* putting a JWT in `localStorage` on web. |
| Local storage (non-sensitive cache/prefs) | **shared_preferences** | For things like "seen onboarding," last-selected address id, theme mode. |
| Env variables | **--dart-define / --dart-define-from-file** (not a package) | Flutter has no `.env` runtime loading by default akin to Next's `.env`; using compile-time `--dart-define` avoids shipping secrets in the bundle and avoids the extra `flutter_dotenv` asset-loading indirection. We'll set up `env/dev.json` / `env/prod.json` + a launch config. |
| Image handling | **cached_network_image** | Food images will be fetched repeatedly (catalog, cart, order history) — this gives disk+memory caching for free, avoids re-downloading on every screen. |
| Forms & validation | **flutter_form_builder** + manual `Validator` functions, OR plain `TextFormField` + `Form` with hand-written validators | For MVP forms (login/register/checkout) plain `Form`/`TextFormField` is enough and easier to learn first; revisit `flutter_form_builder` only if forms get complex (checkout has several sections, might justify it later). |
| Logging | **logger** package | Structured, leveled logs (debug/info/warn/error) with readable console output — better than bare `print()` for a real app. |
| Error handling | Custom `AppException` sealed class + Dio interceptor mapping your `{ success, message, error }` envelope into it | Mirrors your `AppError.ts` on the backend — one place that turns API error envelopes into typed exceptions the UI can react to consistently. |
| Dependency Injection | **Riverpod itself** (providers *are* the DI mechanism) | No separate DI package (e.g. `get_it`) needed — Riverpod's provider graph replaces it. Keeps one mental model instead of two. |

**Docs**: [Riverpod](https://riverpod.dev) · [go_router](https://pub.dev/packages/go_router) · [Dio](https://pub.dev/packages/dio) · [flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage) · [cached_network_image](https://pub.dev/packages/cached_network_image) · [logger](https://pub.dev/packages/logger)

---

## 4. Architecture Recommendation

**Feature-first, layered (light Clean Architecture)** — not full enterprise Clean Architecture (that's overkill for a small team learning Flutter; too many interfaces/abstractions to reason about while also learning the language).

Each feature folder gets three layers:
```
feature/
  data/        → DTOs (raw JSON models), repository implementation, Dio calls
  domain/      → (optional at MVP) plain entities + repository interface, only added when a feature's logic outgrows "just call the API"
  presentation/→ screens, widgets, Riverpod providers/controllers
```

**Why**: Matches your existing backend's `controller → service → route` separation conceptually (data layer = your `*Service.ts` equivalent), keeps UI code from directly calling Dio (so screens don't know about HTTP), and is beginner-friendly — you can build `data` + `presentation` for MVP and only introduce a formal `domain` interface layer for features that need swappable data sources or complex business rules (e.g. cart pricing logic).

**Tradeoffs**: Skipping strict Clean Architecture layers everywhere means less enforced testability/swap-ability short-term. Acceptable tradeoff given team size (1) and the goal of learning Flutter without fighting architecture ceremony. Revisit if the team grows.

---

## 5. Folder Structure

```
lib/
  main.dart                  # entry point, ProviderScope, env selection
  app.dart                   # MaterialApp.router, theme, go_router instance
  core/
    theme/                   # ColorScheme, TextTheme built from DESIGN.md tokens
    network/
      dio_client.dart         # Dio instance + interceptors (auth, refresh, error mapping)
      api_endpoints.dart       # base URL + path constants
    storage/
      secure_storage.dart      # token read/write wrapper
    errors/
      app_exception.dart
    utils/
    widgets/                  # shared dumb widgets (buttons, price tag, section header — mirrors your components/common)
  features/
    auth/
      data/                   # AuthRepository impl, DTOs (LoginRequest, AuthUser)
      presentation/
        screens/               # login_screen.dart, register_screen.dart, otp_screen.dart
        controllers/            # auth_controller.dart (Riverpod)
        widgets/
    profile/
    foods/
      data/
      presentation/
        screens/                # catalog_screen.dart, food_detail_screen.dart
        widgets/                # food_card.dart (≈ your food-card.tsx)
    cart/
    checkout/
    orders/
  router/
    app_router.dart            # go_router config, auth guard redirect logic
    routes.dart                 # path constants (mirrors your Next.js route tree conceptually)
  models/                       # shared cross-feature models if any (User, Address)
```

Notes:
- `core/network/dio_client.dart` is where the refresh-token interceptor lives — this is the single place that needs updating once Open Question #2 (refresh token strategy) is resolved.
- `core/theme` is a direct, mechanical translation of your `DESIGN.md` — colors, radii, shadows, and the Fraunces/Inter type scale become a `ThemeData`.

---

## 6. Feature Mapping (MVP scope only — confirmed-built API)

| Web Feature | Flutter Screen(s) | API Dependency | Priority | Complexity |
|---|---|---|---|---|
| Login | `login_screen.dart` | `POST /auth/login` | P0 | Low |
| Register | `register_screen.dart` | `POST /auth/register`, `POST /auth/otp/send`, `POST /auth/otp/verify` | P0 | Medium (OTP step) |
| Forgot/Reset password | `forgot_password_screen.dart`, `reset_password_screen.dart` | `POST /auth/forgot-password`, `POST /auth/reset-password` | P1 | Low |
| Profile view/edit | `profile_screen.dart`, `edit_profile_screen.dart` | `GET /auth/me`, `PATCH /users/me` | P1 | Low |
| Address book | `addresses_screen.dart` | `GET/POST/PATCH/DELETE /users/me/addresses*` | P1 | Medium |
| Food catalog / browse | `catalog_screen.dart` | `GET /foods`, `GET /foods/categories/list` | P0 | Medium |
| Food detail | `food_detail_screen.dart` | `GET /foods/:id` or `/slug/:slug`, `GET /foods/:foodId/reviews` | P0 | Medium |
| Favorites | inline on catalog/detail | `POST/DELETE /foods/:foodId/favorite` | P2 | Low |
| Reviews (write) | review sheet on detail screen | `POST /foods/:foodId/reviews` | P2 | Low |
| Cart | `cart_screen.dart` | `GET/POST/DELETE /cart`, `/cart/items*` | P0 | Medium |
| Checkout | `checkout_screen.dart` | `/cart/checkout/*`, `place-order` | P0 | High (multi-step: address → coupon → payment method → place order) |
| Order list/detail/tracking (status only, no live map) | `orders_screen.dart`, `order_detail_screen.dart` | `GET /api/orders`, `/api/orders/:id`, `/cancel` | P0 | Medium |
| Notification settings | `notification_settings_screen.dart` | `GET/PATCH /users/me/notification-settings` | P2 | Low |
| Login history / devices | `security_screen.dart` | `GET /users/me/login-history`, `/users/me/devices*` | P3 | Low |

**Excluded from MVP pending confirmation**: Wallet, Payments (online payment method), Vendor Settlements, Subscriptions, Packages/Meal Plans.

---

## 7. Screen Inventory (P0 only, MVP)

| Screen | Purpose | Depends on |
|---|---|---|
| Splash/Bootstrap | Check stored token → route to `/login` or `/home` | secure storage |
| Login | Email/phone + password | auth |
| Register | Multi-field signup + OTP verify | auth |
| OTP Verify | 6-digit code entry, resend | auth |
| Home / Catalog | Browse foods, categories, search | foods |
| Food Detail | Images, price, variants, reviews, add to cart | foods, cart |
| Cart | Line items, quantities, addons, subtotal | cart |
| Checkout | Address select, coupon, place order | cart, addresses |
| Order List | Past/active orders | orders |
| Order Detail | Status, items, cancel action | orders |
| Profile | View/edit personal info, addresses, logout | users |

---

## 8. User Flow

```
Splash
 ├─ token valid → Home
 └─ no token → Login
                 ├─ success → Home
                 └─ "Create account" → Register → OTP Verify → (auto-login? [CONFIRM]) → Home

Home (Catalog)
 └─ tap food → Food Detail → Add to Cart → Cart
                                              └─ Checkout → Select Address → Apply Coupon (optional)
                                                             → Place Order → Order Detail (success state)

Order List ← bottom nav
 └─ tap order → Order Detail → Cancel (if allowed by status)

Profile ← bottom nav
 ├─ Edit Profile
 ├─ Addresses (CRUD)
 ├─ Notification Settings
 └─ Logout
```

**Edge cases to design for**: empty cart at checkout, network failure mid-checkout (don't double-submit), token expiry mid-session (silent refresh vs. force logout), OTP resend cooldown, address list empty on first checkout.

**[CONFIRM]** — does OTP verification during registration log the user in automatically, or return to Login? Not specified in the docs you shared.

---

## 9. API Integration Strategy

### 9.1 Auth & the refresh-token problem (read this first)

Your web flow: `login` sets an `httpOnly` cookie → browser auto-attaches it → `/auth/refresh` reads it silently. **This does not work the same way for a mobile Dio client.** Dio can technically keep a cookie jar (`dio_cookie_manager` + `cookie_jar` packages), which *can* make this work almost transparently — that's the low-effort fix. The more robust fix is a backend change: have `/auth/login` (and `/auth/refresh`) also return `refreshToken` in the JSON body when the request isn't from a browser (e.g., detect via a custom header like `X-Client: mobile`), and Flutter stores it in `flutter_secure_storage` instead of relying on a cookie jar.

**Recommendation**: start with the cookie-jar approach (zero backend changes, ships faster) for MVP; note it as tech debt to revisit if cookie-jar behavior proves unreliable across iOS/Android WebView-less HTTP clients (it should work fine with Dio + `cookie_jar` since it's pure HTTP, not a WebView issue — just flagging because cookie handling in mobile HTTP clients is a common source of subtle bugs, e.g. cookie not persisting across app restarts unless the jar itself is file-backed via `PersistCookieJar`).

### 9.2 Network layer
- `DioClient` singleton (via Riverpod provider) with:
  - Base URL from `--dart-define`
  - Request interceptor: attach `Authorization: Bearer <token>` from secure storage
  - Response error interceptor: on `401`, attempt one `/auth/refresh`, retry original request once, else force logout
  - Logging interceptor (dev only, strips in release via `--dart-define=ENV=prod` check)

### 9.3 Repository layer
One repository per feature (`AuthRepository`, `FoodsRepository`, `CartRepository`, `OrdersRepository`) — thin wrappers around Dio calls returning typed models, matching your envelope: `{ success, message, data }`. A repository never returns raw `Response`; it returns the parsed `data` or throws `AppException`.

### 9.4 Caching / offline
**[CONFIRM]** — no offline requirement stated. MVP assumption: online-only, Riverpod `AsyncNotifier` handles in-memory caching per session (no disk cache of catalog/cart). Revisit only if you confirm offline browsing is required.

---

## 10. State Management Plan

| Scope | Tool | Example |
|---|---|---|
| Local widget state | `StatefulWidget` / `useState`-equivalent (`flutter_hooks` optional, not required) | text field focus, expand/collapse toggle |
| Feature state | Riverpod `Notifier`/`AsyncNotifier` scoped to feature | `CartController`, `CheckoutController` |
| Global state | Riverpod providers at app root | `AuthController` (current user/session), theme mode |
| Server/API state | Riverpod `AsyncNotifier` / `FutureProvider` (auto caching, loading/error) | food list, order list — direct analogue of your React Query hooks (`use-foods.ts` → `foodsProvider`) |

React comparison: `useState` → local `StatefulWidget` state or a small `Notifier`. `useContext`/Redux slice → global `Provider`. Your `use-*.ts` React Query hooks → `AsyncNotifierProvider` (same caching/loading/error contract, different syntax).

---

## 11. Development Roadmap

### Phase 0 — Setup & Foundation (no UI yet)
- Flutter project scaffold, folder structure, lint rules
- Theme built from `DESIGN.md` tokens
- Dio client + interceptors + **resolve the refresh-token approach** (blocker — needs your decision from §9.1)
- go_router skeleton with a placeholder Home + auth redirect guard
- **Deliverable**: app boots, shows a themed placeholder screen, no real API calls yet.

### Phase 1 — Auth
- Login, Register, OTP Verify screens
- `AuthRepository`, `AuthController`, secure token storage
- Auth-guarded routing (redirect to Login if no token)
- **Deliverable**: full register → OTP → login → logout loop against the real API.

### Phase 2 — Catalog & Food Detail
- Catalog screen (list/grid, categories, search)
- Food detail (images, variants, reviews, favorite)
- **Deliverable**: browse-only app, no cart yet.

### Phase 3 — Cart & Checkout
- Cart screen, quantity/addon management
- Address selection (reuse or build address CRUD if not done in Phase 1.5)
- Checkout flow (coupon, place order)
- **Deliverable**: end-to-end order placement.

### Phase 4 — Orders & Profile
- Order list/detail/cancel
- Profile view/edit, notification settings, address book polish
- **Deliverable**: MVP complete per §1 success criteria.

### Phase 5 (post-MVP, pending confirmation) — Wallet/Payments, Subscriptions, Packages
Blocked until API status is confirmed.

---

## 12. Learning Roadmap (stage-by-stage, only what's needed)

- **Before Phase 0**: Dart basics (null safety, async/await, classes) — 2–3 days, not a full Dart course.
- **During Phase 0**: Widgets 101 (Stateless vs Stateful, layout widgets: `Column`/`Row`/`Expanded`), Riverpod basics (`Provider`, `FutureProvider`).
- **During Phase 1**: Forms (`Form`, `TextFormField`, validation), navigation basics with go_router, secure storage.
- **During Phase 2**: Lists (`ListView.builder`, `GridView`), image loading, pagination pattern.
- **During Phase 3**: More advanced Riverpod (`AsyncNotifier` with mutations, optimistic updates optional), multi-step forms.
- **During Phase 4**: Polishing patterns — pull-to-refresh, empty/error states, snackbars/dialogs.

No theory dump beyond what a given phase needs — we'll go deeper exactly when a concept blocks you.

---

## 13. Git Workflow

- **Branches**: `main` (stable) ← `dev` ← feature branches `feature/auth-login`, `feature/cart-checkout`, etc. Given team size of 1, `dev` is optional — `main` + short-lived feature branches is enough; add `dev` only if this becomes multi-contributor.
- **Commits**: [Conventional Commits](https://www.conventionalcommits.org/) — `feat(auth): add login screen`, `fix(cart): correct addon price calc`, `chore(deps): add dio`.
- **Milestones**: tag `v0.1.0-auth`, `v0.2.0-catalog`, `v0.3.0-checkout`, `v1.0.0-mvp` at the end of each phase in §11.

---

## 14. Risks

| Risk | Category | Mitigation |
|---|---|---|
| Refresh-token cookie doesn't behave as expected on mobile | Migration | Resolved via §9.1 decision before Phase 1 starts |
| Learning Dart+Flutter+Riverpod simultaneously slows early phases | Beginner | Learning roadmap paced per-phase (§12), not front-loaded |
| API docs (`API.md`, 3926 lines) may reveal request/response shapes that differ from what's assumed here | Migration | Re-validate each feature's DTOs against `API.md` right before building that feature, not all upfront |
| Subscriptions/Wallet status ambiguity could mean scope grows mid-project | Architecture | Explicitly excluded from MVP; folder structure leaves room to add `features/subscriptions` later without refactor |
| Over-engineering (full Clean Architecture) slows a solo beginner | Architecture | Light layered approach chosen (§4), formal `domain` layer only added when justified |

---

## 15. Future Production Roadmap (post-MVP)

- Offline support: local cache (`drift`/`sqflite`) for catalog browsing, if confirmed needed
- Push notifications: Firebase Cloud Messaging, mapped to your existing `notificationController`/`notification-settings` API
- Deep links: `go_router` supports this natively — useful for order-status links from push notifications
- Crash reporting: Firebase Crashlytics or Sentry
- Analytics: Firebase Analytics or Mixpanel — **[CONFIRM]** whether web already uses one, to stay consistent
- CI/CD: GitHub Actions → `flutter build` + `flutter test`, Fastlane for store deploys
- Testing: widget tests for P0 screens, unit tests for repositories/controllers first (highest ROI)
- Store deployment: Play Store (internal testing track first), App Store (TestFlight first)
- Monitoring: API error rate dashboard, correlate with your backend's existing error format

---

## Open Questions (blocking full confidence in this plan)

1. **Scope** — Customer app only, or Rider too? (Blueprint above assumes Customer-only.)
2. **Refresh token strategy** — cookie-jar on mobile (fast) vs. backend change to return token in body for mobile clients (robust)? (§9.1)
3. Does OTP-verify-on-register auto-login, or return to the Login screen?
4. Real status of Wallet/Payments/Vendor Settlements/Subscriptions/Packages — the two docs disagree.
5. Any offline requirement? (assumed "no" for MVP)
6. Any existing analytics/crash tool on web, to stay consistent? (§15)

None of these block Phase 0 (setup, theme, Dio skeleton) — they start mattering from Phase 1 onward.