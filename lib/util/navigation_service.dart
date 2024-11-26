import 'package:eportal/util/screen.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';


final getIt = GetIt.instance;
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class NavigationService {
  final GlobalKey<NavigatorState> navigatorKey;

  NavigationService({required this.navigatorKey});

  Future<dynamic> pushNamed(String routeName) {
    return navigatorKey.currentState!.pushNamed(routeName);
  }

  Future<dynamic> pushNamedAndRemoveUntil(String routeName) {
    return navigatorKey.currentState!.pushNamedAndRemoveUntil(routeName, (route) => false);
  }
  
  static void moveRemoveUntil(routeName){
    getIt<NavigationService>().pushNamedAndRemoveUntil(routeName);
  }

  static void move(routeName) {
    getIt<NavigationService>().pushNamed(routeName);
  }

  static void back() {
    getIt<NavigationService>().goBack();
  }

  void goBack() => navigatorKey.currentState!.pop();
}


void setupLocator() {
  getIt.registerLazySingleton(() => NavigationService(navigatorKey: navigatorKey));
}
