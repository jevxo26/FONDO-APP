import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Representation of the authenticated user's profile and membership status.
class UserProfile {
  /// Unique customer profile identifier.
  final String id;

  /// Full display name of the customer.
  final String fullName;

  /// Primary account email address.
  final String email;

  /// Contact phone number for deliveries.
  final String phone;

  /// Monogram initials for the profile avatar.
  final String avatarInitials;

  /// Whether the customer has an active FONDO Pro membership.
  final bool isProMember;

  /// Subscription tier title (e.g. "VIP PRO", "Standard").
  final String proTier;

  /// Accumulated loyalty reward points.
  final int loyaltyPoints;

  /// Live available balance in the customer's wallet or refund account.
  final double walletBalance;

  /// Creates a [UserProfile] instance.
  const UserProfile({
    this.id = 'usr_001',
    this.fullName = 'Abir Rahman',
    this.email = 'abir.rahman@example.com',
    this.phone = '+880 1712 345678',
    this.avatarInitials = 'AR',
    this.isProMember = true,
    this.proTier = 'VIP PRO',
    this.loyaltyPoints = 1240,
    this.walletBalance = 0.0,
  });

  /// Creates a modified copy of this [UserProfile].
  UserProfile copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? avatarInitials,
    bool? isProMember,
    String? proTier,
    int? loyaltyPoints,
    double? walletBalance,
  }) {
    return UserProfile(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarInitials: avatarInitials ?? this.avatarInitials,
      isProMember: isProMember ?? this.isProMember,
      proTier: proTier ?? this.proTier,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      walletBalance: walletBalance ?? this.walletBalance,
    );
  }
}

/// State notifier managing real-time updates to customer profile and wallet attributes.
class UserProfileNotifier extends StateNotifier<UserProfile> {
  /// Creates a [UserProfileNotifier] with default initial profile.
  UserProfileNotifier() : super(const UserProfile());

  /// Updates personal customer profile contact fields.
  void updateProfile({
    String? fullName,
    String? email,
    String? phone,
    String? avatarInitials,
  }) {
    state = state.copyWith(
      fullName: fullName,
      email: email,
      phone: phone,
      avatarInitials: avatarInitials,
    );
  }

  /// Updates FONDO Pro membership subscription state and tier.
  void updateProMembership({required bool isPro, String? tier}) {
    state = state.copyWith(
      isProMember: isPro,
      proTier: tier ?? (isPro ? 'VIP PRO' : 'Standard'),
    );
  }

  /// Increments customer accumulated loyalty points.
  void addLoyaltyPoints(int points) {
    state = state.copyWith(loyaltyPoints: state.loyaltyPoints + points);
  }

  /// Updates available wallet or refund balance in Bangladeshi Taka (৳).
  void updateWalletBalance(double newBalance) {
    state = state.copyWith(walletBalance: newBalance);
  }
}

/// Central Riverpod provider exposing reactive [UserProfile] state across the app.
final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});
