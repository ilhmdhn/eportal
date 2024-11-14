import 'package:eportal/assets/color/custom_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomFont{
  static TextStyle standartFont(){
    return GoogleFonts.poppins(fontSize: 12, color: CustomColor.fontStandart());
  }

  static TextStyle notifDetail() {
    return GoogleFonts.poppins(fontSize: 14, color: CustomColor.fontStandart());
  }

  static TextStyle dashboardName() {
    return GoogleFonts.poppins(fontSize: 19, color: CustomColor.fontSecondary(), fontWeight:  FontWeight.w500);
  }

  static TextStyle drawerName() {
    return GoogleFonts.poppins(
        fontSize: 17,
        color: CustomColor.fontStandart());
  }
  
  static TextStyle headingDua() {
    return GoogleFonts.poppins(
        fontSize: 19, color: CustomColor.fontStandart());
  }

  static TextStyle menuTitle() {
    return GoogleFonts.poppins(fontSize: 17, color: Colors.blue.shade900);
  }

  static TextStyle activityTitle() {
    return GoogleFonts.dancingScript(fontSize: 16, fontWeight: FontWeight.w600 ,color: Colors.blue.shade900);
  }

  static TextStyle headingTiga() {
    return GoogleFonts.poppins(fontSize: 18, color: CustomColor.fontStandart());
  }

  static TextStyle headingEmpat() {
    return GoogleFonts.poppins(fontSize: 14, color: Colors.black);
  }

  static TextStyle announcement() {
    return GoogleFonts.dancingScript(fontSize: 31, fontWeight: FontWeight.w800 ,color: Colors.blue.shade900);
  }

  static TextStyle announcementDate() {
    return GoogleFonts.poppins(fontSize: 16, color: Colors.blue.shade900);
  }

  static TextStyle dashboardPosition() {
    return GoogleFonts.poppins(fontSize: 16, color: CustomColor.fontSecondary());
  }

  static TextStyle drawerViewProfile() {
    return GoogleFonts.poppins(
        fontSize: 14, color: Colors.blue.shade900);
  }
}