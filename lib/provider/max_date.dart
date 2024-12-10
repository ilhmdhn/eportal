import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';

class MaxDateProvider with ChangeNotifier{
  DateTime _date = DateTime.now();
  bool _isLoading = false;

  DateTime get date => _date;
  bool get isLoading => _isLoading;

  DateTime oneYear = DateTime.now().add( const Duration(days: 365));

  Future<void> updateDate(DateTime startDate, String type)async{
    _isLoading = true;
    notifyListeners();

    final maxDate = await NetworkRequest.getMaxDate(type, startDate);
    _isLoading = false;

    if(maxDate.state != true){
      _date = oneYear;
      ShowToast.error('Gagal mendapatkan max date');
    }else{
      try{
        _date = DateTime.parse(maxDate.data?? oneYear.toString());
      }catch(e){
        ShowToast.error('Gagal parse tanggal ${maxDate.data}');
        _date = oneYear;
      }
    }

    notifyListeners();
  }
}

class DateModel{
  DateTime date;
  DateModel({required this.date});
}