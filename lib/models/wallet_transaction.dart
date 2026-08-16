enum TransactionType { topUp, payment, refund, cashback, withdrawal }

class WalletTransaction {
  final String id;
  final TransactionType type;
  final double amount;
  final String description;
  final DateTime timestamp;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
  });
}
