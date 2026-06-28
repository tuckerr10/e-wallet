import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/currency_formatter.dart';
import '../../domain/entities/transaction_entity.dart';
import 'feature_icon.dart';

class TransactionRow extends StatelessWidget {
  final TransactionEntity txn;
  final bool divider;

  const TransactionRow({super.key, required this.txn, this.divider = false});

  @override
  Widget build(BuildContext context) {
    final isCredit = txn.isCredit;
    final (icon, _) = _resolveIcon(txn.description); // We ignore tone now

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (divider)
          const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE), indent: 16),
        InkWell(
          onTap: () {
            context.push('/transaction/detail', extra: txn);
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: Colors.black87,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        txn.description,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _formatDate(txn.createdAt),
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12,
                          color: Colors.black.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '${isCredit ? '+' : '-'}${CurrencyFormatter.format(txn.amount)}',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isCredit ? const Color(0xFF4CAF50) : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  (IconData, String) _resolveIcon(String desc) {
    final d = desc.toLowerCase();
    if (d.contains('top up') || d.contains('topup')) return (Icons.arrow_downward_rounded, 'blue');
    if (d.contains('transfer')) return (Icons.arrow_outward_rounded, 'green');
    if (d.contains('qris') || d.contains('bayar')) return (Icons.qr_code_rounded, 'violet');
    if (d.contains('pulsa')) return (Icons.smartphone_outlined, 'blue');
    if (d.contains('tokobel') || d.contains('toko')) return (Icons.storefront_outlined, 'amber');
    if (d.contains('bag')) return (Icons.shopping_bag_outlined, 'slate');
    return (Icons.account_balance_wallet_outlined, 'slate');
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final date = DateTime(dt.year, dt.month, dt.day);
    final time = '${dt.hour.toString().padLeft(2, '0')}.${dt.minute.toString().padLeft(2, '0')}';
    if (date == today) return 'Today, $time';
    if (date == yesterday) return 'Yesterday, $time';
    return '${dt.day} ${_month(dt.month)}, $time';
  }

  String _month(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[m - 1];
  }
}
