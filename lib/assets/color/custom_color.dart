import 'package:flutter/material.dart';

class CustomColor{
  static Color primary(){
    return hexToColor('#1C7CD4');
  }

  static Color secondaryColor() {
    return hexToColor('#53A3DC');
  }

  static Color background() {
    return hexToColor('#E1F0F8');
  }

  static Color fontStandart(){
    return Colors.black87;
  }

  static Color fontSecondary() {
    return Colors.white;
  }

  static Color hexToColor(String code) {
    return Color(int.parse(code.substring(1, 7), radix: 16) + 0xFF000000);
  }
}