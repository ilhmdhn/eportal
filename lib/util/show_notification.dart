import 'package:eportal/main.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_core/firebase_core.dart';

class ShowNotification{

  static void filterNotif(RemoteMessage msg){
    ShowNotification.showAttendanceNotification(msg.data['title'], msg.data['message']);
  }

  static void showAttendanceNotification(String title, String message)async{
      const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        '1',
        'ABSEN/PENGAJUAN',
        importance: Importance.max,
        visibility: NotificationVisibility.public,

        priority: Priority.max,
        icon: 'icon',
        ticker: 'ticker',
        fullScreenIntent: true,
        category: AndroidNotificationCategory.call,
      ),
      iOS: DarwinNotificationDetails(),
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