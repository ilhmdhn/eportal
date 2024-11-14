import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AddOnButton{
  static Widget textImageButton(BuildContext ctx ,String assets, String name){
    return Container(
      width: ScreenSize.setWidthPercent(ctx, 20),
      // width: 56,
      // color: Colors.amber,
      height: ScreenSize.setHeightPercent(ctx, 10),
      child: Column(
        children: [
          Container(
            height: 51,
            width: 51,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: CustomColor.secondaryColor(),
              borderRadius: const BorderRadius.all(Radius.circular(28))
            ),
            child: Image.asset(assets),
          ),
          Expanded(child: AutoSizeText(name, style: CustomFont.standartFont(), minFontSize: 3, maxLines: 2, textAlign: TextAlign.center))
        ],
      ),
    );
  }
}