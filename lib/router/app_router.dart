import 'package:go_router/go_router.dart';
import '../features/address/presentation/screens/add_delivery_address_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/otp_verify_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/reset_password_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/home/presentation/screens/cart_screen.dart';
import '../features/home/presentation/screens/food_catalog_screen.dart';
import '../features/home/presentation/screens/food_detail_screen.dart';
import '../features/home/presentation/screens/address_manager_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/home/presentation/screens/subscription_manager_screen.dart';
import '../features/home/presentation/screens/wallet_screen.dart';
import '../features/home/presentation/screens/main_shell.dart';
import '../features/home/presentation/screens/packages_screen.dart';
import '../features/home/presentation/screens/profile_screen.dart';
import 'routes.dart';

final appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.otpVerify,
      builder: (context, state) {
        final phone = state.uri.queryParameters['phone'] ?? '';
        return OtpVerifyScreen(phone: phone);
      },
    ),
    GoRoute(
      path: AppRoutes.addAddress,
      builder: (context, state) => const AddDeliveryAddressScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (context, state) {
        final target = state.uri.queryParameters['target'];
        return ResetPasswordScreen(target: target);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  path: 'catalog/:category',
                  builder: (context, state) => FoodCatalogScreen(
                    category: state.pathParameters['category']!,
                  ),
                ),
              ],
            ),
            GoRoute(
              path: AppRoutes.foodDetail,
              builder: (context, state) => FoodDetailScreen(
                foodId: state.pathParameters['foodId']!,
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.packages,
              builder: (context, state) => const PackagesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.cart,
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  path: 'addresses',
                  builder: (context, state) => const AddressManagerScreen(),
                ),
                GoRoute(
                  path: 'wallet',
                  builder: (context, state) => const WalletScreen(),
                ),
                GoRoute(
                  path: 'subscriptions',
                  builder: (context, state) => const SubscriptionManagerScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
