import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Representation of the authenticated user's profile.
class UserProfile {
  final String id;
  final String fullName;
  final String email;
  final String phone;
  final String avatarInitials;
  final bool isProMember;
  final String proTier;
  final int loyaltyPoints;
  final double walletBalance;

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

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(const UserProfile());

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

  void updateProMembership({required bool isPro, String? tier}) {
    state = state.copyWith(
      isProMember: isPro,
      proTier: tier ?? (isPro ? 'VIP PRO' : 'Standard'),
    );
  }

  void addLoyaltyPoints(int points) {
    state = state.copyWith(loyaltyPoints: state.loyaltyPoints + points);
  }

  void updateWalletBalance(double newBalance) {
    state = state.copyWith(walletBalance: newBalance);
  }
}

final userProfileProvider =
    StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});
