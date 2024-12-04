import 'package:eportal/data/model/user.dart';
import 'package:eportal/util/checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesData{

  static SharedPreferences? _prefs;

  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future <void> setKey(String key) async{
    await _prefs?.setString('KEY', key);
  }

  static String? getKey(){
    final String? key = _prefs?.getString('KEY');
    return key;
  }

  static deleteKey(){
    _prefs?.remove('KEY');
  }

  static saveAccount(String user, String pass)async{
    await _prefs?.setString('USER', user);
    await _prefs?.setString('PASS', pass);
    return;
  }

  static User? getUser(){

    final user = _prefs?.getString('USER');
    final pass = _prefs?.getString('PASS');

    if(isNotNullOrEmpty(user)&&isNotNullOrEmpty(pass)){
      return User(username: user!, password: pass!);
    }else{
      return null;
    }
  }

  static deleteUser(){
    _prefs?.remove('USER');
    _prefs?.remove('PASS');
  }

  static setBiometric(bool state)async{
    await _prefs?.setBool('BIOMETRIC', state);
  }
  static bool getBiometric(){
    final biometricState = _prefs?.getBool('BIOMETRIC')??false;
    return biometricState;
  }
}