import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_glow.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../models/wallet_transaction.dart';

double _balance = 1280.0;
double _holdBalance = 150.0;

final List<WalletTransaction> _transactions = [
  WalletTransaction(id: 'tx_001', type: TransactionType.topUp, amount: 500, description: 'Wallet top-up', timestamp: DateTime(2026, 7, 28)),
  WalletTransaction(id: 'tx_002', type: TransactionType.payment, amount: 350, description: 'Kacchi Biryani x2', timestamp: DateTime(2026, 7, 27)),
  WalletTransaction(id: 'tx_003', type: TransactionType.topUp, amount: 200, description: 'Wallet top-up', timestamp: DateTime(2026, 7, 25)),
  WalletTransaction(id: 'tx_004', type: TransactionType.refund, amount: 80, description: 'Refund — Salad', timestamp: DateTime(2026, 7, 24)),
  WalletTransaction(id: 'tx_005', type: TransactionType.payment, amount: 120, description: 'Paratha & Dal', timestamp: DateTime(2026, 7, 23)),
  WalletTransaction(id: 'tx_006', type: TransactionType.cashback, amount: 45, description: 'Cashback — Weekend deal', timestamp: DateTime(2026, 7, 21)),
  WalletTransaction(id: 'tx_007', type: TransactionType.topUp, amount: 1000, description: 'Wallet top-up', timestamp: DateTime(2026, 7, 20)),
  WalletTransaction(id: 'tx_008', type: TransactionType.payment, amount: 250, description: 'Beef Khichuri', timestamp: DateTime(2026, 7, 19)),
  WalletTransaction(id: 'tx_009', type: TransactionType.withdrawal, amount: 300, description: 'Withdrawal to bKash', timestamp: DateTime(2026, 7, 18)),
  WalletTransaction(id: 'tx_010', type: TransactionType.payment, amount: 320, description: 'Grilled Chicken Platter', timestamp: DateTime(2026, 7, 18)),
];

const _quickAmounts = [100, 200, 500, 1000, 2000, 5000];

const _topUpMethods = [
  ('bKash', Icons.phone_android_rounded, Color(0xFFE2136E)),
  ('Nagad', Icons.smartphone_rounded, Color(0xFFF6921E)),
  ('Card', Icons.credit_card_rounded, Color(0xFF0F6FDE)),
];

const _payoutMethods = ['Bank Transfer', 'bKash', 'Nagad'];

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

enum _LedgerFilter { all, topUp, payment, refund, cashback }

