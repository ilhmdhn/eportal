import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomAnimation{
  static Widget loading(){
    return SizedBox(
      width: ScreenSize.setWidthPercent(getIt<NavigationService>().navigatorKey.currentState!.context, 50),
      child: Center(
        child: Column(
          children: [
            LottieBuilder.asset('assets/lottie/emptyx.json'),
                                                            
          ],
        ),
      ));
  }
}