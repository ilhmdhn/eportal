import 'dart:io';

import 'package:camera/camera.dart';
import 'package:eportal/data/local/shared_preferences.dart';
import 'package:eportal/data/network/response/attendance_list_response.dart';
import 'package:eportal/data/network/response/login_response.dart';
import 'package:eportal/data/network/response/base_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
class NetworkRequest{

  static final String key = SharedPreferencesData.getKey()??'';
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

  static Future<BaseResponse> postGpsAttendance(XFile? photo, String outlet, int distance, int type) async {
    try {
      final url = Uri.parse('$baseUrl/Api/gps_attendance');

      final request = http.MultipartRequest('POST', url);

      request.fields['outlet'] = outlet;
      request.fields['distance'] = distance.toString();
      request.fields['type'] = type.toString();

      Map<String, String> headers = {
         'Content-Type': 'multipart/form-data',
        'authorization': key
        };
      request.headers.addAll(headers);
      

      if (photo != null) {
        final file = File(photo.path);
        request.files.add(await http.MultipartFile.fromPath(
          'photo',
          file.path,
          contentType: MediaType('image', 'jpeg'),
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

  static Future<AttendanceListResponse> getAttendance(String month) async{
    try{
      final url = Uri.parse('$baseUrl/Api/getListAttendance?date=$month');
      final apiResponse = await http.get(url, headers: {
        'authorization': key
      });

      final convertedResult = json.decode(apiResponse.body);
      return AttendanceListResponse.fromJson(convertedResult);
    }catch(e){
      return AttendanceListResponse(
        state: false, 
        message: e.toString(), 
        listAbsen: []);
    }
  }

}