class _WalletScreenState extends State<WalletScreen> {
  bool _loading = true;
  _LedgerFilter _filter = _LedgerFilter.all;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) setState(() => _loading = false);
    });
  }

  List<WalletTransaction> get _filteredTransactions {
    switch (_filter) {
      case _LedgerFilter.all:
        return _transactions;
      case _LedgerFilter.topUp:
        return _transactions.where((t) => t.type == TransactionType.topUp).toList();
      case _LedgerFilter.payment:
        return _transactions
            .where((t) => t.type == TransactionType.payment || t.type == TransactionType.withdrawal)
            .toList();
      case _LedgerFilter.refund:
        return _transactions.where((t) => t.type == TransactionType.refund).toList();
      case _LedgerFilter.cashback:
        return _transactions.where((t) => t.type == TransactionType.cashback).toList();
    }
  }

  void _showTopUpModal() {
    final amountCtr = TextEditingController();
    final messenger = ScaffoldMessenger.of(context);
    int? quickAmount;
    String? method;
    var processing = false;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetCtx, setSheetState) {
          final isDark = Theme.of(sheetCtx).brightness == Brightness.dark;

          void confirmTopUp() {
            final parsed = double.tryParse(amountCtr.text);
            if (parsed == null || parsed <= 0 || method == null) return;
            setSheetState(() => processing = true);
            HapticFeedback.lightImpact();
            Future.delayed(const Duration(milliseconds: 1400), () {
              if (!sheetCtx.mounted) return;
              Navigator.of(sheetCtx).pop();
              setState(() {
                _balance += parsed;
                _transactions.insert(0, WalletTransaction(
                  id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
                  type: TransactionType.topUp,
                  amount: parsed,
                  description: 'Wallet top-up via $method',
                  timestamp: DateTime.now(),
                ));
              });
              if (!context.mounted) return;
              HapticFeedback.mediumImpact();
              messenger.showSnackBar(
                SnackBar(
                  content: Text('৳${parsed.toStringAsFixed(0)} added to your wallet'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            });
          }

          return Container(
            padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(sheetCtx).viewInsets.bottom + 24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('Add Money', style: AppTypography.titleLarge(isDark: isDark)),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('SSLCommerz', style: AppTypography.badge(isDark: isDark).copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Choose an amount, then a payment method', style: AppTypography.bodyMedium(isDark: isDark)),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _quickAmounts.map((amount) {
                    final selected = quickAmount == amount;
                    return ChoiceChip(
                      label: Text('৳$amount', style: AppTypography.label(isDark: isDark).copyWith(fontSize: 13)),
                      selected: selected,
                      selectedColor: AppColors.primary,
                      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.mutedLight,
                      labelStyle: TextStyle(color: selected ? AppColors.primaryForeground : null),
                      onSelected: (_) {
                        HapticFeedback.selectionClick();
                        setSheetState(() {
                          quickAmount = amount;
                          amountCtr.text = '$amount';
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
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
                const SizedBox(height: 18),
                Text('Payment Method', style: AppTypography.label(isDark: isDark)),
                const SizedBox(height: 10),
                Row(
                  children: _topUpMethods.map((entry) {
                    final (name, icon, color) = entry;
                    final selected = method == name;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          setSheetState(() => method = name);
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 10),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: selected
                                ? color.withValues(alpha: 0.15)
                                : (isDark ? AppColors.surfaceDark : AppColors.mutedLight),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: selected ? color : (isDark ? AppColors.borderDark : AppColors.borderLight),
                              width: selected ? 1.5 : 1,
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(icon, color: selected ? color : (isDark ? AppColors.mutedForegroundDark : AppColors.mutedForegroundLight), size: 22),
                              const SizedBox(height: 6),
                              Text(name, style: AppTypography.label(isDark: isDark).copyWith(fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: processing || method == null ? null : confirmTopUp,
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      backgroundColor: AppColors.primary,
                      disabledBackgroundColor: isDark ? AppColors.surfaceDark : AppColors.mutedLight,
                      foregroundColor: AppColors.primaryForeground,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: processing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryForeground),
                          )
                        : Text(
                            amountCtr.text.isNotEmpty ? 'Pay ৳${amountCtr.text} via $method' : 'Continue to Payment',
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                          ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showPayoutModal() {
    final amountCtr = TextEditingController();
    String method = _payoutMethods.first;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) {
        final isDark = Theme.of(sheetCtx).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (sheetCtx, setSheetState) => Container(
            padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(sheetCtx).viewInsets.bottom + 24),
            decoration: BoxDecoration(
              color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Withdraw Funds', style: AppTypography.titleLarge(isDark: isDark)),
                const SizedBox(height: 4),
                Text('Available balance ৳${_balance.toStringAsFixed(0)}', style: AppTypography.bodyMedium(isDark: isDark)),
                const SizedBox(height: 18),
                TextField(
                  controller: amountCtr,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '৳ ',
                    hintText: 'Enter amount to withdraw',
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
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: _payoutMethods.map((option) {
                    final selected = method == option;
                    return ChoiceChip(
                      label: Text(option, style: AppTypography.label(isDark: isDark).copyWith(fontSize: 13)),
                      selected: selected,
                      selectedColor: AppColors.primary,
                      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.mutedLight,
                      labelStyle: TextStyle(color: selected ? AppColors.primaryForeground : null),
                      onSelected: (_) {
                        HapticFeedback.selectionClick();
                        setSheetState(() => method = option);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Withdrawals are verified before release. Funds are held for up to 24 hours.',
                          style: AppTypography.small(isDark: isDark),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      final parsed = double.tryParse(amountCtr.text);
                      if (parsed == null || parsed <= 0 || parsed > _balance) return;
                      setState(() {
                        _balance -= parsed;
                        _holdBalance += parsed;
                        _transactions.insert(0, WalletTransaction(
                          id: 'tx_${DateTime.now().millisecondsSinceEpoch}',
                          type: TransactionType.withdrawal,
                          amount: parsed,
                          description: 'Withdrawal to $method',
                          timestamp: DateTime.now(),
                        ));
                      });
                      HapticFeedback.mediumImpact();
                      Navigator.of(sheetCtx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('৳${parsed.toStringAsFixed(0)} withdrawal requested — funds on hold'),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size(double.infinity, 52),
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.primaryForeground,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Request Withdrawal', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
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

    if (_loading) {
      return _buildLoadingState();
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
        title: const Text('Wallet'),
      ),
      body: Stack(
        children: [
          const GlowOrbs(),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: RefreshIndicator(
                onRefresh: () => Future.delayed(const Duration(milliseconds: 600)),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 140),
                  children: [
                    _BalanceCard(balance: _balance, holdBalance: _holdBalance, isDark: isDark),
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
                            onPressed: _showPayoutModal,
                            icon: const Icon(Icons.currency_exchange_rounded, size: 20),
                            label: const Text('Withdraw'),
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
                    const SizedBox(height: 24),
                    Text('Transaction History', style: AppTypography.label(isDark: isDark)),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 38,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: _LedgerFilter.values.map((filter) {
                          final label = switch (filter) {
                            _LedgerFilter.all => 'All',
                            _LedgerFilter.topUp => 'Top-ups',
                            _LedgerFilter.payment => 'Payments',
                            _LedgerFilter.refund => 'Refunds',
                            _LedgerFilter.cashback => 'Cashbacks',
                          };
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: _LedgerChip(
                              label: label,
                              selected: _filter == filter,
                              onTap: () => setState(() => _filter = filter),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_filteredTransactions.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text('No transactions in this category', style: AppTypography.bodyMedium(isDark: isDark)),
                        ),
                      )
                    else
                      ..._filteredTransactions.map((tx) => Padding(
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
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
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
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: const [
                  _BalanceCardSkeleton(),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(child: SkeletonBox(width: double.infinity, height: 46, radius: 12)),
                      SizedBox(width: 12),
                      Expanded(child: SkeletonBox(width: double.infinity, height: 46, radius: 12)),
                    ],
                  ),
                  SizedBox(height: 24),
                  SkeletonLine(width: 120),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      SkeletonBox(width: 52, height: 34, radius: 20),
                      SizedBox(width: 8),
                      SkeletonBox(width: 72, height: 34, radius: 20),
                      SizedBox(width: 8),
                      SkeletonBox(width: 64, height: 34, radius: 20),
                    ],
                  ),
                  SizedBox(height: 12),
                  _TransactionSkeleton(),
                  SizedBox(height: 10),
                  _TransactionSkeleton(),
                  SizedBox(height: 10),
                  _TransactionSkeleton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LedgerChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LedgerChip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primary
              : (isDark ? AppColors.surfaceDark : AppColors.mutedLight),
        borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          label,
          style: AppTypography.label(isDark: isDark).copyWith(
            color: selected ? AppColors.primaryForeground : null,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  final double holdBalance;
  final bool isDark;

  const _BalanceCard({required this.balance, required this.holdBalance, required this.isDark});

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
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryForeground.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.lock_clock_outlined, size: 14, color: AppColors.primaryForeground),
                const SizedBox(width: 6),
                Text(
                  'On Hold ৳${holdBalance.toStringAsFixed(0)}',
                  style: AppTypography.bodyMedium(isDark: false).copyWith(
                    color: AppColors.primaryForeground.withValues(alpha: 0.85),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
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

  bool get _isCredit {
    switch (transaction.type) {
      case TransactionType.topUp:
      case TransactionType.refund:
      case TransactionType.cashback:
        return true;
      case TransactionType.payment:
      case TransactionType.withdrawal:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isCredit = _isCredit;
    final color = isCredit ? AppColors.success : AppColors.destructive;
    final icon = isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded;
    return GlassCard(
      padding: const EdgeInsets.all(14),
      radius: 12,
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

class _BalanceCardSkeleton extends StatelessWidget {
  const _BalanceCardSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              SkeletonBox(width: 20, height: 20, radius: 6),
              SizedBox(width: 8),
              SkeletonLine(width: 110),
            ],
          ),
          const SizedBox(height: 16),
          const SkeletonLine(width: 140, height: 30),
          const SizedBox(height: 12),
          SkeletonBox(width: 120, height: 30, radius: 10),
          const SizedBox(height: 14),
          SkeletonLine(width: 90),
        ],
      ),
    );
  }
}

class _TransactionSkeleton extends StatelessWidget {
  const _TransactionSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : AppColors.cardLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          return Row(
            children: [
              const SkeletonBox(width: 36, height: 36, radius: 10),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonLine(width: w * 0.5),
                    const SizedBox(height: 4),
                    SkeletonLine(width: w * 0.3),
                  ],
                ),
              ),
              SkeletonLine(width: 44),
            ],
          );
        },
      ),
    );
  }
}
