import 'package:eportal/data/network/response/notification_response.dart';
import 'package:eportal/page/schedule/schedule_page.dart';
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

class NotificationProvider with ChangeNotifier{
  final List<NotificationModel> _list = [];
  int unreaded = 0;
  List<NotificationModel> get data => _list;
  int get length => _list.length;


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
    _list.clear();
    final listTemp = [
      NotificationModel(
          id: 1,
          time: '08:00',
          title: 'Info',
          content: 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum',
          isViewed: true,
          type: '1'),
      NotificationModel(
          id: 2,
          time: '22/11',
          title: 'Success',
          content: 'Pengajuan cuti kamu telah disetujui',
          isViewed: false,
          type: '2'),
      NotificationModel(
          id: 3,
          time: '12:12',
          title: 'Reject',
          content: 'Pengajuan cuti kamu ditolak',
          isViewed: false,
          type: '3'),
    ];

    _list.addAll(listTemp);
    updateUnreaded();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
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