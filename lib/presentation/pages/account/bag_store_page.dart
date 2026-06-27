import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/currency_formatter.dart';

class BagStorePage extends StatefulWidget {
  const BagStorePage({super.key});

  @override
  State<BagStorePage> createState() => _BagStorePageState();
}

class _BagStorePageState extends State<BagStorePage> {
  List<dynamic> _products = [];
  bool _isLoading = true;
  String? _errorMsg;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      setState(() {
        _isLoading = true;
        _errorMsg = null;
      });

      final dio = Dio();
      final response = await dio.get('http://192.168.1.107:8080/v1/products');

      if (response.statusCode == 200 && response.data != null) {
        setState(() {
          _products = response.data['data'] as List<dynamic>? ?? [];
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
        _errorMsg = 'Koneksi ke Bag Store gagal: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _buyProduct(int productId, String productName) async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Anda harus masuk untuk membeli produk.'),
            backgroundColor: AppColors.red,
          ),
        );
        return;
      }

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation(AppColors.primary),
          ),
        ),
      );

      final dio = Dio();
      final response = await dio.post(
        'http://192.168.1.107:8080/v1/products/buy',
        options: Options(headers: {'Authorization': 'Bearer $uid'}),
        data: {'product_id': productId, 'quantity': 1},
      );

      // Dismiss loading dialog
      if (mounted) Navigator.pop(context);

      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Berhasil membeli $productName!'),
              backgroundColor: AppColors.green,
            ),
          );
        }
        // Refresh products and mark that a purchase happened
        _fetchProducts();
      } else {
        throw Exception('Response status ${response.statusCode}');
      }
    } catch (e) {
      if (mounted) {
        // Dismiss loading if dialog is showing
        Navigator.of(context).popUntil((route) => route.isFirst || route.settings.name != null);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal membeli produk: $e'),
            backgroundColor: AppColors.red,
          ),
        );
      }
    }
  }

  String _formatImageUrl(String url) {
    if (url.startsWith('http://') || url.startsWith('https://')) {
      return url;
    }
    return 'http://192.168.1.107:8080$url';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.ink, size: 20),
          // Return true if we bought something, so AccountPage can reload the purchase count
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text(
          'Bag Store Partner',
          style: TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            color: AppColors.ink,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.primary),
            onPressed: _fetchProducts,
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.primary),
              ),
            )
          : _errorMsg != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_off_rounded, size: 52, color: AppColors.slate400),
                        const SizedBox(height: 12),
                        Text(
                          _errorMsg!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: AppColors.slate600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _fetchProducts,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                )
              : _products.isEmpty
                  ? const Center(
                      child: Text(
                        'Tidak ada produk tersedia.',
                        style: TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          color: AppColors.slate500,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.all(16),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.70,
                        crossAxisSpacing: 14,
                        mainAxisSpacing: 14,
                      ),
                      itemCount: _products.length,
                      itemBuilder: (context, index) {
                        final product = _products[index];
                        final id = (product['id'] as num).toInt();
                        final name = product['name'] as String? ?? 'Tas Tanpa Nama';
                        final price = (product['price'] as num? ?? 0.0).toDouble();
                        final imgUrl = product['image_url'] as String? ?? '';
                        final stock = (product['stock'] as num? ?? 0).toInt();

                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppColors.shadowSoft,
                            border: Border.all(color: AppColors.line.withValues(alpha: 0.5), width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Product Image
                              Expanded(
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.line2,
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(18),
                                          topRight: Radius.circular(18),
                                        ),
                                      ),
                                      width: double.infinity,
                                      height: double.infinity,
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(18),
                                          topRight: Radius.circular(18),
                                        ),
                                        child: Image.network(
                                          _formatImageUrl(imgUrl),
                                          fit: BoxFit.cover,
                                          errorBuilder: (_, __, ___) => const Center(
                                            child: Icon(
                                              Icons.shopping_bag_outlined,
                                              size: 40,
                                              color: AppColors.slate400,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    // Stock badge
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: stock > 0 ? AppColors.green : AppColors.red,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          stock > 0 ? 'Stok: $stock' : 'Habis',
                                          style: const TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: 10,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Details
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      CurrencyFormatter.format(price),
                                      style: const TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 14,
                                        fontWeight: FontWeight.w900,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    SizedBox(
                                      width: double.infinity,
                                      height: 34,
                                      child: ElevatedButton(
                                        onPressed: stock > 0 ? () => _buyProduct(id, name) : null,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          disabledBackgroundColor: AppColors.slate300,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          elevation: 0,
                                          padding: EdgeInsets.zero,
                                        ),
                                        child: const Text(
                                          'Beli',
                                          style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w800,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}
