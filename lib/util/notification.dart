import 'package:auto_size_text/auto_size_text.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:flutter/material.dart';

class NotificationStyle{
  static void info(BuildContext ctx, title, body){
    ElegantNotification.success(
      title: AutoSizeText(title, style: CustomFont.headingDua(), maxLines: 1),
      description: AutoSizeText(body, style: CustomFont.headingLima(), minFontSize: 12),
      // icon: Icon(
      //   Icons.check,
      //   color: CustomColor.primary(),
      // ),
      toastDuration: const Duration(seconds: 3),
    ).show(ctx);
  }

  static void warning(BuildContext ctx, title, body) {
    ElegantNotification.error(
      title: AutoSizeText(title, style: CustomFont.headingDua(), maxLines: 1),
      description:
          AutoSizeText(body, style: CustomFont.headingLima(), minFontSize: 12),
      // icon: Icon(
      //   Icons.check,
      //   color: CustomColor.primary(),
      // ),
      toastDuration: const Duration(seconds: 3),
    ).show(ctx);
  }
}