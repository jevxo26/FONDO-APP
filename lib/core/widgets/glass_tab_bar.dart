import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/cart_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';

class GlassTabBar extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const GlassTabBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const double _height = 72;
  static const double _radius = 26;
  static const Duration _animDuration = Duration(milliseconds: 300);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final media = MediaQuery.of(context);
    if (media.viewInsets.bottom > 0) return const SizedBox.shrink();

    final cartCount = ref.watch(cartProvider.select((s) => s.itemCount));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final items = [
      _TabItem(
        icon: Icons.store_outlined,
        activeIcon: Icons.store,
        label: 'Home',
      ),
      _TabItem(
        icon: Icons.card_giftcard_outlined,
        activeIcon: Icons.card_giftcard,
        label: 'Packages',
      ),
      _TabItem(
        icon: Icons.shopping_bag_outlined,
        activeIcon: Icons.shopping_bag,
        label: 'Cart',
        badgeCount: cartCount,
      ),
      _TabItem(
        icon: Icons.person_outline,
        activeIcon: Icons.person,
        label: 'Profile',
      ),
    ];

    final bottomInset = media.padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottomInset > 0 ? bottomInset + 6 : 14),
      child: Container(
        height: _height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_radius),
          boxShadow: [
            BoxShadow(
              color: (isDark ? Colors.black : const Color(0x1F1E1A16))
                  .withValues(alpha: isDark ? 0.40 : 0.12),
              offset: const Offset(0, 6),
              blurRadius: 18,
              spreadRadius: -2,
            ),
            BoxShadow(
              color: (isDark ? Colors.black : const Color(0x0F1E1A16))
                  .withValues(alpha: isDark ? 0.30 : 0.06),
              offset: const Offset(0, 18),
              blurRadius: 40,
              spreadRadius: -8,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(_radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.backgroundDark.withValues(alpha: 0.72)
                    : Colors.white.withValues(alpha: 0.78),
                borderRadius: BorderRadius.circular(_radius),
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.10)
                      : Colors.white.withValues(alpha: 0.85),
                  width: 1,
                ),
              ),
              child: _GlassBarBody(
                currentIndex: currentIndex,
                onTap: onTap,
                items: items,
                isDark: isDark,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _GlassBarBody extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<_TabItem> items;
  final bool isDark;

  const _GlassBarBody({
    required this.currentIndex,
    required this.onTap,
    required this.items,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final n = items.length;

    return Stack(
      fit: StackFit.expand,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cellW = constraints.maxWidth / n;
              final pillW = cellW * 0.72;
              final pillH = constraints.maxHeight * 0.9;
              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: GlassTabBar._animDuration,
                    curve: Curves.easeOutCubic,
                    left: currentIndex * cellW + (cellW - pillW) / 2,
                    top: (constraints.maxHeight - pillH) / 2 + 2,
                    width: pillW,
                    height: pillH,
                    child: Container(
                      key: const ValueKey('glassTabActivePill'),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: isDark ? 0.20 : 0.12),
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              for (var i = 0; i < n; i++)
                Expanded(
                  child: _TabButton(
                    item: items[i],
                    active: i == currentIndex,
                    isDark: isDark,
                    onTap: () => onTap(i),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TabButton extends StatefulWidget {
  final _TabItem item;
  final bool active;
  final bool isDark;
  final VoidCallback onTap;

  const _TabButton({
    required this.item,
    required this.active,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_TabButton> createState() => _TabButtonState();
}

class _TabButtonState extends State<_TabButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primary;
    final muted = widget.isDark
        ? AppColors.mutedForegroundDark
        : AppColors.mutedForegroundLight;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.88 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 28,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedOpacity(
                    opacity: widget.active ? 0 : 1,
                    duration: GlassTabBar._animDuration,
                    child: AnimatedScale(
                      scale: widget.active ? 0.8 : 1,
                      duration: GlassTabBar._animDuration,
                      child: Icon(widget.item.icon, size: 23, color: muted),
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: widget.active ? 1 : 0,
                    duration: GlassTabBar._animDuration,
                    child: AnimatedScale(
                      scale: widget.active ? 1 : 0.8,
                      duration: GlassTabBar._animDuration,
                      child: Icon(
                        widget.item.activeIcon,
                        size: 23,
                        color: primary,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 1),
            AnimatedDefaultTextStyle(
              duration: GlassTabBar._animDuration,
              style: AppTypography.label(isDark: widget.isDark).copyWith(
                fontSize: 10.5,
                letterSpacing: 0,
                fontWeight: FontWeight.w600,
                color: widget.active ? primary : muted,
              ),
              child: Text(widget.item.label),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final int badgeCount;

  const _TabItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    this.badgeCount = 0,
  });
}
