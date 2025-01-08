import 'package:eportal/util/toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseTools{
  static getToken()async{
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    FirebaseMessaging.instance.onTokenRefresh.listen((refreshToken) {
      fcmToken = refreshToken;
    }).onError((err) {
      ShowToast.warning('Generate refresh token failed $err');
    });
    // ignore: avoid_print
    print('NEW TOKEN $fcmToken');
  }
}