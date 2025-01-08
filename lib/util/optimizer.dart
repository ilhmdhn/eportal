import 'package:eportal/util/toast.dart';
import 'package:flutter/services.dart';

class Optimizer{

  void requestIgnoreBatteryOptimization() async {    
      const platform = MethodChannel('android_native_channel');
      try {
        await platform.invokeMethod('requestIgnoreBatteryOptimization');
      } catch (e) {
        ShowToast.error("Error: $e");
      }
  }
}