import 'package:flutter/material.dart';
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
import '../features/home/presentation/screens/device_registry_screen.dart';
import '../features/home/presentation/screens/edit_profile_screen.dart';
import '../features/home/presentation/screens/favorites_screen.dart';
import '../features/home/presentation/screens/security_settings_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import '../features/home/presentation/screens/live_order_tracking_screen.dart';
import '../features/home/presentation/screens/order_history_screen.dart';
import '../features/home/presentation/screens/settings_screen.dart';
import '../features/home/presentation/screens/subscription_manager_screen.dart';
import '../features/home/presentation/screens/wallet_screen.dart';
import '../features/home/presentation/screens/main_shell.dart';
import '../features/home/presentation/screens/notification_center_screen.dart';
import '../features/home/presentation/screens/packages_screen.dart';
import '../features/home/presentation/screens/search_screen.dart';
import '../features/home/presentation/screens/profile_screen.dart';
import '../features/home/presentation/screens/pro_perks_screen.dart';
import 'routes.dart';

/// Top-level Root Navigator Key for full-screen pushed routes
final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.otpVerify,
      builder: (context, state) {
        final phone = state.uri.queryParameters['phone'] ?? '';
        return OtpVerifyScreen(phone: phone);
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.addAddress,
      builder: (context, state) => const AddDeliveryAddressScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.resetPassword,
      builder: (context, state) {
        final target = state.uri.queryParameters['target'];
        return ResetPasswordScreen(target: target);
      },
    ),

    // Full-screen Food Detail
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: AppRoutes.foodDetail,
      builder: (context, state) => FoodDetailScreen(
        foodId: state.pathParameters['foodId']!,
      ),
    ),

    // 5 Primary Navigation Tab Roots inside StatefulShellRoute
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        // Tab 0: Home Feed
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'catalog/:category',
                  builder: (context, state) => FoodCatalogScreen(
                    category: state.pathParameters['category']!,
                  ),
                ),
              ],
            ),
          ],
        ),

        // Tab 1: Packages & Subscriptions
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.packages,
              builder: (context, state) => const PackagesScreen(),
            ),
          ],
        ),

        // Tab 2: Dedicated Search
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),

        // Tab 3: Cart & Checkout
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.cart,
              builder: (context, state) => const CartScreen(),
            ),
          ],
        ),

        // Tab 4: Account Center
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.profile,
              builder: (context, state) => const ProfileScreen(),
              routes: [
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'addresses',
                  builder: (context, state) => const AddressManagerScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'wallet',
                  builder: (context, state) => const WalletScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'subscriptions',
                  builder: (context, state) => const SubscriptionManagerScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'orders',
                  builder: (context, state) => const OrderHistoryScreen(),
                  routes: [
                    GoRoute(
                      parentNavigatorKey: _rootNavigatorKey,
                      path: ':orderId/track',
                      builder: (context, state) => LiveOrderTrackingScreen(
                        orderId: state.pathParameters['orderId']!,
                      ),
                    ),
                  ],
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'settings',
                  builder: (context, state) => const SettingsScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'edit',
                  builder: (context, state) => const EditProfileScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'security',
                  builder: (context, state) => const SecuritySettingsScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'devices',
                  builder: (context, state) => const DeviceRegistryScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'favorites',
                  builder: (context, state) => const FavoritesScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'pro-perks',
                  builder: (context, state) => const ProPerksScreen(),
                ),
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'notifications',
                  builder: (context, state) => const NotificationCenterScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);
