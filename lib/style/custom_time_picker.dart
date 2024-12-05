import 'package:eportal/assets/color/custom_color.dart';
import 'package:flutter/material.dart';

class CustomTimePicker{
  static Theme primary(Widget child){
    return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: CustomColor.primary(), // Warna utama (header & tombol OK)
              onPrimary: Colors.white, // Warna teks di header
              surface: Colors.white, // Background popup dialog
              onSurface: Colors.black, // Warna teks dalam dialog
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: CustomColor.primary(), // Warna tombol OK dan Cancel
              ),
            ),
          ),
          child: child,
        );
  }
}