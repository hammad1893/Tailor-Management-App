import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tailor_app/utils/colors.dart';

class Apptext {
  static TextStyle headingtext = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: Appcolors.headingColor,
    fontFamily: GoogleFonts.poppins().fontFamily,
  );
  static TextStyle subheading = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    fontFamily: GoogleFonts.poppins().fontFamily,

    color: Appcolors.subHeadingColor,
  );
  static TextStyle bodytext = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: Appcolors.subHeadingColor,
  );
}
