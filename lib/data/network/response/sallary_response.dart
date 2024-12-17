class SallaryResponse{
  bool state;
  String message;
  List<SallaryModel>? data;

  SallaryResponse({
    required this.state,
    required this.message,
    this.data,
  });

  factory SallaryResponse.fromJson(Map<String, dynamic>json){
    return SallaryResponse(
      state: json['state'], 
      message: json['message'], 
      data: List<SallaryModel>.from(
        (json['data'] as List).map((x) => SallaryModel.fromJson(x))
      )
    );
  }
}

class SallaryModel{
  String nip;
  String period;
  String wages;
  String grade;
  bool show = false;

  SallaryModel({
    required this.nip,
    required this.period,
    required this.wages,
    required this.grade,
  });

  factory SallaryModel.fromJson(Map<String,dynamic>json){
    return SallaryModel(
      nip: json['nip'], 
      period: json['period'], 
      wages: json['wages'], 
      grade: json['jabatan']
    );
  }
}