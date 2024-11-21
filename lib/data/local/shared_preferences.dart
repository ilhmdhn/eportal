
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
}