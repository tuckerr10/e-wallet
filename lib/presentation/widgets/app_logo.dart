import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool light;
  final bool withText;

  const AppLogo({super.key, this.size = 56, this.light = false, this.withText = false});

  @override
  Widget build(BuildContext context) {
    final Widget icon = _WalletFrenzyIcon(size: size, light: light);
    if (!withText) return icon;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        icon,
        const SizedBox(width: 12),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Wallet',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: size * 0.32,
                fontWeight: FontWeight.w900,
                color: light ? Colors.white : AppColors.ink,
                letterSpacing: -0.5,
                height: 1.0,
              ),
            ),
            Text(
              'Frenzy',
              style: TextStyle(
                fontFamily: 'PlusJakartaSans',
                fontSize: size * 0.32,
                fontWeight: FontWeight.w900,
                color: light ? AppColors.neon : AppColors.primary,
                letterSpacing: -0.5,
                height: 1.0,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _WalletFrenzyIcon extends StatelessWidget {
  final double size;
  final bool light;

  const _WalletFrenzyIcon({required this.size, this.light = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: light
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFFFFFF), Color(0xFFE0D4FF)],
              )
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(size * 0.28),
        boxShadow: light ? [] : AppColors.shadowPrimary,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Wallet icon
          Icon(
            Icons.account_balance_wallet_rounded,
            size: size * 0.54,
            color: light ? AppColors.primary : Colors.white,
          ),
          // Lightning bolt accent (top-right)
          Positioned(
            top: size * 0.08,
            right: size * 0.08,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: light ? AppColors.primary.withValues(alpha: 0.15) : Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Icon(
                  Icons.bolt_rounded,
                  size: size * 0.18,
                  color: light ? AppColors.primary : AppColors.neon,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
