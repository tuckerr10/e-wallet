import 'package:flutter/material.dart';

class AppTabBar extends StatelessWidget {
  final String active;
  final ValueChanged<String> onTab;
  final VoidCallback? onScan;

  const AppTabBar({
    super.key,
    required this.active,
    required this.onTab,
    this.onScan,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 16),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black, // Dark dynamic island theme
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _TabItem(
              iconOutlined: Icons.home_outlined,
              iconFilled: Icons.home_rounded,
              label: 'Home',
              tabKey: 'home',
              active: active,
              onTap: onTab,
            ),
            _TabItem(
              iconOutlined: Icons.receipt_long_outlined,
              iconFilled: Icons.receipt_long_rounded,
              label: 'Riwayat',
              tabKey: 'history',
              active: active,
              onTap: onTab,
            ),
            // Center scan button
            GestureDetector(
              onTap: onScan,
              behavior: HitTestBehavior.opaque,
              child: Container(
                width: 52,
                height: 52,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.qr_code_scanner_rounded, color: Colors.black, size: 24),
              ),
            ),
            _TabItem(
              iconOutlined: Icons.credit_card_outlined,
              iconFilled: Icons.credit_card_rounded,
              label: 'Cards',
              tabKey: 'promo',
              active: active,
              onTap: onTab,
            ),
            _TabItem(
              iconOutlined: Icons.person_outline_rounded,
              iconFilled: Icons.person_rounded,
              label: 'Akun',
              tabKey: 'akun',
              active: active,
              onTap: onTab,
            ),
          ],
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final IconData iconOutlined;
  final IconData iconFilled;
  final String label;
  final String tabKey;
  final String active;
  final ValueChanged<String> onTap;

  const _TabItem({
    required this.iconOutlined,
    required this.iconFilled,
    required this.label,
    required this.tabKey,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isActive = active == tabKey;
    return GestureDetector(
      onTap: () => onTap(tabKey),
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 60,
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (child, anim) => ScaleTransition(scale: anim, child: child),
              child: Icon(
                isActive ? iconFilled : iconOutlined,
                key: ValueKey(isActive),
                size: 24,
                color: isActive ? Colors.white : Colors.white54,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                color: isActive ? Colors.white : Colors.white54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
