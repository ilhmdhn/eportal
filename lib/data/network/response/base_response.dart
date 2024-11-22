class BaseResponse {
  bool? state;
  String? message;

  BaseResponse({this.state, this.message});

  factory BaseResponse.fromJson(Map<String, dynamic> json) {
    return BaseResponse(
        state: json['state'], message: json['message']);
  }
}
