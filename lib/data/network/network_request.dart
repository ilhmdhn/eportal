// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:camera/camera.dart';
import 'package:eportal/data/local/shared_preferences.dart';
import 'package:eportal/data/network/response/attendance_list_response.dart';
import 'package:eportal/data/network/response/cuti_response.dart';
import 'package:eportal/data/network/response/data_response.dart';
import 'package:eportal/data/network/response/izin_response.dart';
import 'package:eportal/data/network/response/jko_response.dart';
import 'package:eportal/data/network/response/list_response.dart';
import 'package:eportal/data/network/response/login_response.dart';
import 'package:eportal/data/network/response/base_response.dart';
import 'package:eportal/data/network/response/notification_response.dart';
import 'package:eportal/data/network/response/overtime_response.dart';
import 'package:eportal/data/network/response/sallary_response.dart';
import 'package:eportal/data/network/response/ssp_response.dart';
import 'package:eportal/data/network/response/substitution_response.dart';
import 'package:eportal/util/checker.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/dummy.dart';
import 'package:eportal/util/navigation_service.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class NetworkRequest{
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
    }catch(e, stackTrace){
      return LoginResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> postGpsAttendance(XFile? photo, String outlet, int distance, int type) async {
    try {
      final key = SharedPreferencesData.getKey() ?? '';
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
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/getListAttendance?date=$month');
      final apiResponse = await http.get(url, headers: {
        'authorization': key
      });

      final convertedResult = json.decode(apiResponse.body);
      return AttendanceListResponse.fromJson(convertedResult);
    }catch(e, stackTrace){
      NavigationService.error(description: e.toString());
      return AttendanceListResponse(
        state: false, 
        message: e.toString(), 
        listAbsen: []);
    }
  }

  static Future<CutiResponse> getCuti()async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/get_cuti');
      final apiResponse = await http.get(url, headers: {'authorization': key});
      final convertedResult = json.decode(apiResponse.body);
      final response = CutiResponse.fromJson(convertedResult);
      return response;
    }catch(e, stackTrace){
      return CutiResponse(
        state: false,
        message: e.toString(),
      

      );
    }
  }

  static Future<BaseResponse> postCuti(String startDate, String endDate, String reason)async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
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
    }catch(e, stackTrace){
      return BaseResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> putCuti(String id, String startDate, String endDate, String reason)async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
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
    }catch(e, stackTrace){
      return BaseResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> postIjinBukti(String type, String startDate, String finishDate, String filePath)async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
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
      
    }catch(e, stackTrace){
      return BaseResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> postIzin(String type, String startDate, String finishDate, String startTime, String finishTime, String reason, String isDoctorLetter)async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
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
    }catch(e, stackTrace){
      return BaseResponse(state: false, message: e.toString());
    }
  }

  static Future<IzinResponse> getIzin()async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/ijin');
      final apiResponse = await http.get(url, headers: {'authorization': key});
      final convertedResult = json.decode(apiResponse.body);
      final response = IzinResponse.fromJson(convertedResult);
      return response;      
    }catch(e, stackTrace){
      NavigationService.error(description: e.toString());
      return IzinResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> cancelIzin(String id)async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/ijin/$id');
      final apiResponse = await http.delete(url, headers: {'authorization': key});
      final convertedResult = json.decode(apiResponse.body);
      final response = BaseResponse.fromJson(convertedResult);
      return response;  
    }catch(e, stackTrace){
      ShowToast.error(e.toString());
      return BaseResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> editIzin(String id ,String type, String startDate, String finishDate, String startTime, String finishTime, String reason, String isDoctorLetter) async {
    try {
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/ijin/$id');

      final apiResponse = await http.put(url,
          headers: {'Content-Type': 'application/json', 'authorization': key},
          body: json.encode({
            'type': type,
            'start_date': startDate,
            'finish_date': finishDate,
            'start_time': startTime,
            'finish_time': finishTime,
            'reason': reason,
            'doctor_letter': isDoctorLetter
          }));
      final convertedResult = json.decode(apiResponse.body);
      final response = BaseResponse.fromJson(convertedResult);
      return response;
    } catch (e) {
      return BaseResponse(state: false, message: e.toString());
    }
  }

  static Future<BaseResponse> putIjinBukti(String id, String type, String startDate, String finishDate, String? filePath) async {
    try {
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/ijin_bukti/$id');
      final request = http.MultipartRequest('PUT', url);

      request.fields['type'] = type;
      request.fields['start_date'] = startDate;
      request.fields['finish_date'] = finishDate;
      
      Map<String, String> headers =  {'Content-Type': 'multipart/form-data', 'authorization': key};

      request.headers.addAll(headers);

      if(isNotNullOrEmpty(filePath)){
        request.files.add(await http.MultipartFile.fromPath('bukti', filePath!));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final convertedResult = json.decode(responseBody);
      final responseResult = BaseResponse.fromJson(convertedResult);

      return responseResult;
    } catch (e) {
      return BaseResponse(state: false, message: e.toString());
    }
  }

  static Future<DataResponse> getMaxDate(String type, DateTime startDate)async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/check_max_date?start_date=${DateFormat('yyyy-MM-dd').format(startDate)}&type=$type');
      final apiResponse = await http.get(url, headers: {'authorization': key});
      final convertedResult = json.decode(apiResponse.body);
      return DataResponse.fromJson(convertedResult);
    }catch(e, stackTrace){
      ShowToast.error(e.toString());
      return DataResponse(state: false, message: e.toString());
    }
  }

  static Future<OutletResponse> getOutletList()async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/list_outlet');
      final apiResponse = await http.get(url, headers: {'authorization': key});
      final convertedResult = json.decode(apiResponse.body);
      return OutletResponse.fromJson(convertedResult);
    }catch(e, stackTrace){
      ShowToast.error('ERROR ');
      return OutletResponse(
        state: false, 
        message: e.toString()
      );
    }
  }

  static Future<SallaryResponse> getSallary()async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/list_slip_gaji');
      final apiResponse = await http.get(url, headers: {'authorization': key});
      final convertedResult = json.decode(apiResponse.body);
      return SallaryResponse.fromJson(convertedResult);
    }catch(e, stackTrace){
      NavigationService.error(description: e.toString());
      return SallaryResponse(state: false, message: e.toString());
    }
  }

  static Future<DataResponse> getSallaryPdf(String period) async {
    try {
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/detail_slip_gaji?period=$period');
      final apiResponse = await http.get(url, headers: {'authorization': key});
      final convertedResult = json.decode(apiResponse.body);
      return DataResponse.fromJson(convertedResult);
    } catch (e) {
      NavigationService.error(description: e.toString());
      return DataResponse(state: false, message: e.toString());
    }
  }

  static Future<OvertimeResponse> getOvertime()async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/lembur');
      final apiResponse = await http.get(url, headers: {'authorization': key});
      final convertedResult = json.decode(apiResponse.body);
      final response = OvertimeResponse.fromJson(convertedResult);
      return response;
    }catch(e, stackTrace){
      NavigationService.error(description: e.toString());
      return OvertimeResponse(
        state: false, 
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> postLembur(DateTime date, TimeOfDay startTime, TimeOfDay endTime, String reason, String assigner)async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/lembur');

      int assignerCode = DummyData.assignerConverter(assigner);

      final apiResponse = await http.post(url, 
        headers: {'authorization': key}, 
        body:jsonEncode({
          "start_date": DateFormat('yyyy-MM-dd').format(date),
          "reason": reason,
          "start_time": CustomConverter.time(startTime),
          "finish_time": CustomConverter.time(endTime),
          "penugas": assignerCode,
          "penugas_lain": assigner
        })
      );

      final convertedResult = json.decode(apiResponse.body);
      return  BaseResponse.fromJson(convertedResult);      
    }catch(e, stackTrace){
      return BaseResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> putLembur(String idLembur, DateTime date, TimeOfDay startTime, TimeOfDay endTime, String reason, String assigner) async {
    try {
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/lembur/$idLembur');

      int assignerCode = DummyData.assignerConverter(assigner);

      final apiResponse = await http.put(url,
          headers: {'authorization': key},
          body: jsonEncode({
            "start_date": DateFormat('yyyy-MM-dd').format(date),
            "reason": reason,
            "start_time": CustomConverter.time(startTime),
            "finish_time": CustomConverter.time(endTime),
            "penugas": assignerCode,
            "penugas_lain": assigner
          }));

      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    } catch (e) {
      return BaseResponse(state: false, message: e.toString());
    }
  }

  static Future<SubstitutionResponse> getLipeng()async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/libur_pengganti');
      final apiResponse = await http.get(url, headers: {'authorization': key});
      final convertedResult = json.decode(apiResponse.body);
      return SubstitutionResponse.fromJson(convertedResult);
    }catch(e, stackTrace){
      NavigationService.error(description: e.toString());
      return SubstitutionResponse(
        state: false, 
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> postLipeng(DateTime dateSource, DateTime dateDest, String reason, bool isOvertime) async {
    try {
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/libur_pengganti');
      final apiResponse = await http.post(
        url, 
        headers: {'authorization': key},
        body: jsonEncode({
          'source_date': DateFormat('yyyy-MM-dd').format(dateSource),
          'reason': reason,
          'furlough_date': DateFormat('yyyy-MM-dd').format(dateDest),
          'overtime': isOvertime? 1:0,
        })
      );
      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    } catch (e) {
      NavigationService.error(description: e.toString());
      return BaseResponse(state: false, message: e.toString());
    }
  }

  static Future<BaseResponse> putLipeng(String id, DateTime dateSource, DateTime dateDest, String reason, bool isOvertime) async {
    try {
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/libur_pengganti/$id');
      final apiResponse = await http.put(url,
          headers: {'authorization': key},
          body: jsonEncode({
            'source_date': DateFormat('yyyy-MM-dd').format(dateSource),
            'reason': reason,
            'furlough_date': DateFormat('yyyy-MM-dd').format(dateDest),
            'overtime': isOvertime ? 1 : 0,
          }));
      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    } catch (e) {
      NavigationService.error(description: e.toString());
      return BaseResponse(state: false, message: e.toString());
    }
  }

  static Future<SspResponse> getSsp()async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/ssp');
      final apiResponse = await http.get(url, headers: {'authorization': key});
      final convertedResult = json.decode(apiResponse.body);
      return SspResponse.fromJson(convertedResult);
    }catch(e, stackTrace){
            print('LINE $stackTrace');
      NavigationService.error(description: e.toString());
      return SspResponse(state: false, message: e.toString());
    }
  }

  static Future<JkoResponse> getJko(DateTime period)async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/jko?period=${DateFormat('yyyy-MM').format(period)}');
      final apiResponse = await http.get(url, headers: {'authorization': key});
      final convertedResult = json.decode(apiResponse.body);
      return JkoResponse.fromJson(convertedResult);
    }catch(e, stackTrace){
      return JkoResponse(
        state: false, 
        message: e.toString()
      );
    }
  }

  static Future<BaseResponse> postToken(String token) async {
    try {
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/user_key');
      final apiResponse = await http.post(url,
        headers: {'authorization': key},
        body: jsonEncode({
          'key': token
        })
      );
      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    } catch (e) {
      return BaseResponse(state: false, message: e.toString());
    }
  }

  static Future<BaseResponse> postSsp(
    int type,
    String? weddingBookPath, 
    String? aktaLahirPath, 
    String? suratKeteranganMeninggalPath, 
    String? familyCardPath, 
    String? partnerName, 
    String? babyName, 
    String? jk, 
    String? numberChild, 
    String? hubunganKeluarga,
    String? namaAlmarhum,
    DateTime? tanggalMeninggal,
    String? otherReason,
  )async{
    EasyLoading.show();
    try{
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/ssp');
      final request = http.MultipartRequest('POST', url);

      Map<String, String> headers = {
        'Content-Type': 'multipart/form-data',
        'authorization': key
      };
      request.headers.addAll(headers);
      request.fields['type'] = type.toString();

      if(type == 1){
        request.fields['pasangan'] = partnerName!;
        request.files.add(await http.MultipartFile.fromPath('marriage_book', weddingBookPath!));
        request.fields['notes'] = otherReason!;
      }else if(type == 2){
        request.fields['child_name'] = babyName!;
        request.fields['sex'] = jk!;
        request.fields['child_order'] = numberChild!;
        request.files.add(await http.MultipartFile.fromPath('birth_certificate', aktaLahirPath!));
        request.files.add(await http.MultipartFile.fromPath('marriage_book', weddingBookPath!));

        request.fields['notes'] = otherReason!;
      }else if(type == 3){
        request.fields['relationship'] = hubunganKeluarga!;
        request.fields['alm_name'] = namaAlmarhum!;
        request.fields['passed_date'] = DateFormat('yyyy-MM-dd').format(tanggalMeninggal!);
        request.files.add(await http.MultipartFile.fromPath('marriage_book', weddingBookPath!));
        request.files.add(await http.MultipartFile.fromPath('death_certificate', suratKeteranganMeninggalPath!));
        request.files.add(await http.MultipartFile.fromPath('family_card', familyCardPath!));

        request.fields['notes'] = otherReason!;
      }else if(type == 4){
        request.fields['relationship'] = hubunganKeluarga!;
        request.fields['alm_name'] = namaAlmarhum!;
        request.fields['passed_date'] = DateFormat('yyyy-MM-dd').format(tanggalMeninggal!);
        request.files.add(await http.MultipartFile.fromPath('death_certificate', suratKeteranganMeninggalPath!));
      }else{
        EasyLoading.dismiss();
        return BaseResponse(
          state: false,
          message: 'Tipe tidak valid' 
        );
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final convertedResult = json.decode(responseBody);
        EasyLoading.dismiss();
      
      return BaseResponse.fromJson(convertedResult);
      
    }catch(e, stackTrace){
      return BaseResponse(
        state: false,
        message: e.toString()
      );
    }
  }

  static Future<NotificationResponse> getNotifThumb()async{
    try{
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/dashboard_notif');
      final apiResponse = await http.get(url, headers: {'authorization': key});
      final convertedResult = json.decode(apiResponse.body);
      return NotificationResponse.fromJson(convertedResult);
    }catch(e, stackTrace){
      ShowToast.warning('Gagal mendapatkan notifikasi');
      return NotificationResponse(state: false, message: e.toString());
    }
  }

  static Future<BaseResponse> readedNotif(id) async {
    try {
      final key = SharedPreferencesData.getKey() ?? '';
      final url = Uri.parse('$baseUrl/Api/notification/$id');
      final apiResponse = await http.get(url, headers: {'authorization': key});
      final convertedResult = json.decode(apiResponse.body);
      return BaseResponse.fromJson(convertedResult);
    } catch (e, stackTrace) {
      return BaseResponse(state: false, message: e.toString());
    }
  }
}