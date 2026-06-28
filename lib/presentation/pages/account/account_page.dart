import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/api_client.dart';
import '../../../injection/injection_container.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/app_avatar.dart';
import '../../widgets/app_badge.dart';
import '../../../core/utils/local_notification_helper.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  bool _bagStoreConnected = false;
  bool _loadingConnection = true;

  @override
  void initState() {
    super.initState();
    _fetchConnectionStatus();
  }

  Future<void> _fetchConnectionStatus() async {
    try {
      final client = sl<ApiClient>();
      final response = await client.get('/v1/auth/connection');
      if (response['success'] == true) {
        setState(() {
          _bagStoreConnected = response['connected'] as bool? ?? false;
          _loadingConnection = false;
        });
        return;
      }
    } catch (e) {
      debugPrint('[AccountPage] Error fetching connection status: $e');
    }
    setState(() => _loadingConnection = false);
  }

  Future<void> _toggleConnection() async {
    setState(() => _loadingConnection = true);
    try {
      final client = sl<ApiClient>();
      final response = await client.post('/v1/auth/connection/toggle');
      if (response['success'] == true) {
        setState(() {
          _bagStoreConnected = response['connected'] as bool? ?? false;
          _loadingConnection = false;
        });
        LocalNotificationHelper.showNotification(
          id: 5,
          title: 'Status Koneksi E-Commerce',
          body: _bagStoreConnected ? 'Bag Store berhasil terhubung!' : 'Koneksi Bag Store diputuskan.',
        );
        return;
      }
    } catch (e) {
      debugPrint('[AccountPage] Error toggling connection: $e');
      if (mounted) {
        LocalNotificationHelper.showNotification(
          id: 6,
          title: 'Gagal memperbarui koneksi',
          body: 'Pastikan backend be-emoney sudah berjalan!',
        );
      }
    }
    setState(() => _loadingConnection = false);
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
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Padding(
                  padding: EdgeInsets.fromLTRB(24, MediaQuery.of(context).padding.top + 32, 24, 24),
                  child: Row(
                    children: [
                      AppAvatar(
                        name: user?.name ?? 'User',
                        size: 60,
                        bg: const Color(0xFFF5F5F5),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user?.name ?? 'Pengguna',
                                style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.black,
                                  letterSpacing: -0.5,
                                )),
                            const SizedBox(height: 2),
                            Text(user?.email ?? '',
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 14,
                                  color: Colors.black54,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1, color: Color(0xFFEEEEEE)),

                // Section: E-Commerce
                _SectionTitle(title: 'Koneksi E-Commerce'),
                _Row(
                  icon: Icons.shopping_bag_outlined,
                  title: 'Bag Store',
                  subtitle: _loadingConnection
                      ? 'Memuat status koneksi...'
                      : _bagStoreConnected
                          ? 'Terhubung'
                          : 'Belum terhubung',
                  onTap: () {
                    _toggleConnection();
                  },
                  right: _loadingConnection
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(Colors.black),
                          ),
                        )
                      : Switch.adaptive(
                          value: _bagStoreConnected,
                          onChanged: (_) => _toggleConnection(),
                          activeTrackColor: Colors.black,
                        ),
                ),

                const Divider(height: 1, color: Color(0xFFEEEEEE)),

                // Section: Keamanan
                _SectionTitle(title: 'Keamanan'),
                _Row(
                  icon: Icons.verified_user_outlined,
                  title: 'Verifikasi 2 langkah (2FA)',
                  subtitle: 'Aktif · Email OTP',
                  onTap: () => context.go('/setup-2fa'),
                  right: const AppBadge(label: 'Aktif', tone: 'green'),
                ),
                _Row(
                  icon: Icons.lock_outline_rounded,
                  title: 'Ubah PIN keamanan',
                  subtitle: 'Terakhir diubah 2 bln lalu',
                  onTap: () {},
                ),
                _Row(
                  icon: Icons.fingerprint_rounded,
                  title: 'Login biometrik',
                  subtitle: 'Sidik jari',
                  onTap: () {},
                  right: _Toggle(),
                ),

                const Divider(height: 1, color: Color(0xFFEEEEEE)),

                // Section: Akun
                _SectionTitle(title: 'Pengaturan Akun'),
                _Row(icon: Icons.person_outline_rounded, title: 'Data pribadi', onTap: () {}),
                _Row(icon: Icons.account_balance_outlined, title: 'Rekening & kartu tersimpan', onTap: () {}),
                _Row(icon: Icons.settings_outlined, title: 'Pengaturan aplikasi', onTap: () {}),
                _Row(icon: Icons.help_outline_rounded, title: 'Pusat bantuan', onTap: () {}),

                const Divider(height: 1, color: Color(0xFFEEEEEE)),
                
                const SizedBox(height: 32),
                
                // Logout button
                Center(
                  child: GestureDetector(
                    onTap: () => context.read<AuthBloc>().add(AuthLogoutRequested()),
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      child: Text('Keluar dari Akun',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            color: Colors.red,
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                          )),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                const Center(
                  child: Text('Wallet Frenzy · v2.0.0',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                        color: Colors.black38,
                        fontWeight: FontWeight.w600,
                      )),
                ),
                
                // Extra padding at the bottom to prevent overlap with dynamic island tab bar
                const SizedBox(height: 120),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
      child: Text(title,
          style: const TextStyle(
            fontFamily: 'PlusJakartaSans',
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: Colors.black45,
            letterSpacing: 0.5,
          )),
    );
  }
}

class _Row extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final Widget? right;

  const _Row({
    required this.icon,
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            Icon(icon, color: Colors.black87, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      )),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(subtitle!,
                        style: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 13,
                          color: Colors.black54,
                          fontWeight: FontWeight.w500,
                        )),
                  ],
                ],
              ),
            ),
            if (right != null) right!
            else const Icon(Icons.chevron_right_rounded, size: 20, color: Colors.black26),
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
          color: _on ? Colors.black : const Color(0xFFE0E0E0),
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
