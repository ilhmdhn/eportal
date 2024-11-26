import 'package:eportal/assets/color/custom_color.dart';
import 'package:flutter/material.dart';

class CustomDatePicker{
  static Theme primary(Widget child){
    return Theme(
      data: ThemeData.light().copyWith(
        primaryColor:
            CustomColor.primary(), // Warna header (garis bawah, active)
        scaffoldBackgroundColor: Colors.white, // Background utama
        dialogBackgroundColor: Colors.grey.shade100, // Background dialog
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: CustomColor.primary(), // Warna tombol
          ),
        ),
        colorScheme: ColorScheme.light(
          primary: CustomColor.primary(), // Warna seleksi tanggal
          onPrimary: Colors.white, // Warna teks pada seleksi tanggal
          surface: Colors.white, // Warna hover tanggal
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black), // Warna teks
        ),
      ),
      child: child,
    );
  }
}