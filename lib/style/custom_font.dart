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

  static TextStyle headingDuaSemiBoldSecondary() {
    return GoogleFonts.poppins(fontSize: 19, color: Colors.white, fontWeight: FontWeight.w500);
  }

  static TextStyle headingDuaBold() {
    return GoogleFonts.poppins(fontSize: 20, color: CustomColor.fontStandart(), fontWeight: FontWeight.w700);
  }

  static TextStyle menuTitle() {
    return GoogleFonts.poppins(fontSize: 17, color: Colors.blue.shade900);
  }

  static TextStyle activityTitle() {
    return GoogleFonts.dancingScript(fontSize: 16, fontWeight: FontWeight.w600 ,color: Colors.blue.shade900);
  }

  static TextStyle titleLogin() {
    return GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w600, color: CustomColor.primary());
  }

  static TextStyle forgotPassword() {
    return GoogleFonts.poppins(
        fontSize: 17,
        fontWeight: FontWeight.w600,
        color: CustomColor.primary());
  }

  static TextStyle headingTiga() {
    return GoogleFonts.poppins(fontSize: 18, color: CustomColor.fontStandart());
  }

  static TextStyle headingEmpatColorful() {
    return GoogleFonts.poppins(fontSize: 16, color: CustomColor.primary());
  }

  static TextStyle headingEmpatWarning() {
    return GoogleFonts.poppins(fontSize: 16, color: Colors.amber.shade900);
  }

  static TextStyle headingTigaBold() {
    return GoogleFonts.poppins(fontSize: 18, color: CustomColor.fontStandart(), fontWeight: FontWeight.w700);
  }

  static TextStyle headingTigaSemiBold() {
    return GoogleFonts.poppins(
        fontSize: 18,
        color: CustomColor.fontStandart(),
        fontWeight: FontWeight.w500);
  }

  static TextStyle headingTigaSemiBoldColor() {
    return GoogleFonts.poppins(
        fontSize: 18,
        color: CustomColor.primary(),
        fontWeight: FontWeight.w500);
  }

  static TextStyle headingTigaSemiBoldSecondary() {
    return GoogleFonts.poppins(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w500);
  }

  static TextStyle headingTigaBoldSecondary() {
    return GoogleFonts.poppins(
        fontSize: 18,
        color: Colors.white,
        fontWeight: FontWeight.w700);
  }

  static TextStyle headingEmpat() {
    return GoogleFonts.poppins(fontSize: 16, color: Colors.black);
  }

  static TextStyle headingEmpatBold() {
    return GoogleFonts.poppins(fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600);
  }

  static TextStyle headingEmpatBoldSecondary() {
    return GoogleFonts.poppins(
        fontSize: 16, color: Colors.white, fontWeight: FontWeight.w600);
  }

  static TextStyle headingEmpatSecondary() {
    return GoogleFonts.poppins(
        fontSize: 16, color: Colors.white);
  }

  static TextStyle headingEmpatSemiBold() {
    return GoogleFonts.poppins(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.w500);
  }

  static TextStyle headingEmpatSemiBoldSecondary() {
    return GoogleFonts.poppins(
        fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500);
  }

  static TextStyle headingEmpatSemiBoldRed() {
    return GoogleFonts.poppins(
        fontSize: 16, color: Colors.red, fontWeight: FontWeight.w500);
  }

  static TextStyle headingLima() {
    return GoogleFonts.poppins(fontSize: 14, color: Colors.black);
  }

  static TextStyle headingLimaSecondary() {
    return GoogleFonts.poppins(fontSize: 14, color: Colors.white);
  }

  static TextStyle headingLimaSemiBold() {
    return GoogleFonts.poppins(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w500);
  }

  static TextStyle headingLimaBold() {
    return GoogleFonts.poppins(fontSize: 14, color: Colors.black, fontWeight: FontWeight.w600);
  }

  static TextStyle headingLimaWarning() {
    return GoogleFonts.poppins(
        fontSize: 14, color: Colors.red, fontWeight: FontWeight.w600);
  }

  static TextStyle headingLimaColor() {
    return GoogleFonts.poppins(
        fontSize: 14, color: CustomColor.primary(),);
  }

  static TextStyle announcement() {
    return GoogleFonts.dancingScript(fontSize: 31, fontWeight: FontWeight.w800 ,color: Colors.blue.shade900);
  }

  static TextStyle announcementDate() {
    return GoogleFonts.poppins(fontSize: 16, color: Colors.blue.shade900);
  }

  static TextStyle urLocation() {
    return GoogleFonts.poppins(fontSize: 17, color: Colors.blue.shade900, fontWeight: FontWeight.w500);
  }

  static TextStyle locationAccuration() {
    return GoogleFonts.poppins(
        fontSize: 14, color: CustomColor.fontStandart(), fontWeight: FontWeight.w500);
  }

  static TextStyle location() {
    return GoogleFonts.poppins(
        fontSize: 21, color: CustomColor.fontStandart(), fontWeight: FontWeight.w700);
  }

  static TextStyle dashboardPosition() {
    return GoogleFonts.poppins(fontSize: 16, color: CustomColor.fontSecondary());
  }

  static TextStyle buttonSecondary(){
    return GoogleFonts.poppins(fontSize: 19, fontWeight: FontWeight.w500, color: CustomColor.fontSecondary());
  }

  static TextStyle drawerViewProfile() {
    return GoogleFonts.poppins(
        fontSize: 14, color: Colors.blue.shade900);
  }
}