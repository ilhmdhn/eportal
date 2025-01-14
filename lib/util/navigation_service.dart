import 'package:eportal/page/error/error_page.dart';
import 'package:eportal/util/navigation_observer.dart';
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

  Future<dynamic> errorPage(String description){
    return navigatorKey.currentState!.pushReplacementNamed(ErrorPage.nameRoute, arguments: {'namePage': '', 'desc': description} 
    );
  }
  Future<dynamic> pushReplacementNamed(String routeName){
    return navigatorKey.currentState!.pushReplacementNamed(routeName);
  }
  
  static void moveRemoveUntil(routeName){
    getIt<NavigationService>().pushNamedAndRemoveUntil(routeName);
  }


  static void move(routeName) {
    getIt<NavigationService>().pushNamed(routeName);
  }

  static void moveWithData(routeName, data) {
    getIt<NavigationService>().goMoveWithData(routeName, data);
  }

  static void error({String description = ''}){
    
    getIt<NavigationService>().errorPage(description);
  }

  static void back() {
    getIt<NavigationService>().goBack();
  }

  static void backWithData(data){
    getIt<NavigationService>().goBackWithData(data);
  }

  void goBack() => navigatorKey.currentState!.pop();

  static void replacePage(String routeName) => getIt<NavigationService>().pushReplacementNamed(routeName);

  void goBackWithData(data) => navigatorKey.currentState!.pop(data);

  void goMoveWithData(routeName, data) => navigatorKey.currentState!.pushNamed(routeName, arguments: data);
}


void setupLocator() {
  getIt.registerLazySingleton(() => NavigationService(navigatorKey: navigatorKey));
  getIt.registerSingleton<CustomNavigatorObserver>(CustomNavigatorObserver());
}
