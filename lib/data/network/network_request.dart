import 'dart:io';

import 'package:camera/camera.dart';
import 'package:eportal/data/local/shared_preferences.dart';
import 'package:eportal/data/model/profile.dart';
import 'package:eportal/data/network/response/login_response.dart';
import 'package:eportal/data/network/response/base_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
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

static Future<BaseResponse> postGpsAttendance(
      XFile? photo, String outlet, int distance, int type) async {
    try {
      final url = Uri.parse('$baseUrl/Api/gps_attendance');

      final request = http.MultipartRequest('POST', url);

      request.fields['outlet'] = outlet;
      request.fields['distance'] = distance.toString();
      request.fields['type'] = type.toString();

      Map<String, String> headers = {
         'Content-Type': 'multipart/form-data',
        'authorization': 'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.IntcIm5pcFwiOlwiMTAwMDIyMDIwMVwiLFwibmFtZVwiOlwiSWxoYW0gIERvaGFhblwiLFwiZW1haWxcIjpcImlsaGFtLmRvaGFhbkBoYXBweXB1cHB5LmlkXCIsXCJyb2xlXCI6XCJNYW5hZ2VyVEFEXCIsXCJqYWJhdGFuXCI6XCJFa3Nla3V0aWYgSVQgUHJvZ3JhbW1lclwiLFwicGFuZ2thdFwiOlwiRWtzLiBNdWRhXCIsXCJwaG9uZVwiOlwiMDg1NzQ5MDg2NDg3XCIsXCJkZXBhcnRlbWVuXCI6XCJJVERcIixcImVtcF9kYXRlXCI6XCIyMDIyLTAyLTA3IDAwOjAwOjAwXCIsXCJzaWduYXR1cmVcIjpcImh0dHBzOlxcXC9cXFwvZXBvcnRhbC5oYXBweXB1cHB5LmlkXFxcL3VwbG9hZHNcXFwvU2lnbmF0dXJlXFxcL2JnX3JlbW92ZWRfMjAyNDA3MjUxNjA5MzN0dGRrdSBhcGlrLnBuZ1wiLFwib3V0bGV0XCI6XCJIUDAwMCBIZWFkIE9mZmljZVwiLFwiYWtzZXNfb3V0bGV0XCI6XCJIUDAwMCBIZWFkIE9mZmljZVwiLFwiaWF0XCI6MTczMjI2MDAxOSxcImV4cFwiOjE3MzIyNzQ0MTl9Ig.isASpE50XXTyxbHEAgAajogXsKR12a91F36ZlQfzis4PV7XW1eE5I0LORuf0eFSGjJSBpJto3oksMNVwPbhBOHT_ukn2YDA-HsGKqhcq2wduRsIgnxuSzNGZZCJaYzcCmNHpRzP0EDz0HqvJPrJGrTTBMA2hrKWUFD347sd5HiBH-okVgWaXD-k7PMJdcIS3hm5qHa1tqvBJNyofeBTXhNu2xRDA6CDcMfZSYPm2oFpn-evbibhjMpkihjXIQryQl_qroT5ayXbULnp0TCgYjrc7LbbsSGJ0bWVbDNqy7bDOPjZGglHrbNpYNOtyyW18G9JOjfuAMg40DdxbhduYMQ'
        };
      request.headers.addAll(headers);
      

      if (photo != null) {
        final file = File(photo.path);
        request.files.add(await http.MultipartFile.fromPath(
          'photo',
          file.path,
          contentType: MediaType('image', 'jpeg')
        ));
      }
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final convertedResult = json.decode(responseBody);
      final responseResult = BaseResponse.fromJson(convertedResult);
      
      return responseResult;

    } catch (e) {
      return BaseResponse(message: e.toString(), state: false);
    }
  }
}