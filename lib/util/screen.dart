import 'package:flutter/material.dart';

class ScreenSize {
  static double setWidthPercent(BuildContext ctx, double size) {
    return MediaQuery.of(ctx).size.width * (size / 100);
  }

  static double setHeightPercent(BuildContext ctx, double size) {
    return MediaQuery.of(ctx).size.height * (size / 100);
  }
}
