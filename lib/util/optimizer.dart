import 'package:flutter/services.dart';
import 'dart:io';

class Optimizer{

  void requestIgnoreBatteryOptimization() async {
    final isAndroid = Platform.isAndroid;
    if (isAndroid) {
      const platform = MethodChannel('android_native_channel');
      try {
        await platform.invokeMethod('requestIgnoreBatteryOptimization');
      } catch (e) {
        print("Error: $e");
      }
    }
  }
}