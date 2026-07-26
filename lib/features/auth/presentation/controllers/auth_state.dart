import '../../../../models/address_model.dart';
import '../../../../models/user_model.dart';

enum AuthStatus { initial, authenticating, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final UserModel? user;
  final List<AddressModel> addresses;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.addresses = const [],
    this.errorMessage,
  });

  bool get isAuthenticated => status == AuthStatus.authenticated && user != null;
  bool get hasAddress => addresses.isNotEmpty;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    List<AddressModel>? addresses,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      addresses: addresses ?? this.addresses,
      errorMessage: errorMessage,
    );
  }
}
