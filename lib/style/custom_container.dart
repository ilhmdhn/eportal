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

  static buttonGreen() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(20), color: Colors.green.shade700);
  }

  static buttonSecondary() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(16), 
        color: CustomColor.secondaryColor()
    );
  }

  static buttonGrey() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey);
  }


  static buttonCancel() {
    return BoxDecoration(
        borderRadius: BorderRadius.circular(16), 
        color: Colors.redAccent
  );
  }
}