import 'package:eportal/data/network/network_request.dart';
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
    
    NetworkRequest.postToken(fcmToken??'');
  }
}