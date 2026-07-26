import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/presentation/controllers/auth_controller.dart';
import '../features/auth/presentation/controllers/auth_state.dart';
import '../features/auth/presentation/screens/add_delivery_address_screen.dart';
import '../features/auth/presentation/screens/forgot_password_screen.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/otp_verify_screen.dart';
import '../features/auth/presentation/screens/register_screen.dart';
import '../features/auth/presentation/screens/reset_password_screen.dart';
import '../features/auth/presentation/screens/splash_screen.dart';
import '../features/home/presentation/screens/home_screen.dart';
import 'routes.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authControllerProvider.notifier);
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: _RiverpodRouterRefreshListenable(authNotifier),
    redirect: (context, state) {
      final status = authState.status;
      final location = state.matchedLocation;

      // 1. If initializing, stay on splash screen
      if (status == AuthStatus.initial) {
        return location == AppRoutes.splash ? null : AppRoutes.splash;
      }

      final isUnauthenticated = status == AuthStatus.unauthenticated;
      final isAuthenticated = status == AuthStatus.authenticated;

      final isAuthRoute = location == AppRoutes.login ||
          location == AppRoutes.register ||
          location == AppRoutes.otpVerify ||
          location == AppRoutes.forgotPassword ||
          location == AppRoutes.resetPassword;

      // 2. Unauthenticated user trying to access protected routes -> redirect to /login
      if (isUnauthenticated && !isAuthRoute && location != AppRoutes.splash) {
        return AppRoutes.login;
      }

      // 3. Authenticated user trying to access auth screens -> check address status
      if (isAuthenticated && (isAuthRoute || location == AppRoutes.splash)) {
        if (!authState.hasAddress) {
          return AppRoutes.addAddress;
        }
        return AppRoutes.home;
      }

      // 4. Authenticated user accessing /home without an address -> force /add-address onboarding
      if (isAuthenticated && location == AppRoutes.home && !authState.hasAddress) {
        return AppRoutes.addAddress;
      }

      return null;
    },
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
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomeScreen(),
      ),
    ],
  );
});

class _RiverpodRouterRefreshListenable extends ChangeNotifier {
  _RiverpodRouterRefreshListenable(StateNotifier notifier) {
    notifier.addListener((_) {
      notifyListeners();
    });
  }
}
