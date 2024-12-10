class DataResponse {
  bool? state;
  String? message;
  String? data;

  DataResponse({this.state, this.message, this.data});

  factory DataResponse.fromJson(Map<String, dynamic> json) {
    return DataResponse(
      state: json['state'], 
      message: json['message'],
      data: json['data']
    );
  }
}
