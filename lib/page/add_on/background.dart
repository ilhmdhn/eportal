import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';

Widget backgroundPage(Widget body){
  return Container(
    color: CustomColor.background(),
    child: Stack(
      children: [
        Positioned(
          bottom: 0,
          right: 0,
          child: SizedBox(
            width: ScreenSize.setWidthPercent(navigatorKey.currentContext!, 50),
            child: Image.asset('assets/image/joe.png'),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          bottom: 0,
          left: 0,
          child: body)
      ],
    ),
  );
}