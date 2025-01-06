import 'package:eportal/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class ShowNotification{

  static void filterNotif(){
    
  }

  static void showAttendanceNotification(String title, String message)async{
      const NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        '1',
        'ABSEN/PENGAJUAN',
        importance: Importance.max,
        priority: Priority.max,
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