import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/assets/color/custom_color.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:flutter/material.dart';

class AddOnButton{
  static Widget textImageButton(String assets, String name){
    return Container(
      // color: Colors.amber,
      width: 56,
      height: 81,
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
          AutoSizeText(name, style: CustomFont.standartFont(), minFontSize: 5, maxLines: 2, textAlign: TextAlign.center,)
        ],
      ),
    );
  }
}