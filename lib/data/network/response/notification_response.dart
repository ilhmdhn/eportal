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
  DateTime date;
  String title;
  String content;
  bool isViewed;
  String type;

  NotificationModel({
    required this.date,
    required this.title,
    required this.content,
    required this.isViewed,
    required this.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic>json){
    return NotificationModel(
      date: json['date'], 
      title: json['title'], 
      content: json['content'], 
      isViewed: json['isViewed'] == '1'? true: false, 
      type: json['type']
    );
  }
}