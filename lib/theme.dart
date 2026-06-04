import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color background = Color(0xFF0e0e0e);
  static const Color surface = Color(0xFF0e0e0e);
  static const Color surfaceBright = Color(0xFF2b2c2c);
  static const Color surfaceContainer = Color(0xFF191a1a);
  static const Color surfaceContainerLow = Color(0xFF131313);
  static const Color surfaceContainerHighest = Color(0xFF252626);
  static const Color primary = Color(0xFFc6c6c7);
  static const Color primaryContainer = Color(0xFF454747);
  static const Color secondary = Color(0xFF67a4d2);
  static const Color secondaryContainer = Color(0xFF003f5f);
  static const Color tertiary = Color(0xFFFF946e);
  static const Color onBackground = Color(0xFFe7e5e5);
  static const Color onSurface = Color(0xFFe7e5e5);
  static const Color outline = Color(0xFF767575);
  static const Color outlineVariant = Color(0xFF484848);
  static const Color error = Color(0xFFee7d77);
  static const Color labelGold = Color(0xFFA89E8D);      
  static const Color fieldBackground = Color(0xFF1E1E1E); 
  static const Color warningOrange = Color(0xFFD06B4C);   
  static const Color addSubButton = Color(0xFFE8E8E8); 

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: background,
    colorScheme: ColorScheme(
      brightness: Brightness.dark,
      primary: primary,
      onPrimary: surface,
      secondary: secondary,
      onSecondary: surface,
      error: error,
      onError: surface,
      surface: surface,
      onSurface: onSurface,
      tertiary: tertiary,
      outline: outlineVariant,
      primaryContainer: primaryContainer,
      secondaryContainer: secondaryContainer,
      surfaceTint: surfaceBright,
      shadow: Colors.black,
      inverseSurface: surfaceContainer,
      onInverseSurface: onSurface,
      inversePrimary: primaryContainer,
      scrim: Colors.black,
    ),
    textTheme: TextTheme(
      displayLarge: GoogleFonts.spaceGrotesk(
        fontSize: 56,
        fontWeight: FontWeight.w700,
        color: onBackground,
      ),
      headlineSmall: GoogleFonts.spaceGrotesk(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: onBackground,
      ),
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: onSurface,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: onSurface,
      ),
    ),
  );
}
