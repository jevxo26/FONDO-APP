/// Supported wallet transaction ledger types.
enum TransactionType { topUp, payment, refund, cashback, withdrawal }

/// Ledger record representing a financial movement in the customer's wallet or refund account.
class WalletTransaction {
  /// Unique transaction identifier.
  final String id;

  /// Nature of transaction.
  final TransactionType type;

  /// Amount in Bangladeshi Taka.
  final double amount;

  /// Description/note (e.g. bKash Top-up, Order #FND-84920 Payment).
  final String description;

  /// Timestamp when transaction was posted.
  final DateTime timestamp;

  const WalletTransaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.timestamp,
  });
}
