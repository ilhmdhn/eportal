import 'package:eportal/data/local/shared_preferences.dart';
import 'package:eportal/data/network/response/login_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
class NetworkRequest{

  final key = SharedPreferencesData.getKey();
  static final baseUrl = dotenv.env['SERVER_URL'];

  static Future<LoginResponse> login(String user, String pass)async{
    try{
      final url = Uri.parse('$baseUrl/Api/login');
      final apiResponse = await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode({
        'username': user,
        'password': pass
      }));
      
      final convertedResult = json.decode(apiResponse.body);
      final response  = LoginResponse.fromJson(convertedResult);
      if(response.state == true){
        SharedPreferencesData.setKey(response.key??'');
        SharedPreferencesData.saveAccount(user, pass);
      }
      return response;
    }catch(e){
      return LoginResponse(
        state: false,
        message: e.toString()
      );
    }
  }

}