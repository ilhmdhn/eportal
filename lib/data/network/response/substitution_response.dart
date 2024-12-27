class SubstitutionResponse{
  bool state;
  String message;
  List<SubstitutionModel>? data;

  SubstitutionResponse({
    required this.state,
    required this.message,
    this.data
  });

  factory SubstitutionResponse.fromJson(Map<String, dynamic>json){
    return SubstitutionResponse(
      state: json['state'], 
      message: json['message'],
      data: List<SubstitutionModel>.from(
        (json['data'] as List).map((x) => SubstitutionModel.fromJson(x))
      )
    );
  }
}

class SubstitutionModel{
  String id;
  String outlet;
  String nip;
  String name;
  int overtime;
  DateTime dateSource;
  bool editable;
  bool cancelable;
  DateTime dateFurlough;
  String reason;
  String rejectReason;
  int state;

  SubstitutionModel({
    required this.id,
    required this.outlet,
    required this.nip,
    required this.name,
    required this.overtime,
    required this.editable,
    required this.cancelable,
    required this.dateSource,
    required this.dateFurlough,
    required this.reason,
    required this.rejectReason,
    required this.state,
  });

  factory SubstitutionModel.fromJson(Map<String, dynamic>json){
    return SubstitutionModel(
        id: json['id'], 
        outlet: json['outlet'], 
        nip: json['nip'], 
        overtime: json['overtime'],
        name: json['name'], 
        editable: json['editable'], 
        cancelable: json['cancellable'], 
        dateSource: DateTime.parse(json['date_source']), 
        dateFurlough: DateTime.parse(json['date_furlough']), 
        reason: json['reason'], 
        rejectReason: json['reject_comment']??'', 
        state: json['status']
    );
  }
}