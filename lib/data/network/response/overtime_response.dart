import 'package:flutter/material.dart';

class OvertimeResponse{
  bool state;
  String message;
  
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
    return OvertimeModel(
      id: json['ID'], 
      outlet: json['Outlet'], 
      nip: json['NIP'], 
      name: json['Name'], 
      date: DateTime.parse(json['Tanggal']), 
      state: json['Status'], 
      reason: json['Keperluan'], 
      rejectReason: json['RejectComment'], 
      startTime: json['Form']['WaktuMulai'], 
      finishTime: json['Form']['WaktuSelesai'],
      assigner: json['Form']['Penugas']
    );
  }
}