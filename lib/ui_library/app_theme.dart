
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static const Color yellow = Colors.yellow,
      white = Color(0xFFF1F1F1),
      gradientwhite = Color(0xFFFFFFFDCC),
      darkblack = Color(0xFF080808),
      darkwhite = Color(0xFFFFFFFF),
      lightblack = Color(0xFF28282A),
      red = Color(0xFFF34E4E),
      darkblackcolor = Color(0xFF000000),
      borderColor = Color(0xFF616161),
      darkGrey = Color(0xFFA1A1A1),
      colorBlack = Color(0xFF3F3F3F),
      textFieldblackColor = Color(0xFFEFEFEF),
      lightBlue = Color(0xFF008080),
      black = Color(0xFF222222),
      darkgrey = Color(0xFF616161);

  static TextStyle h15 = const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    fontFamily: '',
  ),
      h11 = const TextStyle(
        fontSize: 8,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
      ),
      h10 = const TextStyle(
          fontSize: 10,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500),
      h9 = const TextStyle(
          fontSize: 12, fontFamily: 'Poppins', fontWeight: FontWeight.w500),
      h8 = const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
      ),
      h7 = const TextStyle(
        fontSize: 14,
        fontFamily: 'Poppins',
      ),
      h6 = const TextStyle(
        fontSize: 16,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
      ),
      h5 = const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: darkblack,
        fontFamily: 'Poppins',
      ),
      h4 = const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
      ),
      h3 = const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
        color: darkblack,
        fontFamily: 'Poppins',
      ),
      h2 = const TextStyle(
        fontSize: 24,
        color: red,
        fontFamily: 'Poppins',
      ),
      h1 = const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w700,
        fontFamily: 'Poppins',
      ),

      h0 = const TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
      );

  static OutlineInputBorder transparentOutlineBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: Colors.transparent),
  );
}