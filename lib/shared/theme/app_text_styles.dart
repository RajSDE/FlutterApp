import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextTheme textTheme() {
    return GoogleFonts.poppinsTextTheme().copyWith(
      headlineLarge: GoogleFonts.poppins(
        fontSize: 34,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      headlineSmall: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      bodyLarge: GoogleFonts.poppins(
        fontSize: 16,
        color: Colors.black87,
      ),
      bodyMedium: GoogleFonts.poppins(
        fontSize: 15,
        color: Colors.black87,
      ),
    );
  }
}
