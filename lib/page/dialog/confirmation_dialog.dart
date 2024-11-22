import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/style/custom_container.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';

class ConfirmationDialog{
  static Future<bool> confirmation(BuildContext ctx, String title)async{
    Completer<bool> completer = Completer<bool>();
    showDialog(
      context: ctx,
      builder: (BuildContext ctxDialog){
        return AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          backgroundColor: Colors.white,
          title: Center(
            child: AutoSizeText(title, style: CustomFont.headingDua(), maxLines: 1, minFontSize: 12, overflow: TextOverflow.clip,)
          ),
          actions: [
            SizedBox(
                width: ScreenSize.setWidthPercent(ctx, 70),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(ctx, false);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric( horizontal: 12, vertical: 6),
                          decoration: CustomContainer.buttonCancel(),
                          child: AutoSizeText(
                            'Cancel',
                            maxLines: 1,
                            minFontSize: 9,
                            style: CustomFont.buttonSecondary(),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(ctx, true);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: CustomContainer.buttonPrimary(),
                          child: AutoSizeText('Konfirmasi',
                              maxLines: 1,
                              minFontSize: 9,
                              style: CustomFont.buttonSecondary(),
                              textAlign: TextAlign.center),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      }
    ).then((value) {
      value ??= false;
      completer.complete(value);
    });
    return completer.future;
  }
}