import 'package:eportal/data/local/shared_preferences.dart';
import 'package:eportal/main.dart';
import 'package:eportal/util/checker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ShowNotification{

  static void filterNotif(RemoteMessage msg)async{
    final key = await SharedPreferencesData().updatedKey();
    if(isNullOrEmpty(key)){
      return;
    }
    final importanceNotification = msg.data['importance']??'LOW';
    if(importanceNotification == 'HIGH'){
      highNotification(msg.data['title'], msg.data['message']);
    }
  }
  
  static void highNotification(String title, String message)async{
      const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        '1',
        'ABSEN/PENGAJUAN',
        importance: Importance.max,
        visibility: NotificationVisibility.public,
        priority: Priority.max,
        icon: 'icon',
        ticker: 'ticker',
        enableVibration: true,
        fullScreenIntent: true,
        category: AndroidNotificationCategory.call,
      ),
      iOS: DarwinNotificationDetails(
        interruptionLevel: InterruptionLevel.active
      ),
      macOS: DarwinNotificationDetails(),
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      message,
      notificationDetails,
    );
  }
}