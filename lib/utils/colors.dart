import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MColors {
  static const backgroundColor = const Color(0xFFADBACC);
  static const swipeColor = const Color(0xFFF4F9FC);
  static const redButtonColor = const Color(0xFFC26A53);
  static const lightButtonColor = const Color(0xFFDEE2E6);
  static const cardColor = const Color(0xFFDBDFE6);
  static const whiteColor = const Color(0xFFFFFFFF);
  static const darkColor = const Color(0xFF3D3D66);
  static const sideDrawerColor = const Color(0xFFCFD8E6);
  static const flatBtnColor = const Color(0xFFB8C0CC);
  static const textFieldColor = const Color(0xFFE6E9EC);
}

class MTextStyle {
  static final headerText = GoogleFonts.poppins(
    color: const Color(0xFFFFFFFF),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static final darkheaderText = GoogleFonts.poppins(
    color: Color(0xFF3D3D66),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static final titleText = GoogleFonts.poppins(
    color: Color(0xFF737373),
    fontSize: 13,
    fontWeight: FontWeight.w500,
  );
  static final darkTitleText = GoogleFonts.poppins(
    color: Color(0xFF3D3D66),
    fontSize: 14,
    fontWeight: FontWeight.w500,
  );
  static final subtitleText = GoogleFonts.poppins(
    color: Color(0xFF3D3D66),
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );
  static final darkbuttonText = GoogleFonts.poppins(
    color: Color(0xFF3D3D66),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static final whiteButtonText = GoogleFonts.poppins(
    color: Color(0xFFFFFFFF),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
  static final darkhintText = GoogleFonts.poppins(
    color: Color(0xFF3D3D66),
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );
  static final hintText = GoogleFonts.poppins(
    color: Color(0xFF737373),
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );
  static final errorText = GoogleFonts.poppins(
    color: Color(0xFFFF0000),
    fontSize: 12,
    fontWeight: FontWeight.w300,
  );
  static final loadingText = GoogleFonts.poppins(
    color: const Color(0xFFC85333),
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );
  static final greenText = GoogleFonts.poppins(
    color: const Color(0xFF57CC99),
    fontSize: 14,
    fontWeight: FontWeight.w400,
  );
}

class MConstants {
  static const double elevation = 6;
  static const double noelevation = 0;
  static const double descEle = 3;
  static const double descBorRad = 16;
}

class MInputDecoration {
  static OutlineInputBorder borderdec = OutlineInputBorder(
    borderRadius: BorderRadius.circular(MConstants.descBorRad),
    borderSide: const BorderSide(color: Colors.transparent),
  );
}
