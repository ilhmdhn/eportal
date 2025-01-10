import 'package:auto_size_text/auto_size_text.dart';
import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/notification_response.dart';
import 'package:eportal/page/add_on/background.dart';
import 'package:eportal/style/custom_font.dart';
import 'package:eportal/util/converter.dart';
import 'package:flutter/material.dart';

class NotificationDetailPage extends StatelessWidget {
  const NotificationDetailPage({super.key});
  static const nameRoute = '/notification-detail';

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as NotificationModel;
    NetworkRequest.readedNotif(data.id);
    return Scaffold(
      body: backgroundPage(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                AutoSizeText(data.title, style: CustomFont.headingDuaSemiBold(), maxLines: 2,),
                const SizedBox(height: 3,),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(CustomConverter.dateTimeToDay(data.time), style: CustomFont.headingLima(),),
                ),
                const SizedBox(height: 4,),
                AutoSizeText(data.content, style: CustomFont.headingEmpat(), textAlign: TextAlign.justify,)
              ],
            ),
          ),
        )
      ),
    );
  }
}