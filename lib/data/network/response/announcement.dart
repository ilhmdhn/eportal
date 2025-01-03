class AnnouncementResponse{
  bool state;
  String message;
  AnnouncementModel? data;

  AnnouncementResponse({
    required this.state,
    required this.message,
    this.data,
  });

  factory AnnouncementResponse.fromJson(Map<String, dynamic>json){
    return AnnouncementResponse(
      state: json['state'], 
      message: json['message'],
      data: json['data']
    );
  }
}

class AnnouncementModel{
  String title;
  String summary;
  String content;

  AnnouncementModel({
    required this.title,
    required this.summary,
    required this.content,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic>json){
    return AnnouncementModel(
      title: json['title'], 
      summary: json['summary'], 
      content: json['content']
    );
  }
}