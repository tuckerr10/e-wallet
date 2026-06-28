import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../widgets/app_badge.dart';
import '../../widgets/app_button.dart';

const _twoFaMethods = [
  _TwoFaMethod(
    key: 'smtp',
    icon: Icons.mail_outline_rounded,
    title: 'Email OTP (SMTP)',
    desc: 'Kode 6 digit dikirim ke email kamu setiap kali masuk.',
    route: '/2fa/smtp',
  ),
  _TwoFaMethod(
    key: 'totp',
    icon: Icons.smartphone_outlined,
    title: 'Authenticator (TOTP)',
    desc: 'Kode berubah tiap 30 detik di Google Authenticator / Authy.',
    route: '/2fa/totp',
    badge: 'Paling aman',
  ),
  _TwoFaMethod(
    key: 'notif',
    icon: Icons.notifications_outlined,
    title: 'Notifikasi OTP',
    desc: 'Setujui permintaan masuk lewat notifikasi di HP kamu.',
    route: '/2fa/notif',
  ),
];

class _TwoFaMethod {
  final String key;
  final IconData icon;
  final String title;
  final String desc;
  final String route;
  final String? badge;
  const _TwoFaMethod({
    required this.key,
    required this.icon,
    required this.title,
    required this.desc,
    required this.route,
    this.badge,
  });
}

class Setup2FAPage extends StatefulWidget {
  const Setup2FAPage({super.key});
  @override
  State<Setup2FAPage> createState() => _Setup2FAPageState();
}

class _Setup2FAPageState extends State<Setup2FAPage> {
  String _selected = 'smtp';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: IconButton(
                icon: const Icon(Icons.arrow_back_rounded, color: Colors.black),
                onPressed: () => context.canPop() ? context.pop() : context.go('/akun'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 8, 26, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Center(
                      child: Icon(Icons.shield_outlined, size: 30, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text('Amankan akunmu',
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 25,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        letterSpacing: -0.4,
                      )),
                  const SizedBox(height: 7),
                  const Text(
                    'Pilih metode verifikasi 2 langkah (2FA). Kamu bisa ganti kapan saja di Pengaturan.',
                    style: TextStyle(
                      fontFamily: 'PlusJakartaSans',
                      fontSize: 14.5,
                      color: Colors.black54,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(26, 22, 26, 0),
                children: _twoFaMethods.map((m) {
                  final on = _selected == m.key;
                  return GestureDetector(
                    onTap: () => setState(() => _selected = m.key),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      margin: const EdgeInsets.only(bottom: 13),
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: on ? Colors.black : Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: on ? Colors.black : const Color(0xFFE0E0E0),
                          width: 1.8,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(m.icon, color: Colors.black87, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Flexible(
                                      child: Text(m.title,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'PlusJakartaSans',
                                            fontSize: 15.5,
                                            fontWeight: FontWeight.w700,
                                            color: on ? Colors.white : Colors.black,
                                          )),
                                    ),
                                    if (m.badge != null) ...[
                                      const SizedBox(width: 7),
                                      AppBadge(label: m.badge!, tone: 'green'),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(m.desc,
                                    style: TextStyle(
                                      fontFamily: 'PlusJakartaSans',
                                      fontSize: 12.8,
                                      color: on ? Colors.white70 : Colors.black54,
                                      height: 1.45,
                                    )),
                              ],
                            ),
                          ),
                          const SizedBox(width: 14),
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: 22,
                            height: 22,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: on ? Colors.white : Colors.white,
                              border: Border.all(
                                color: on ? Colors.white : const Color(0xFFE0E0E0),
                                width: 2,
                              ),
                            ),
                            child: on
                                ? Center(
                                    child: Container(
                                      width: 9,
                                      height: 9,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(26, 14, 26, 22),
              child: AppButton(
                label: 'Lanjutkan',
                variant: AppButtonVariant.dark,
                onPressed: () {
                  final m = _twoFaMethods.firstWhere((m) => m.key == _selected);
                  context.go(m.route, extra: {'mode': 'setup'});
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
