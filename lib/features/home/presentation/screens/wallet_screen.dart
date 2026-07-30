import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../models/wallet_transaction.dart';

double _balance = 1280.0;

final List<WalletTransaction> _transactions = [
  WalletTransaction(id: 'tx_001', type: TransactionType.credit, amount: 500, description: 'Wallet top-up', timestamp: DateTime(2026, 7, 28)),
  WalletTransaction(id: 'tx_002', type: TransactionType.debit, amount: 350, description: 'Kacchi Biryani x2', timestamp: DateTime(2026, 7, 27)),
  WalletTransaction(id: 'tx_003', type: TransactionType.credit, amount: 200, description: 'Wallet top-up', timestamp: DateTime(2026, 7, 25)),
  WalletTransaction(id: 'tx_004', type: TransactionType.debit, amount: 180, description: 'Chicken Biryani', timestamp: DateTime(2026, 7, 24)),
  WalletTransaction(id: 'tx_005', type: TransactionType.debit, amount: 120, description: 'Paratha & Dal', timestamp: DateTime(2026, 7, 23)),
  WalletTransaction(id: 'tx_006', type: TransactionType.credit, amount: 1000, description: 'Wallet top-up', timestamp: DateTime(2026, 7, 20)),
  WalletTransaction(id: 'tx_007', type: TransactionType.debit, amount: 250, description: 'Beef Khichuri', timestamp: DateTime(2026, 7, 19)),
  WalletTransaction(id: 'tx_008', type: TransactionType.debit, amount: 320, description: 'Grilled Chicken Platter', timestamp: DateTime(2026, 7, 18)),
];

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  void _showTopUpModal() {
    final amountCtr = TextEditingController();
    int? quickAmount;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (ctx, setSheetState) => Padding(
            padding: EdgeInsets.fromLTRB(24, 32, 24, MediaQuery.of(ctx).viewInsets.bottom + 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Add Money', style: AppTypography.titleLarge(isDark: isDark)),
                const SizedBox(height: 8),
                Text('Choose an amount or enter a custom value', style: AppTypography.bodyMedium(isDark: isDark)),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [100, 200, 500, 1000, 2000, 5000].map((amount) {
                    final selected = quickAmount == amount;
                    return ChoiceChip(
                      label: Text('৳$amount', style: AppTypography.label(isDark: isDark).copyWith(fontSize: 13)),
                      selected: selected,
                      selectedColor: AppColors.primary,
                      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.mutedLight,
                      labelStyle: TextStyle(color: selected ? AppColors.primaryForeground : null),
                      onSelected: (_) {
                        setSheetState(() {
                          quickAmount = amount;
                          amountCtr.text = '$amount';
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: amountCtr,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '৳ ',
                    hintText: 'Enter custom amount',
                    hintStyle: AppTypography.bodyMedium(isDark: isDark),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    filled: true,
                    fillColor: isDark ? AppColors.inputFillDark : AppColors.inputFillLight,
                  ),
                  style: AppTypography.bodyLarge(isDark: isDark),
                  onChanged: (_) => setSheetState(() => quickAmount = null),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () {
                    final parsed = double.tryParse(amountCtr.text);
                    if (parsed == null || parsed <= 0) return;
                    setState(() => _balance += parsed);
                    Navigator.of(ctx).pop();
                  },
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 52),
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.primaryForeground,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text(
                    'Add ${amountCtr.text.isNotEmpty ? '৳${amountCtr.text}' : 'Money'}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Wallet'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => Future.delayed(const Duration(milliseconds: 600)),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    _BalanceCard(balance: _balance, isDark: isDark),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: _showTopUpModal,
                          icon: const Icon(Icons.add_rounded, size: 20),
                          label: const Text('Add Money'),
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: AppColors.primaryForeground,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.swap_horiz_rounded, size: 20),
                          label: const Text('Transfer'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: const BorderSide(color: AppColors.primary),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text('Transaction History', style: AppTypography.label(isDark: isDark)),
                  const SizedBox(height: 12),
                  ..._transactions.map((tx) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: _TransactionRow(transaction: tx, isDark: isDark),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  final bool isDark;

  const _BalanceCard({required this.balance, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.account_balance_wallet_rounded, color: AppColors.primaryForeground.withValues(alpha: 0.8), size: 20),
              const SizedBox(width: 8),
              Text(
                'Wallet Balance',
                style: AppTypography.bodyMedium(isDark: false).copyWith(
                  color: AppColors.primaryForeground.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '৳${balance.toStringAsFixed(0)}',
            style: AppTypography.display(isDark: false).copyWith(
              color: AppColors.primaryForeground,
              fontSize: 36,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '•••• 4592',
            style: AppTypography.bodyMedium(isDark: false).copyWith(
              color: AppColors.primaryForeground.withValues(alpha: 0.6),
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final WalletTransaction transaction;
  final bool isDark;

  const _TransactionRow({required this.transaction, required this.isDark});

  String _formatDate(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${months[dt.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final isCredit = transaction.type == TransactionType.credit;
    final color = isCredit ? AppColors.success : AppColors.destructive;
    final icon = isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.description, style: AppTypography.bodyMedium(isDark: isDark)),
                const SizedBox(height: 2),
                Text(_formatDate(transaction.timestamp), style: AppTypography.small(isDark: isDark)),
              ],
            ),
          ),
          Text(
            '${isCredit ? '+' : '-'}৳${transaction.amount.toStringAsFixed(0)}',
            style: AppTypography.label(isDark: isDark).copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
