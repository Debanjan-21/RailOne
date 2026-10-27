import 'package:flutter/material.dart';

class RailColors {
  // RailOne Official Brand Colors
  static const Color primaryNavy = Color(0xFF0F3260); // CRIS Deep Navy
  static const Color headerBlue = Color(0xFF154C8A);  // RailOne App Header Blue
  static const Color saffronOrange = Color(0xFFE65100); // IR Saffron / RailOne Dot
  static const Color warmAmber = Color(0xFFF57C00);
  static const Color ticketGreen = Color(0xFF1B5E20);  // "PAPERLESS" badge green
  static const Color successGreen = Color(0xFF2E7D32);
  static const Color alertRed = Color(0xFFC62828);

  // Ticket Paper Backgrounds
  static const Color ticketBackground = Color(0xFFFDFBF7); // Security Parchment Tint
  static const Color ticketBorder = Color(0xFFCFD8DC);
  static const Color ticketDottedLine = Color(0xFF90A4AE);
  static const Color watermarkBlue = Color(0x12154C8A); // Faint CRIS watermark

  // Neutral Tones
  static const Color bgSurface = Color(0xFFF4F6F9);
  static const Color cardSurface = Colors.white;
  static const Color textDark = Color(0xFF1A212E);
  static const Color textMuted = Color(0xFF5D6B82);
  static const Color textLight = Color(0xFF8C98A9);
  static const Color divider = Color(0xFFE5E9F0);

  // Ticket Header Gradient
  static const LinearGradient railOneGradient = LinearGradient(
    colors: [Color(0xFF0D2F5A), Color(0xFF17579F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient ticketTopGradient = LinearGradient(
    colors: [Color(0xFFE65100), Color(0xFFF57C00)],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient paperlessBadgeGradient = LinearGradient(
    colors: [Color(0xFF2E7D32), Color(0xFF388E3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
