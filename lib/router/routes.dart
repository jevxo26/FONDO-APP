class AppRoutes {
  AppRoutes._();

  static const String splash = '/splash';
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerify = '/otp-verify';
  static const String addAddress = '/add-address';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String home = '/home';
  static const String foodCatalog = '/home/catalog/:category';
  static const String foodDetail = '/food-detail/:foodId';
  static const String packages = '/packages';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String addressManager = '/profile/addresses';
  static const String wallet = '/profile/wallet';
  static const String subscriptions = '/profile/subscriptions';
  static const String orderHistory = '/profile/orders';
  static const String vendor = '/vendor';
  static const String vendorOrders = '/vendor/orders';
  static const String vendorFoods = '/vendor/foods';
  static const String vendorProfile = '/vendor/profile';
}
