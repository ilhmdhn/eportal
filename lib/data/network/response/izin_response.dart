import 'package:eportal/util/checker.dart';
import 'package:eportal/util/converter.dart';
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

class IzinListModel{
  String? id;
  String? outlet;
  String? nip;
  String? name;
  DateTime? startDate;
  DateTime? finishDate;
  String? year;
  int? type;
  bool? editable;
  bool? cancelable;
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
    this.editable,
    this.cancelable,
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
      startDate: DateTime.parse(json['Tanggal']),
      editable: json['editable'],
      cancelable: json['cancellable'],
      finishDate: DateTime.parse(json['TanggalSelesai']),
      year: json['Tahun'],
      type: json['Type'],
      startTime: isNullOrEmpty(json['StartTime']) ?TimeOfDay.now(): CustomConverter.stringToTime(json['StartTime']),
      finishTime: isNullOrEmpty(json['EndTime'])? TimeOfDay.now(): CustomConverter.stringToTime(json['EndTime']),
      doctorLetter: json['SuratDokter'],
      invitationUrl: json['Invitation'],
      hlpUrl: json['HPL'],
      reason: json['Keperluan'],
      state: json['Status'],
      rejectReason: json['RejectComment'],
    );
  }
}

