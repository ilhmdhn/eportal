import 'package:eportal/util/converter.dart';
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
  bool editable;
  bool cancelable;
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
    required this.editable,
    required this.cancelable,
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
        editable: json['editable'],
        cancelable: json['cancellable'],
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