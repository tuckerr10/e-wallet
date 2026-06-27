import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../blocs/auth/auth_bloc.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _logoController;
  late final AnimationController _contentController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoFade;
  late final Animation<double> _contentFade;
  late final Animation<Offset> _contentSlide;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );
    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeIn),
    );
    _contentSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOutCubic),
    );

    _logoController.forward().then((_) {
      _contentController.forward();
    });

    context.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  void dispose() {
    _logoController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          context.go('/home');
        }
        // else stay on splash to show welcome screen
      },
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(gradient: AppColors.splashGradient),
          child: SafeArea(
            child: Stack(
              children: [
                // Decorative glow orbs
                Positioned(
                  top: -60,
                  right: -80,
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primary.withValues(alpha: 0.25),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 180,
                  left: -100,
                  child: Container(
                    width: 240,
                    height: 240,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.neon.withValues(alpha: 0.08),
                    ),
                  ),
                ),
                Positioned(
                  top: 200,
                  left: -40,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryLight.withValues(alpha: 0.15),
                    ),
                  ),
                ),

                // Main content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    children: [
                      const Spacer(flex: 2),

                      // Logo + title
                      FadeTransition(
                        opacity: _logoFade,
                        child: ScaleTransition(
                          scale: _logoScale,
                          child: Column(
                            children: [
                              // Icon
                              Container(
                                width: 100,
                                height: 100,
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Color(0xFFB89EFF), Color(0xFF6C47FF)],
                                  ),
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(alpha: 0.5),
                                      blurRadius: 40,
                                      offset: const Offset(0, 16),
                                    ),
                                  ],
                                ),
                                child: const Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(Icons.account_balance_wallet_rounded,
                                        size: 52, color: Colors.white),
                                    Positioned(
                                      top: 12,
                                      right: 12,
                                      child: Icon(Icons.bolt_rounded,
                                          size: 22, color: Color(0xFF00E5FF)),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // App name
                              RichText(
                                textAlign: TextAlign.center,
                                text: const TextSpan(
                                  children: [
                                    TextSpan(
                                      text: 'Wallet',
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: -1,
                                        height: 1.0,
                                      ),
                                    ),
                                    TextSpan(
                                      text: '\nFrenzy',
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 40,
                                        fontWeight: FontWeight.w900,
                                        color: Color(0xFF00E5FF),
                                        letterSpacing: -1,
                                        height: 1.1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Tagline
                      FadeTransition(
                        opacity: _logoFade,
                        child: const Text(
                          'Transfer, bayar, dan kelola uang\ndalam genggaman — lebih cepat, lebih cerdas.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 15,
                            color: Colors.white70,
                            height: 1.6,
                          ),
                        ),
                      ),

                      const Spacer(flex: 3),

                      // CTA Buttons
                      FadeTransition(
                        opacity: _contentFade,
                        child: SlideTransition(
                          position: _contentSlide,
                          child: Column(
                            children: [
                              // Primary button — Buat Akun
                              GestureDetector(
                                onTap: () => context.push('/register'),
                                child: Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(16),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.2),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Buat Akun Baru',
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800,
                                        color: Color(0xFF6C47FF),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Secondary button — Masuk
                              GestureDetector(
                                onTap: () => context.push('/login'),
                                child: Container(
                                  width: double.infinity,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.3),
                                      width: 1.5,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Masuk ke Akun',
                                      style: TextStyle(
                                        fontFamily: 'PlusJakartaSans',
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 24),

                              // Footer
                              const Text(
                                'Wallet Frenzy · Aman & Terenkripsi 🔐',
                                style: TextStyle(
                                  fontFamily: 'PlusJakartaSans',
                                  fontSize: 12,
                                  color: Colors.white38,
                                ),
                              ),
                              const SizedBox(height: 12),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
