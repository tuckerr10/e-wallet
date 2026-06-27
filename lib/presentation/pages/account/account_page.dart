import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:dio/dio.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_badge.dart';
import '../../widgets/feature_icon.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _purchaseCount = 0;
  bool _loadingCount = true;

  @override
  void initState() {
    super.initState();
    _fetchPurchaseCount();
  }

  Future<void> _fetchPurchaseCount() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        setState(() => _loadingCount = false);
        return;
      }

      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 4),
        receiveTimeout: const Duration(seconds: 4),
      ));
      
      final response = await dio.get(
        'http://192.168.1.107:8080/v1/purchases',
        options: Options(headers: {'Authorization': 'Bearer $uid'}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'] as List<dynamic>?;
        if (data != null) {
          int count = 0;
          for (var item in data) {
            count += (item['quantity'] as num? ?? 1).toInt();
          }
          setState(() {
            _purchaseCount = count;
            _loadingCount = false;
          });
          return;
        }
      }
    } catch (e) {
      debugPrint('[AccountPage] Error fetching purchase count: $e');
    }
    setState(() => _loadingCount = false);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go('/');
        }
      },
      builder: (context, state) {
        final user = state is AuthAuthenticated ? state.user : null;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F5FF),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Header
                Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.splashGradient,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32),
                      bottomRight: Radius.circular(32),
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(
                      20, MediaQuery.of(context).padding.top + 16, 20, 32),
                  child: Row(
                    children: [
                      AppAvatar(
                        name: user?.name ?? 'User',
                        size: 64,
                        bg: Colors.white.withValues(alpha: 0.2),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.name ?? 'Pengguna',
                                style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -0.3,
                                )),
                            const SizedBox(height: 2),
                            Text(user?.email ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 13,
                                  color: Colors.white70,
                                )),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.verified_user_rounded, size: 14, color: AppColors.neon),
                            SizedBox(width: 5),
                            Text('WF Member',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Section: E-Commerce
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text('E-Commerce Terhubung',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.slate500,
                            )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: AppColors.shadowSoft,
                        ),
                        child: Column(
                          children: [
                            _Row(
                              icon: Icons.shopping_bag_outlined,
                              tone: 'violet',
                              title: 'Bag Store',
                              subtitle: _loadingCount 
                                  ? 'Memuat riwayat...' 
                                  : 'Terhubung · $_purchaseCount produk dibeli',
                              onTap: () async {
                                final result = await context.push('/bag-store');
                                if (result == true) {
                                  setState(() => _loadingCount = true);
                                  _fetchPurchaseCount();
                                }
                              },
                              right: const AppBadge(label: 'Online', tone: 'green'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section: Keamanan
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text('Keamanan',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.slate500,
                            )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: AppColors.shadowSoft,
                        ),
                        child: Column(
                          children: [
                            _Row(
                              icon: Icons.verified_user_outlined,
                              tone: 'green',
                              title: 'Verifikasi 2 langkah (2FA)',
                              subtitle: 'Aktif · Email OTP',
                              onTap: () => context.go('/setup-2fa'),
                              right: const AppBadge(label: 'Aktif', tone: 'green'),
                            ),
                            const Divider(height: 1, indent: 56, color: AppColors.line2),
                            _Row(
                              icon: Icons.lock_outline_rounded,
                              tone: 'blue',
                              title: 'Ubah PIN keamanan',
                              subtitle: 'Terakhir diubah 2 bln lalu',
                              onTap: () {},
                            ),
                            const Divider(height: 1, indent: 56, color: AppColors.line2),
                            _Row(
                              icon: Icons.fingerprint_rounded,
                              tone: 'orange',
                              title: 'Login biometrik',
                              subtitle: 'Sidik jari',
                              onTap: () {},
                              right: _Toggle(),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Section: Akun
                      const Padding(
                        padding: EdgeInsets.only(left: 4, bottom: 8),
                        child: Text('Pengaturan Akun',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: AppColors.slate500,
                            )),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: AppColors.shadowSoft,
                        ),
                        child: Column(
                          children: [
                            _Row(icon: Icons.person_outline_rounded, tone: 'blue', title: 'Data pribadi', onTap: () {}),
                            const Divider(height: 1, indent: 56, color: AppColors.line2),
                            _Row(icon: Icons.account_balance_outlined, tone: 'green', title: 'Rekening & kartu tersimpan', onTap: () {}),
                            const Divider(height: 1, indent: 56, color: AppColors.line2),
                            _Row(icon: Icons.settings_outlined, tone: 'slate', title: 'Pengaturan aplikasi', onTap: () {}),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Logout button
                      GestureDetector(
                        onTap: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: AppColors.shadowSoft,
                            border: Border.all(color: AppColors.red.withValues(alpha: 0.1)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout_rounded, size: 20, color: AppColors.red),
                              SizedBox(width: 9),
                              Text('Keluar dari Akun',
                                  style: TextStyle(
                                    fontFamily: 'PlusJakartaSans',
                                    color: AppColors.red,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 15,
                                  )),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Center(
                        child: Text('Wallet Frenzy · v2.0.0',
                            style: TextStyle(
                              fontFamily: 'PlusJakartaSans',
                              fontSize: 12,
                              color: AppColors.slate400,
                              fontWeight: FontWeight.w600,
                            )),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String tone;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? right;

  const _Row({
    required this.icon,
    required this.tone,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.right,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            FeatureIcon(icon: icon, tone: tone, size: 42, iconSize: 20),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 14.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      )),
                  if (subtitle != null) ...[
                    const SizedBox(height: 3),
                    Text(subtitle!,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 12.5,
                          color: AppColors.slate400,
                        )),
                  ],
                ],
              ),
            ),
            right ?? const Icon(Icons.chevron_right_rounded, size: 18, color: AppColors.slate400),
          ],
        ),
      ),
    );
  }
}

class _Toggle extends StatefulWidget {
  @override
  State<_Toggle> createState() => _ToggleState();
}

class _ToggleState extends State<_Toggle> {
  bool _on = true;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => setState(() => _on = !_on),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 44,
        height: 26,
        decoration: BoxDecoration(
          color: _on ? AppColors.green : AppColors.slate300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 180),
          alignment: _on ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: const EdgeInsets.all(3),
            width: 20,
            height: 20,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 3, offset: Offset(0, 1))],
            ),
          ),
        ),
      ),
    );
  }
}
