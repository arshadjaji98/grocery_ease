import 'package:flutter/material.dart';

class AppWidgets {
  static TextStyle boldTextFieldStyle() {
    return const TextStyle(
        color: const Color(0XFF8a4af3),
        fontSize: 20,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }

  static TextStyle headerTextFieldStyle() {
    return const TextStyle(
        color: const Color(0XFF8a4af3),
        fontSize: 24,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins');
  }

  static TextStyle lightTextFieldStyle() {
    return const TextStyle(
        color: Colors.black38,
        fontSize: 13,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins');
  }

  static TextStyle semiBoldTextFieldStyle() {
    return const TextStyle(
      color: const Color(0XFF8a4af3),
      fontSize: 14,
      fontFamily: 'Poppins',
    );
  }
}
