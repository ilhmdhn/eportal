import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';

Widget backgroundPage(Widget body){
  return Stack(
    children: [
      Positioned(
        top: 0,
        right: 0,
        bottom: 0,
        left: 0,
        child: Container(
          color: CustomColor.background(),
          child: body
        )),
      Positioned(
        bottom: 0,
        left: 0,
        child: SizedBox(
          width: ScreenSize.setWidthPercent(navigatorKey.currentContext!, 50),
          child: Image.asset('assets/image/joe.png'),
        ),
      )
    ],
  );
}