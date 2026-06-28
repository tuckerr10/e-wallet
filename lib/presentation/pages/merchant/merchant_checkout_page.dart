import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/feature_icon.dart';

const _bagStoreGreen = Color(0xFFB5F000);
const _bagStoreDark = Color(0xFF111111);

class MerchantCheckoutPage extends StatefulWidget {
  const MerchantCheckoutPage({super.key});

  @override
  State<MerchantCheckoutPage> createState() => _MerchantCheckoutPageState();
}

class _MerchantCheckoutPageState extends State<MerchantCheckoutPage> {
  List<Map<String, dynamic>> _cartItems = [];
  Set<int> _selectedItemIds = {};
  bool _isLoading = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  Future<void> _fetchCart() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        setState(() {
          _errorMsg = 'Kamu harus login terlebih dahulu.';
          _isLoading = false;
        });
        return;
      }

      final token = await user.getIdToken();
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));

      // Fetch all products instead of cart
      final response = await dio.get(
        'http://192.168.1.107:8080/v1/products',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final List<dynamic> items = data['data'] as List<dynamic>? ?? [];
        setState(() {
          _cartItems = items.map((e) {
            final m = Map<String, dynamic>.from(e as Map);
            m['quantity'] = 1; // dummy quantity
            return m;
          }).toList();
          _selectedItemIds.clear();
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMsg = 'Gagal mengambil data produk.';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMsg = 'Koneksi ke Bag Store gagal.';
        _isLoading = false;
      });
      debugPrint('Error fetch products: $e');
    }
  }

  String _formatImageUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return 'http://192.168.1.107:8080$url';
  }

  double get _subtotal {
    return _cartItems.where((item) => _selectedItemIds.contains(item['id'])).fold(0.0, (sum, item) {
      final price = (item['price'] as num?)?.toDouble() ?? 0.0;
      final qty = (item['quantity'] as num?)?.toInt() ?? 1;
      return sum + (price * qty);
    });
  }

  @override
  Widget build(BuildContext context) {
    const ship = 12000.0;
    final total = _selectedItemIds.isEmpty ? 0.0 : _subtotal + ship;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: [
          // Bag Store header
          Container(
            color: _bagStoreDark,
            padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 6, 16, 14),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                  onPressed: () => context.go('/home'),
                ),
                const Expanded(
                  child: Text('Pembayaran',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      )),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: _bagStoreGreen.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.shopping_bag_outlined, size: 14, color: _bagStoreGreen),
                      const SizedBox(width: 6),
                      Text('Bag Store',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: _bagStoreGreen,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Body
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                : _errorMsg != null
                    ? _buildError()
                    : _cartItems.isEmpty
                        ? _buildEmptyCart()
                        : _buildCartContent(ship, total),
          ),

          // Pay bar (only if cart has items and not loading/error)
          if (!_isLoading && _errorMsg == null && _cartItems.isNotEmpty)
            Container(
              color: Colors.white,
              padding: EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 16),
              child: AppButton(
                label: _selectedItemIds.isEmpty ? 'Pilih Produk' : 'Bayar ${CurrencyFormatter.format(total)}',
                onPressed: _selectedItemIds.isEmpty ? null : () {
                  final reference = 'dummy:${_selectedItemIds.join(',')}';
                  final user = FirebaseAuth.instance.currentUser;
                  final userIdentifier = user?.email ?? user?.uid ?? '';

                  context.go('/pin', extra: {
                    'kind': 'deeplink',
                    'description': 'Pembelian di Bag Store',
                    'amount': total,
                    'merchantName': 'Bag Store',
                    'merchantId': 'bagstore',
                    'reference': reference,
                    'callbackUrl': 'bagstore://pay-callback',
                    'merchantUserToken': userIdentifier,
                  });
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FeatureIcon(icon: Icons.cloud_off_rounded, tone: 'red', size: 64, iconSize: 30),
            const SizedBox(height: 16),
            Text(_errorMsg!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: AppColors.slate600,
                )),
            const SizedBox(height: 16),
            AppButton(
              label: 'Coba Lagi',
              fullWidth: false,
              onPressed: _fetchCart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const FeatureIcon(icon: Icons.shopping_cart_outlined, tone: 'slate', size: 64, iconSize: 30),
            const SizedBox(height: 16),
            const Text('Produk Kosong',
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                )),
            const SizedBox(height: 6),
            const Text('Gagal memuat produk dari Bag Store.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'PlusJakartaSans',
                  fontSize: 13.5,
                  color: AppColors.slate500,
                  height: 1.5,
                )),
            const SizedBox(height: 20),
            AppButton(
              label: 'Kembali ke Beranda',
              fullWidth: false,
              onPressed: () => context.go('/home'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartContent(double ship, double total) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
      child: Column(
        children: [
          // Order items
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppColors.shadowSoft,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text('Produk Bag Store · ${_cartItems.length} item',
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.slate400,
                      )),
                ),
                ..._cartItems.asMap().entries.map((e) {
                  final i = e.key;
                  final item = e.value;
                  final name = item['name'] as String? ?? 'Produk';
                  final price = (item['price'] as num?)?.toDouble() ?? 0.0;
                  final qty = (item['quantity'] as num?)?.toInt() ?? 1;
                  final imgUrl = item['image_url'] as String? ?? item['imageUrl'] as String? ?? '';

                  return Column(
                    children: [
                      if (i > 0) const Divider(height: 1, color: AppColors.line2),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        child: Row(
                          children: [
                            Checkbox(
                              value: _selectedItemIds.contains(item['id']),
                              onChanged: (val) {
                                setState(() {
                                  if (val == true) {
                                    _selectedItemIds.add(item['id'] as int);
                                  } else {
                                    _selectedItemIds.remove(item['id']);
                                  }
                                });
                              },
                              activeColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: imgUrl.isNotEmpty
                                  ? Image.network(
                                      _formatImageUrl(imgUrl),
                                      width: 46,
                                      height: 46,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Container(
                                        width: 46,
                                        height: 46,
                                        decoration: BoxDecoration(
                                          color: AppColors.primarySurface,
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: const Center(
                                          child: Icon(Icons.shopping_bag_outlined, size: 22, color: AppColors.primary),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        color: AppColors.primarySurface,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: const Center(
                                        child: Icon(Icons.shopping_bag_outlined, size: 22, color: AppColors.primary),
                                      ),
                                    ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      )),
                                  Text(
                                      '$qty × ${CurrencyFormatter.format(price)}',
                                      style: const TextStyle(fontSize: 12.5, color: AppColors.slate400)),
                                ],
                              ),
                            ),
                            Text(
                              CurrencyFormatter.format(price * qty),
                              style: const TextStyle(
                                fontFamily: 'PlusJakartaSans',
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Payment method
          const Padding(
            padding: EdgeInsets.only(left: 4, bottom: 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Metode pembayaran',
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.slate400,
                  )),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppColors.shadowSoft,
              border: Border.all(color: AppColors.primaryLight, width: 1.8),
            ),
            child: Row(
              children: [
                const AppLogo(size: 40),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Wallet Frenzy',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          )),
                      Text('Saldo · pembayaran instan',
                          style: TextStyle(fontSize: 12.5, color: AppColors.slate400)),
                    ],
                  ),
                ),
                const Icon(Icons.check_rounded, size: 20, color: AppColors.primary),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Totals
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppColors.shadowSoft,
            ),
            child: Column(
              children: [
                _TotalLine(label: 'Subtotal', value: CurrencyFormatter.format(_subtotal)),
                const Divider(height: 1, color: AppColors.line2),
                _TotalLine(label: 'Ongkos kirim', value: CurrencyFormatter.format(ship)),
                const Divider(height: 1, color: AppColors.line2),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 15.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.slate600,
                          )),
                      Text(CurrencyFormatter.format(total),
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          )),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TotalLine extends StatelessWidget {
  final String label;
  final String value;
  const _TotalLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(fontSize: 14, color: AppColors.slate500, fontFamily: 'PlusJakartaSans')),
          Text(value,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.ink, fontFamily: 'PlusJakartaSans')),
        ],
      ),
    );
  }
}
