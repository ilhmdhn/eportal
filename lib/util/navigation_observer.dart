import 'package:flutter/material.dart';

class CustomNavigatorObserver extends NavigatorObserver {
  final List<Route<dynamic>> navigationStack = [];

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    navigationStack.add(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    navigationStack.removeLast();
    super.didPop(route, previousRoute);
  }

  String? thisRouteName() {
      return navigationStack[navigationStack.length - 2].settings.name;
  }

  String? getPreviousRouteName() {
    if (navigationStack.length > 1) {
      return navigationStack[navigationStack.length - 2].settings.name;
    }
    return null;
  }

  String? getTwoPagesBackRouteName() {
    if (navigationStack.length > 2) {
      return navigationStack[navigationStack.length - 3].settings.name;
    }
    return null;
  }
}
