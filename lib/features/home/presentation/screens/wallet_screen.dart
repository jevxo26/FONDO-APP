import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_glow.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../core/widgets/press_scale.dart';
import '../../../../core/widgets/skeleton.dart';
import '../../../../models/wallet_transaction.dart';

double _balance = 1280.0;
double _holdBalance = 150.0;
double _cashbackEarned = 420.0;
bool _refundAccountActivated = false;

final List<WalletTransaction> _transactions = [
  WalletTransaction(id: 'tx_001', type: TransactionType.topUp, amount: 500, description: 'Wallet top-up via bKash', timestamp: DateTime(2026, 8, 24, 14, 30)),
  WalletTransaction(id: 'tx_002', type: TransactionType.payment, amount: 350, description: 'Kacchi Biryani x2 — Sultans Dine', timestamp: DateTime(2026, 8, 23, 20, 15)),
  WalletTransaction(id: 'tx_003', type: TransactionType.refund, amount: 180, description: 'Instant Refund — Order #FO-8821', timestamp: DateTime(2026, 8, 22, 11, 45)),
  WalletTransaction(id: 'tx_004', type: TransactionType.cashback, amount: 65, description: 'FONDO Pro 5% Weekend Cashback', timestamp: DateTime(2026, 8, 20, 18, 00)),
  WalletTransaction(id: 'tx_005', type: TransactionType.topUp, amount: 1000, description: 'Wallet top-up via Nagad', timestamp: DateTime(2026, 8, 18, 16, 20)),
  WalletTransaction(id: 'tx_006', type: TransactionType.payment, amount: 420, description: 'FONDO Mart Grocery Essentials', timestamp: DateTime(2026, 8, 17, 19, 10)),
  WalletTransaction(id: 'tx_007', type: TransactionType.withdrawal, amount: 300, description: 'Withdrawal to bKash (017•••••882)', timestamp: DateTime(2026, 8, 15, 12, 05)),
  WalletTransaction(id: 'tx_008', type: TransactionType.cashback, amount: 45, description: 'PRO Member Friday Bonus', timestamp: DateTime(2026, 8, 12, 21, 30)),
  WalletTransaction(id: 'tx_009', type: TransactionType.payment, amount: 250, description: 'Beef Tehari & Borhani', timestamp: DateTime(2026, 8, 10, 13, 40)),
  WalletTransaction(id: 'tx_010', type: TransactionType.topUp, amount: 800, description: 'Wallet top-up via Card', timestamp: DateTime(2026, 8, 5, 10, 15)),
];

const _quickAmounts = [100, 200, 500, 1000, 2000, 5000];

const _topUpMethods = [
  ('bKash', Icons.phone_android_rounded, Color(0xFFE2136E)),
  ('Nagad', Icons.smartphone_rounded, Color(0xFFF6921E)),
  ('Card', Icons.credit_card_rounded, Color(0xFF0F6FDE)),
];

