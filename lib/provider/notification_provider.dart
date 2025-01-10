import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/notification_response.dart';
import 'package:eportal/page/schedule/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class NotificationProvider with ChangeNotifier{
  final List<NotificationModel> _list = [];
  int unreaded = 0;
  List<NotificationModel> get data => _list;
  int get length => _list.length;

  NotificationProvider(){
    getList();
  }

  Future<void> init()async{
    await getList();
  }

  void updateIsViewed(int id){
    _list.forEachIndexed((index, element){
      if(element.id == id){
        _list[index].isViewed = true;
      }
    });
    updateUnreaded();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> getList()async{
    final networkResponse = await NetworkRequest.getNotifThumb();
    if(networkResponse.state){
      _list.clear();
      _list.addAll(networkResponse.data??[]);
      updateUnreaded();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  void updateUnreaded(){
    unreaded = 0;
    for (var value in _list) {
      if(!value.isViewed){
        unreaded += 1;
      }
    }
  }
}