import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseTools{
  static getToken()async{
    final fcmToken = await FirebaseMessaging.instance.getToken();

  FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      print('TOKEN REFRESH ${fcmToken}');
    }).onError((err) {
      print('FAIL GENERATE NEW TOKEN'+err);
    });

    print('TOKEN new $fcmToken');
  }
}