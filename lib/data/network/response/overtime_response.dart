import 'package:eportal/data/network/response/attendance_list_response.dart';
import 'package:eportal/util/converter.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';

class OvertimeResponse{
  bool state;
  String message;
  List<OvertimeModel>? data;

  OvertimeResponse({
    required this.state,
    required this.message,
    this.data,
  });

  factory OvertimeResponse.fromJson(Map<String, dynamic>json){
    return OvertimeResponse(
      state: json['state'],
      message: json['message'],
      data: List<OvertimeModel>.from(
        (json['data'] as List).map((X) => OvertimeModel.fromJson(X))
      )
    );
  }
}

class OvertimeModel{
  String id;
  String outlet;
  String nip;
  String name;
  DateTime date;
  int state;
  String reason;
  String rejectReason;
  TimeOfDay startTime;
  TimeOfDay finishTime;
  String assigner;

  OvertimeModel({
    required this.id,
    required this.outlet,
    required this.nip,
    required this.name,
    required this.date,
    required this.state,
    required this.reason,
    required this.rejectReason,
    required this.startTime,
    required this.finishTime,
    required this.assigner,
  });

  factory OvertimeModel.fromJson(Map<String, dynamic>json){
    // print('DEBUGGING Cek Datanya ID ${json['ID']}');
    // print('DEBUGGING Cek Datanya Outlet ${json['Outlet']}');
    // print('DEBUGGING Cek Datanya NIP ${json['NIP']}');
    // print('DEBUGGING Cek Datanya Name ${json['Name']}');
    // print('DEBUGGING Cek Datanya Tanggal ${DateTime.parse(json['Tanggal'])}');
    // print('DEBUGGING Cek Datanya Status ${json['Status']}');
    // print('DEBUGGING Cek Datanya Keperluan ${json['Keperluan']}');
    // print('DEBUGGING Cek Datanya RejectComment ${json['RejectComment']??''}');
    // print('DEBUGGING Cek Datanya WaktuMulai ${json['Form']['WaktuMulai']}');
    // print('DEBUGGING Cek Datanya WaktuSelesai ${json['Form']['WaktuSelesai']}');
    // print('DEBUGGING Cek Datanya Penugas ${json['Form']['Penugas']}');
    return OvertimeModel(
        id: json['ID'],
        outlet: json['Outlet'],
        nip: json['NIP'],
        name: json['Name'],
        date: DateTime.parse(json['Tanggal']),
        state: json['Status'],
        reason: json['Keperluan'],
        rejectReason: json['RejectComment'] ?? '',
        startTime: CustomConverter.stringToTime(json['Form']['WaktuMulai']),
        finishTime: CustomConverter.stringToTime(json['Form']['WaktuSelesai']),
        assigner: json['Form']['Penugas']
    );
  }
}