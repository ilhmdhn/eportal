import 'package:eportal/assets/color/custom_color.dart';
import 'package:flutter/material.dart';

class CustomContainer{
  static buttonDrawer(){
    return const BoxDecoration(
      
    );
  }

  static buttonPrimary() {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      color: CustomColor.primary()
    );
  }
}