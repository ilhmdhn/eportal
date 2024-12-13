class OutletResponse{
  bool state;
  String message;
  List<OutletModel>? data;

  OutletResponse({
    required this.state,
    required this.message,
    this.data,
  });

  factory OutletResponse.fromJson(Map<String, dynamic>json){
    return OutletResponse(
      state: json['state'], 
      message: json['message'],
      data: List<OutletModel>.from(
        (json['location'] as List).map((x)=> OutletModel.fromJson(x))
      )
    );
  }
}

class OutletModel{
  String code;
  String name;
  String brand;
  double lat;
  double long;
  double distance;

  OutletModel({
    required this.code,
    required this.name,
    required this.brand,
    required this.lat,
    required this.long,
    this.distance = 0,
  });

  factory OutletModel.fromJson(Map<String, dynamic>json){
    return OutletModel(
      code: json['code'],
      name: json['name'],
      brand: json['brand'],
      lat: double.parse(json['latitude']),
      long: double.parse(json['longitude']),
    );
  }
}