import 'package:eportal/data/network/network_request.dart';
import 'package:eportal/data/network/response/list_response.dart';
import 'package:eportal/util/toast.dart';
import 'package:flutter/material.dart';

class ListOutletProvider with ChangeNotifier{
  List<OutletModel> _list = [];
  bool _isLoading = false;
  bool _isError = false;
  String _errorMessage = '';

  List<OutletModel> get outletList => _list;
  bool get isLoading => _isLoading;
  bool get isError => _isError;
  String get errorMessage => _errorMessage;

  Future<void> init()async{
    await getList();
  }

  void updateDistance(List<OutletModel> list){
    _list = list;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  Future<void> getList()async{
    _isLoading = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });

    final networkResponse = await NetworkRequest.getOutletList();
    if(networkResponse.state =! true){
      _isError = true;
      _errorMessage = networkResponse.message;
      ShowToast.error('Gagal mendapatkan list outlet ${networkResponse.message}');
    }else{
      _list = networkResponse.data??[];
    }
    _isLoading = false;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }
}