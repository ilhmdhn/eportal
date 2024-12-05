import 'dart:io';

import 'package:camera/camera.dart';
import 'package:eportal/data/local/shared_preferences.dart';
import 'package:eportal/data/network/response/attendance_list_response.dart';
import 'package:eportal/data/network/response/cuti_response.dart';
import 'package:eportal/data/network/response/login_response.dart';
import 'package:eportal/data/network/response/base_response.dart';
import 'package:eportal/util/checker.dart';
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

  static Future<CutiResponse> getCuti()async{
    try{
      final url = Uri.parse('$baseUrl/Api/get_cuti');
      final apiResponse = await http.get(url, headers: {'authorization': key});
      final convertedResult = json.decode(apiResponse.body);
      final response = CutiResponse.fromJson(convertedResult);
      return response;
    }catch(e){
      return CutiResponse(
        state: false,
        message: e.toString(),
      

      );
    }
  }

  static Future<BaseResponse> postCuti(String startDate, String endDate, String reason)async{
    try{
      final url = Uri.parse('$baseUrl/Api/post_cuti');

      final apiResponse = await http.post(url,
          headers: {
            'Content-Type': 'application/json',
            'authorization': key          
          },
          body: json.encode(
            {
              'start_date': startDate, 
              'end_date': endDate,
              'reason': reason
            }
          )
      );

      final convertedResult = json.decode(apiResponse.body);
      final response = BaseResponse.fromJson(convertedResult);
      return response;
    }catch(e){
      return BaseResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> putCuti(String id, String startDate, String endDate, String reason)async{
    try{
      final url = Uri.parse('$baseUrl/Api/Cuti/$id');
      final apiResponse = await http.put(
        url, 
        headers: {
          'Content-Type': 'application/json',
          'authorization': key
        },
        body: json.encode(
          {
            "start_date": startDate,
            "end_date": endDate,
            "reason": reason
          }
        ),
      );
      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    }catch(e){
      return BaseResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> postIjinBukti(String type, String startDate, String finishDate, String filePath)async{
    try{
      final url = Uri.parse('$baseUrl/Api/ijin_bukti');
      final request = http.MultipartRequest('POST', url);

      request.fields['type'] = type;
      request.fields['start_date'] = startDate;
      request.fields['finish_date'] = finishDate;
      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'authorization': key
      };

      request.headers.addAll(headers);

      if(isNullOrEmpty(filePath)){
        return BaseResponse(
          state: false,
          message: 'File tidak ada'
        );
      }

      request.files.add(await http.MultipartFile.fromPath(
        'bukti',
        filePath
      ));

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final convertedResult = json.decode(responseBody);
      final responseResult = BaseResponse.fromJson(convertedResult);

      return responseResult;
      
    }catch(e){
      return BaseResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> postIzin(String type, String startDate, String finishDate, String startTime, String finishTime, String reason, String isDoctorLetter)async{
    try{
      final url = Uri.parse('$baseUrl/Api/ijin');
      
      final apiResponse = await http.post(url,
          headers: {'Content-Type': 'application/json', 'authorization': key},
          body: json.encode({
            'type': type,
            'start_date': startDate,
            'finish_date': finishDate,
            'start_time': startTime,
            'finish_time': finishTime,
            'reason': reason,
            'doctor_letter': isDoctorLetter
          })
      );
      final convertedResult = json.decode(apiResponse.body);
      final response = BaseResponse.fromJson(convertedResult);
      return response;
    }catch(e){
      return BaseResponse(state: false, message: e.toString());
    }
  }
}