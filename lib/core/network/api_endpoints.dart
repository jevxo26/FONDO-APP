/// Central registry of backend REST API routes and base URL configuration.
class ApiEndpoints {
  ApiEndpoints._();

  /// Root API host URL resolved via compile-time environment or default local port.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000/api',
  );

  /// Endpoint for customer email/password or phone authentication.
  static const String login = '/auth/login';

  /// Endpoint for new customer onboarding and account creation.
  static const String register = '/auth/register';

  /// Endpoint for requesting SMS OTP verification code.
  static const String sendOtp = '/auth/otp/send';

  /// Endpoint for validating received SMS OTP verification code.
  static const String verifyOtp = '/auth/otp/verify';

  /// Endpoint for initiating customer password reset flow.
  static const String forgotPassword = '/auth/forgot-password';

  /// Endpoint for setting new password using recovery token.
  static const String resetPassword = '/auth/reset-password';

  /// Endpoint for renewing expired access token using refresh token.
  static const String refreshToken = '/auth/refresh';

  /// Endpoint for fetching current authenticated customer profile.
  static const String me = '/users/me';

  /// Endpoint for managing customer saved delivery addresses.
  static const String userAddresses = '/users/me/addresses';
}
