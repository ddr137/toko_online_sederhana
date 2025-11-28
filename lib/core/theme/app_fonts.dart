import 'package:google_fonts/google_fonts.dart';

class AppFonts {
  static String get getInter => GoogleFonts.inter().fontFamily!;
  static String get getRoboto => GoogleFonts.roboto().fontFamily!;
  static String get getLato => GoogleFonts.lato().fontFamily!;
  static String get getPoppins => GoogleFonts.poppins().fontFamily!;
  static String get getManrope => GoogleFonts.manrope().fontFamily!;

  static List<String> get fonts => [
    GoogleFonts.inter().fontFamily!,
    GoogleFonts.roboto().fontFamily!,
    GoogleFonts.lato().fontFamily!,
    GoogleFonts.poppins().fontFamily!,
    GoogleFonts.manrope().fontFamily!,
    'Arial',
    'sans-serif',
  ];
}

