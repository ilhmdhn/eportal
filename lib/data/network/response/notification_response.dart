class NotificationResponse{
  bool state;
  String message;
  List<NotificationModel>? data;

  NotificationResponse({
    required this.state,
    required this.message,
    this.data
  });

  factory NotificationResponse.fromJson(Map<String, dynamic>json){
    return NotificationResponse(
      state: json['state'], 
      message: json['message'],
      data: List<NotificationModel>.from(
        (json['data'] as List).map((x)=>NotificationModel.fromJson(x))
      )
    );
  }
}

class NotificationModel{
  int id;
  String time;
  String title;
  String content;
  bool isViewed;
  String type;

  NotificationModel({
    required this.id,
    required this.time,
    required this.title,
    required this.content,
    required this.isViewed,
    required this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic>json){
    return NotificationModel(
      id: json['id'], 
      time: json['time'], 
      title: json['title'], 
      content: json['content'], 
      isViewed: json['isViewed'] == '1'? true: false, 
      type: json['type']
    );
  }
}