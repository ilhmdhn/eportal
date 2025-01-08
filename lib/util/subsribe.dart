import 'package:eportal/data/local/shared_preferences.dart';
import 'package:eportal/data/model/profile.dart';
import 'package:eportal/util/checker.dart';
import 'package:eportal/util/toast.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

Future<void> subscribeToTopic() async {
  try {
    final key = await SharedPreferencesData().updatedKey();
    if(isNullOrEmpty(key)){
      return;
    }
    await FirebaseMessaging.instance.subscribeToTopic(Profile.getProfile().department);
    await FirebaseMessaging.instance.subscribeToTopic(Profile.getProfile().outlet.split(' ')[0]);
  } catch (e) {
    ShowToast.warning('Gagal subscribe ke topic ${e.toString()}');
  }
}
