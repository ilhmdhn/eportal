import 'package:eportal/util/checker.dart';
import 'package:eportal/util/converter.dart';
import 'package:flutter/material.dart';

class JkoResponse {
  bool state;
  String message;
  List<JkoModel>? data;

  JkoResponse({
    required this.state,
    required this.message,
    this.data,
  });

  factory JkoResponse.fromJson(Map<String, dynamic> json){
    return JkoResponse(
      state: json['state'], 
      message: json['message'],
      data: List<JkoModel>.from(
        (json['data'] as List).map((x) => JkoModel.fromJson(x))
      )
    );
  }
}

class JkoModel{
  String nip;
  String name;
  DateTime date;
  String code;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? id;

  JkoModel({
    required this.nip,
    required this.name,
    required this.date,
    required this.code,
    this.startTime,
    this.endTime,
    this.id
  });

  factory JkoModel.fromJson(Map<String, dynamic>json){
    return JkoModel(
      nip: json['nip'],
      name: json['name'], 
      date: DateTime.parse(json['date']), 
      code: json['code'],
      id: json['id']??'',
      startTime: isNullOrEmpty(json['start_time']) ?TimeOfDay.now(): CustomConverter.stringToTime(json['start_time']),
      endTime: isNullOrEmpty(json['end_time']) ?TimeOfDay.now(): CustomConverter.stringToTime(json['end_time']),
    );
  }
}