const _payoutMethods = ['bKash', 'Nagad', 'City Bank', 'BRAC Bank'];

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
    Future.delayed(const Duration(milliseconds: 1400), () {
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

  void _showRefundOnboardingModal() {
    HapticFeedback.mediumImpact();
    String selectedMethod = 'bKash';
    final accountCtr = TextEditingController(text: '01712345678');
    bool agreeTerms = true;

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useRootNavigator: true,
      backgroundColor: Colors.transparent,
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetCtx, setSheetState) {
          final isDark = Theme.of(sheetCtx).brightness == Brightness.dark;
          return Container(
            padding: EdgeInsets.fromLTRB(24, 20, 24, MediaQuery.of(sheetCtx).viewInsets.bottom + 28),
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
                const SizedBox(height: 18),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.verified_user_rounded, color: AppColors.success, size: 24),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Activate Refund Account', style: AppTypography.titleLarge(isDark: isDark)),
                          const SizedBox(height: 2),
                          Text('Instant auto-refunds in under 60 seconds', style: AppTypography.small(isDark: isDark)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : AppColors.mutedLight,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.bolt_rounded, color: Colors.orange, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Failed or cancelled orders are immediately credited back to your designated account.',
                              style: TextStyle(fontSize: 12, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.lock_outline_rounded, color: Colors.blue, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'End-to-end 256-bit encrypted banking security.',
                              style: TextStyle(fontSize: 12, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                Text('Select Payout Channel', style: AppTypography.label(isDark: isDark)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 10,
                  children: ['bKash', 'Nagad', 'Bank Account'].map((m) {
                    final selected = selectedMethod == m;
                    return ChoiceChip(
                      label: Text(m),
                      selected: selected,
                      selectedColor: AppColors.primary,
                      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.mutedLight,
                      labelStyle: TextStyle(color: selected ? AppColors.primaryForeground : null),
                      onSelected: (_) {
                        HapticFeedback.selectionClick();
                        setSheetState(() => selectedMethod = m);
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 14),
                TextField(
                  controller: accountCtr,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: '$selectedMethod Account / Mobile Number',
                    hintText: '01XXXXXXXXX',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: const Icon(Icons.account_balance_rounded, size: 20),
                  ),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Checkbox(
                      value: agreeTerms,
                      activeColor: AppColors.primary,
                      onChanged: (v) => setSheetState(() => agreeTerms = v ?? true),
                    ),
                    const Expanded(
                      child: Text(
                        'I accept FONDO Refund Account Terms & Conditions and 2-way verification policy.',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: agreeTerms
                        ? () {
                            HapticFeedback.heavyImpact();
                            Navigator.of(sheetCtx).pop();
                            setState(() => _refundAccountActivated = true);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('🎉 Refund Account activated for $selectedMethod (${accountCtr.text})!'),
                                backgroundColor: AppColors.success,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        : null,
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: AppColors.primaryForeground,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Confirm & Activate', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showTopUpModal() {
    final amountCtr = TextEditingController();
    final messenger = ScaffoldMessenger.of(context);
    int? quickAmount;
    String? method = 'bKash';
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
                      child: Text('Instant 0% Fee', style: AppTypography.badge(isDark: isDark).copyWith(color: AppColors.primary)),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text('Choose an amount or enter custom value', style: AppTypography.bodyMedium(isDark: isDark)),
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
                    filled: true,
                    fillColor: isDark ? AppColors.inputFillDark : AppColors.inputFillLight,
                  ),
                  style: AppTypography.bodyLarge(isDark: isDark),
                  onChanged: (_) => setSheetState(() => quickAmount = null),
                ),
                const SizedBox(height: 18),
                Text('Payment Gateway', style: AppTypography.label(isDark: isDark)),
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
      builder: (sheetCtx) => StatefulBuilder(
        builder: (sheetCtx, setSheetState) {
          final isDark = Theme.of(sheetCtx).brightness == Brightness.dark;
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
                Text('Withdraw to Bank / Wallet', style: AppTypography.titleLarge(isDark: isDark)),
                const SizedBox(height: 4),
                Text('Available balance: ৳${_balance.toStringAsFixed(0)}', style: AppTypography.bodyMedium(isDark: isDark)),
                const SizedBox(height: 18),
                TextField(
                  controller: amountCtr,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    prefixText: '৳ ',
                    hintText: 'Enter amount to withdraw',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
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
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, size: 16, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Funds are disbursed instantly for verified MFS numbers, or within 2 hours for banks.',
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
                          content: Text('৳${parsed.toStringAsFixed(0)} withdrawal requested to $method'),
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
                    child: const Text('Confirm Withdrawal', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
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
        title: const Text('Refund Account & Wallet'),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('FONDO Wallet supports instant refunds, top-ups, and cashback rewards.'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          const GlowOrbs(),
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
              children: [
                // Top Balance & Refund Card
                _BalanceCard(
                  balance: _balance,
                  holdBalance: _holdBalance,
                  cashbackEarned: _cashbackEarned,
                  isDark: isDark,
                ),
                const SizedBox(height: 16),

                // Refund Setup Prompt Card (if not activated or banner)
                if (!_refundAccountActivated)
                  _RefundSetupCard(
                    isDark: isDark,
                    onTap: _showRefundOnboardingModal,
                  ),
                if (!_refundAccountActivated) const SizedBox(height: 16),

                // Quick Action Buttons (Add Money, Withdraw)
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Transaction Ledger Header & Filters
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Transaction History',
                      style: AppTypography.titleMedium(isDark: isDark).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      '${_filteredTransactions.length} items',
                      style: AppTypography.small(isDark: isDark),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Filter Chips
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
                const SizedBox(height: 14),

                // Transactions List
                if (_filteredTransactions.isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: Center(
                      child: Text('No transactions found in this category', style: AppTypography.bodyMedium(isDark: isDark)),
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
        title: const Text('Refund Account & Wallet'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: const [
            SkeletonBox(width: double.infinity, height: 180, radius: 20),
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: SkeletonBox(width: double.infinity, height: 48, radius: 14)),
                SizedBox(width: 12),
                Expanded(child: SkeletonBox(width: double.infinity, height: 48, radius: 14)),
              ],
            ),
            SizedBox(height: 24),
            SkeletonLine(width: 140, height: 16),
            SizedBox(height: 14),
            Row(
              children: [
                SkeletonBox(width: 54, height: 34, radius: 20),
                SizedBox(width: 8),
                SkeletonBox(width: 76, height: 34, radius: 20),
                SizedBox(width: 8),
                SkeletonBox(width: 76, height: 34, radius: 20),
              ],
            ),
            SizedBox(height: 14),
            SkeletonBox(width: double.infinity, height: 64, radius: 14),
            SizedBox(height: 10),
            SkeletonBox(width: double.infinity, height: 64, radius: 14),
            SizedBox(height: 10),
            SkeletonBox(width: double.infinity, height: 64, radius: 14),
          ],
        ),
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final double balance;
  final double holdBalance;
  final double cashbackEarned;
  final bool isDark;

  const _BalanceCard({
    required this.balance,
    required this.holdBalance,
    required this.cashbackEarned,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E88E5), Color(0xFF1565C0), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1565C0).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.verified_rounded, color: Colors.lightGreenAccent, size: 18),
                  SizedBox(width: 6),
                  Text(
                    'FONDO REFUND ACCOUNT',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      letterSpacing: 1.1,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'SSL Encrypted',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            '৳${balance.toStringAsFixed(0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 2),
          const Text(
            'Available for instant checkout & withdrawal',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_clock_outlined, size: 13, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      'Hold: ৳${holdBalance.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.savings_outlined, size: 13, color: Colors.amberAccent),
                    const SizedBox(width: 4),
                    Text(
                      'Earned: ৳${cashbackEarned.toStringAsFixed(0)}',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RefundSetupCard extends StatelessWidget {
  final bool isDark;
  final VoidCallback onTap;

  const _RefundSetupCard({required this.isDark, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return PressScale(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: Colors.blue.withValues(alpha: 0.3)),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.bolt_rounded, color: Colors.blue, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Activate Instant Auto-Refunds',
                      style: AppTypography.titleMedium(isDark: isDark).copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Link your bKash or Bank for automated 60-second refund credits.',
                      style: AppTypography.small(isDark: isDark).copyWith(fontSize: 11),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: Colors.blue, size: 22),
            ],
          ),
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
          borderRadius: BorderRadius.circular(20),
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

class _TransactionRow extends StatelessWidget {
  final WalletTransaction transaction;
  final bool isDark;

  const _TransactionRow({required this.transaction, required this.isDark});

  String _formatDate(DateTime dt) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${dt.day} ${months[dt.month - 1]} • ${_formatTime(dt)}';
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final minute = dt.minute.toString().padLeft(2, '0');
    final period = dt.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
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
    final color = switch (transaction.type) {
      TransactionType.topUp => AppColors.success,
      TransactionType.refund => const Color(0xFF2196F3),
      TransactionType.cashback => const Color(0xFF9C27B0),
      TransactionType.payment => AppColors.destructive,
      TransactionType.withdrawal => Colors.orange,
    };

    final icon = switch (transaction.type) {
      TransactionType.topUp => Icons.add_circle_outline_rounded,
      TransactionType.refund => Icons.replay_rounded,
      TransactionType.cashback => Icons.savings_outlined,
      TransactionType.payment => Icons.shopping_bag_outlined,
      TransactionType.withdrawal => Icons.arrow_outward_rounded,
    };

    return GlassCard(
      padding: const EdgeInsets.all(14),
      radius: 16,
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.description,
                  style: AppTypography.bodyMedium(isDark: isDark).copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(transaction.timestamp),
                  style: AppTypography.small(isDark: isDark).copyWith(fontSize: 11),
                ),
              ],
            ),
          ),
          Text(
            '${isCredit ? '+' : '-'}৳${transaction.amount.toStringAsFixed(0)}',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
