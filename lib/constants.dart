import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF7B61FF);
const double defaultPadding = 16.0;
const double kPI = 3.1415926535897932;
const double kBoxSize = 300;
ThemeData darkTheme = ThemeData.dark().copyWith();
ThemeData lightTheme = ThemeData.light().copyWith();

TextStyle graphLabel = const TextStyle(
  //color: Colors.grey, //ColorConstant.gray900,
  fontSize: 22,
  fontFamily: 'General Sans',
  fontWeight: FontWeight.w400,
);
TextStyle labelStyle = const TextStyle(
  color: Colors.grey, //ColorConstant.gray900,
  fontSize: 22,
  fontFamily: 'General Sans',
  fontWeight: FontWeight.w400,
);
TextStyle labelBold = const TextStyle(
  color: Colors.black, //ColorConstant.gray900,
  fontSize: 24,
  fontFamily: 'General Sans',
  fontWeight: FontWeight.bold,
);

//map page


// TextStyle(
//                                     color: Colors.grey,
//                                     fontSize: 32,
//                                     fontFamily: 'General Sans',
//                                     fontWeight: FontWeight.w600,
//                                   ),