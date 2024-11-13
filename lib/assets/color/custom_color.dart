import 'package:flutter/material.dart';

class CustomColor{
  static Color primary(){
    return hexToColor('#50ADE6');
  }

  static Color secondaryColor() {
    return hexToColor('#99C7EC');
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