import 'package:flutter/material.dart';

class IzinResponse {
  bool state;
  String message;
  List<IzinListModel>? data;

  IzinResponse({
    this.state = false,
    this.message = 'Failed',
    this.data
  });

  factory IzinResponse.fromJson(Map<String, dynamic> json){
    return IzinResponse(
      state: json['state'],
      message: json['message'],
      data: List<IzinListModel>.from(
        (json['data'] as List).map((x)=> IzinListModel.fromJson(x))
      )
    );
  }
}

class IzinDetail{
  
}

class IzinListModel{
  String? id;
  String? outlet;
  String? nip;
  String? name;
  DateTime? startDate;
  DateTime? finishDate;
  String? year;
  int? type;
  TimeOfDay? startTime;
  TimeOfDay? finishTime;
  String? doctorLetter;
  String? invitationUrl;
  String? hlpUrl;
  String? reason;
  int? state;
  String? rejectReason;

  IzinListModel({
    this.id,
    this.outlet,
    this.nip,
    this.name,
    this.startDate,
    this.finishDate,
    this.year,
    this.type,
    this.startTime,
    this.finishTime,
    this.doctorLetter,
    this.invitationUrl,
    this.hlpUrl,
    this.reason,
    this.state,
    this.rejectReason,
  });

  factory IzinListModel.fromJson(Map<String ,dynamic>json){
    return IzinListModel(
      id: json['ID'],
      outlet: json['Outlet'],
      nip: json['NIP'],
      name: json['Name'],
      startDate: json['Tanggal'],
      finishDate: json['TanggalSelesai'],
      year: json['Tahun'],
      type: json['Type'],
      startTime: json['StartTime'],
      finishTime: json['EndTime'],
      doctorLetter: json['SuratDokter'],
      invitationUrl: json['Invitation'],
      hlpUrl: json['HPL'],
      reason: json['Keperluan'],
      state: json['Status'],
      rejectReason: json['RejectComment'],
    );
  }
}