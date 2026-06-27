import 'package:flutter/material.dart';

class AppColors {
  // Primary — Indigo-Violet gradient (Wallet Frenzy brand)
  static const Color primary = Color(0xFF6C47FF);
  static const Color primaryLight = Color(0xFF8B6CFF);
  static const Color primaryDark = Color(0xFF4D2FE0);
  static const Color primarySurface = Color(0xFFF0ECFF);
  static const Color primaryBorder = Color(0xFFCFC0FF);

  // Accent neon
  static const Color neon = Color(0xFF00E5FF);
  static const Color neonSurface = Color(0xFFE0FAFF);

  // Semantic
  static const Color green = Color(0xFF00C07A);
  static const Color greenSurface = Color(0xFFE6FAF3);
  static const Color amber = Color(0xFFFFB020);
  static const Color amberSurface = Color(0xFFFFF6E0);
  static const Color red = Color(0xFFFF4757);
  static const Color redSurface = Color(0xFFFFEBED);
  static const Color violet = Color(0xFF7A5AF8);
  static const Color violetSurface = Color(0xFFF0EEFF);
  static const Color orange = Color(0xFFFF6B35);
  static const Color orangeSurface = Color(0xFFFFF0EB);

  // Neutral (light mode base)
  static const Color ink = Color(0xFF0D0F1A);
  static const Color slate600 = Color(0xFF3D4663);
  static const Color slate500 = Color(0xFF6B7399);
  static const Color slate400 = Color(0xFF9FA8C7);
  static const Color slate300 = Color(0xFFCDD2E8);
  static const Color line = Color(0xFFE8EBFF);
  static const Color line2 = Color(0xFFF3F4FF);
  static const Color bg = Color(0xFFF5F5FF);
  static const Color white = Color(0xFFFFFFFF);

  // Dark surface for cards
  static const Color darkCard = Color(0xFF1A1A2E);
  static const Color darkSurface = Color(0xFF0F0F1A);
  static const Color darkBorder = Color(0xFF2A2A4A);

  // Primary gradient — deep violet to indigo
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.5, 1.0],
    colors: [Color(0xFF8B6CFF), Color(0xFF6C47FF), Color(0xFF4D2FE0)],
  );

  // Dark gradient for hero cards
  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E1040), Color(0xFF0D0F1A)],
  );

  // Splash gradient
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    stops: [0.0, 0.6, 1.0],
    colors: [Color(0xFF1A0A3E), Color(0xFF2D1A6E), Color(0xFF0D0F1A)],
  );

  // Balance card gradient
  static const LinearGradient balanceGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.0, 0.55, 1.0],
    colors: [Color(0xFF9B7AFF), Color(0xFF6C47FF), Color(0xFF3D2099)],
  );

  // Shadows
  static List<BoxShadow> shadowCard = [
    const BoxShadow(
      color: Color(0x1A000000),
      blurRadius: 24,
      spreadRadius: 0,
      offset: Offset(0, 6),
    ),
  ];
  static List<BoxShadow> shadowSoft = [
    const BoxShadow(
      color: Color(0x0D000000),
      blurRadius: 12,
      spreadRadius: 0,
      offset: Offset(0, 2),
    ),
  ];
  static List<BoxShadow> shadowPrimary = [
    const BoxShadow(
      color: Color(0x556C47FF),
      blurRadius: 28,
      spreadRadius: 0,
      offset: Offset(0, 12),
    ),
  ];
  static List<BoxShadow> shadowGlow = [
    const BoxShadow(
      color: Color(0x336C47FF),
      blurRadius: 40,
      spreadRadius: 0,
      offset: Offset(0, 8),
    ),
  ];

  // Tone map for FeatureIcon
  static Map<String, List<Color>> tones = {
    'blue': [primarySurface, primary],
    'green': [greenSurface, green],
    'amber': [amberSurface, amber],
    'red': [redSurface, red],
    'violet': [violetSurface, violet],
    'slate': [bg, slate600],
    'neon': [neonSurface, neon],
    'orange': [orangeSurface, orange],
  };

  static List<Color> tone(String name) => tones[name] ?? tones['blue']!;
}
