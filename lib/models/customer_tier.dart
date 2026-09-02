/// Loyalty and reward tiers unlocked through customer order volume.
enum CustomerTier {
  /// Entry-level tier for new customers (0–49 lifetime orders).
  bronze,

  /// Mid-level tier offering baseline discounts (50–99 lifetime orders).
  silver,

  /// Elite VIP tier with highest perks and dedicated priority support (100+ lifetime orders).
  gold;

  /// User-facing display title for the tier.
  String get label {
    switch (this) {
      case CustomerTier.bronze:
        return 'Bronze';
      case CustomerTier.silver:
        return 'Silver';
      case CustomerTier.gold:
        return 'Gold';
    }
  }

  /// Order qualification threshold range string.
  String get range {
    switch (this) {
      case CustomerTier.bronze:
        return '0–49 orders';
      case CustomerTier.silver:
        return '50–99 orders';
      case CustomerTier.gold:
        return '100+ orders';
    }
  }

  /// Summary of perks, delivery privileges, and discounts granted by this tier.
  String get benefit {
    switch (this) {
      case CustomerTier.bronze:
        return 'Free delivery on orders over ৳200';
      case CustomerTier.silver:
        return '5% discount + free delivery';
      case CustomerTier.gold:
        return '10% discount, free delivery & priority support';
    }
  }
}

/// Aggregated order and expenditure statistics used for tier calculation and profile insights.
class CustomerStats {
  /// Lifetime completed order count.
  final int totalOrders;

  /// Cumulative lifetime expenditure in Bangladeshi Taka (৳).
  final double totalSpent;

  /// Formatted date or month when the account was created.
  final String memberSince;

  /// Creates a [CustomerStats] instance.
  const CustomerStats({
    this.totalOrders = 0,
    this.totalSpent = 0,
    this.memberSince = '',
  });

  /// Computes active loyalty [CustomerTier] based on [totalOrders].
  CustomerTier get tier {
    if (totalOrders >= 100) return CustomerTier.gold;
    if (totalOrders >= 50) return CustomerTier.silver;
    return CustomerTier.bronze;
  }
}
