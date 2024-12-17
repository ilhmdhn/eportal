import 'package:eportal/page/error/error_page.dart';
import 'package:eportal/util/navigation_observer.dart';
import 'package:eportal/util/toast.dart';
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
    final observer = GetIt.I<CustomNavigatorObserver>();
    final previousRoute = observer.getPreviousRouteName();
    ShowToast.warning('Previous route namez: $previousRoute');

    return navigatorKey.currentState!.pushReplacementNamed(ErrorPage.nameRoute, arguments: {'namePage': previousRoute, 'desc': description} 
    );
  }
  
  static void moveRemoveUntil(routeName){
    getIt<NavigationService>().pushNamedAndRemoveUntil(routeName);
  }


  static void move(routeName) {
    getIt<NavigationService>().pushNamed(routeName);
  }

  static void error({String description = ''}){
    
    getIt<NavigationService>().errorPage(description);
  }

  static void back() {
    getIt<NavigationService>().goBack();
  }

  void goBack() => navigatorKey.currentState!.pop();
}


void setupLocator() {
  getIt.registerLazySingleton(() => NavigationService(navigatorKey: navigatorKey));
  getIt.registerSingleton<CustomNavigatorObserver>(CustomNavigatorObserver());
}
