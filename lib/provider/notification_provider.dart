import 'package:eportal/data/network/response/notification_response.dart';
import 'package:flutter/material.dart';

class NotificationProvider with ChangeNotifier{
  List<NotificationModel> _list = [];
  
  Future<void> init()async{
    await getList();
  }

  Future<void> getList()async{
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}