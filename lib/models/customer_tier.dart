enum CustomerTier {
  bronze,
  silver,
  gold;

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

class CustomerStats {
  final int totalOrders;
  final double totalSpent;
  final String memberSince;

  const CustomerStats({
    this.totalOrders = 0,
    this.totalSpent = 0,
    this.memberSince = '',
  });

  CustomerTier get tier {
    if (totalOrders >= 100) return CustomerTier.gold;
    if (totalOrders >= 50) return CustomerTier.silver;
    return CustomerTier.bronze;
  }
}
