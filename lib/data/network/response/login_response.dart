class LoginResponse{
  bool? state;
  String? message;
  String? key;

  LoginResponse({
    this.state = false,
    this.message = '',
    this.key = ''
  });

    factory LoginResponse.fromJson(Map<String, dynamic> json) {
    if (json['state'] != true) {
      throw json['message'];
    }
    return LoginResponse(
        state: json['state'],
        message: json['message'],
        key: json['data']
    );
  }
}