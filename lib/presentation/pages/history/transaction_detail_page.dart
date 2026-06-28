import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../../domain/entities/transaction_entity.dart';
import '../../widgets/feature_icon.dart';

class TransactionDetailPage extends StatelessWidget {
  final TransactionEntity txn;

  const TransactionDetailPage({super.key, required this.txn});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    final isCredit = txn.isCredit;
    final (icon, tone) = _resolveIcon(txn.description);
    
    // Parse bag store items from description if exists
    final descriptionParts = txn.description.split(': ');
    final isBagStorePurchase = txn.description.toLowerCase().contains('bag store') && descriptionParts.length > 1;
    final bagStoreItems = isBagStorePurchase ? descriptionParts[1] : '';
    final mainDescription = isBagStorePurchase ? descriptionParts[0] : txn.description;

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.ink),
        title: const Text(
          'Detail Transaksi',
          style: TextStyle(
            color: AppColors.ink,
            fontWeight: FontWeight.w800,
            fontSize: 18,
            fontFamily: 'PlusJakartaSans',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 20),
              child: Column(
                children: [
                  FeatureIcon(icon: icon, tone: tone, size: 64, iconSize: 32),
                  const SizedBox(height: 16),
                  Text(
                    mainDescription,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${isCredit ? '+' : '-'}${CurrencyFormatter.format(txn.amount)}',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: isCredit ? AppColors.green : AppColors.ink,
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'Berhasil',
                      style: TextStyle(
                        color: AppColors.green,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Transaction Details
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Rincian Transaksi',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildDetailRow('Tanggal & Waktu', _formatDateFull(txn.createdAt)),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.line2),
                  const SizedBox(height: 12),
                  _buildDetailRow('ID Transaksi', 'WF-${txn.id}00${txn.id}'),
                  const SizedBox(height: 12),
                  const Divider(height: 1, color: AppColors.line2),
                  const SizedBox(height: 12),
                  _buildDetailRow('Kategori', isCredit ? 'Pemasukan' : 'Pengeluaran'),
                ],
              ),
            ),

            // Rincian Produk Bag Store (Jika ada)
            if (isBagStorePurchase) ...[
              const SizedBox(height: 12),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.shopping_bag_outlined, color: AppColors.violet, size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Daftar Produk Dibeli',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.line2),
                      ),
                      child: Text(
                        bagStoreItems,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 14,
                          height: 1.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.slate600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.slate500,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'PlusJakartaSans',
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
        ),
      ],
    );
  }

  (IconData, String) _resolveIcon(String desc) {
    final d = desc.toLowerCase();
    if (d.contains('top up') || d.contains('topup')) return (Icons.account_balance_wallet, 'blue');
    if (d.contains('transfer')) return (Icons.send_rounded, 'green');
    if (d.contains('qris') || d.contains('bayar')) return (Icons.qr_code_scanner_rounded, 'violet');
    if (d.contains('pulsa')) return (Icons.phone_android_rounded, 'blue');
    if (d.contains('bag store') || d.contains('toko')) return (Icons.shopping_bag_rounded, 'amber');
    return (Icons.account_balance_wallet, 'slate');
  }

  String _formatDateFull(DateTime dt) {
    final time = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '${dt.day} ${_month(dt.month)} ${dt.year} • $time WIB';
  }

  String _month(int m) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agt', 'Sep', 'Okt', 'Nov', 'Des'];
    return months[m - 1];
  }
}
