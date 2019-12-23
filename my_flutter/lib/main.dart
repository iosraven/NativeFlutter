import 'package:flutter/material.dart';
import 'dart:ui';
import 'present.dart';
import 'push.dart';
void main() => runApp(_widgetForRoute(window.defaultRouteName));

Widget _widgetForRoute(String route) {

  print('路径：' + route);
  
  switch (route){
    case 'PresentAppPage':
    return PresentAPP();
    case 'PushAppPage':
    return PushApp();
    default:
    return PresentAPP();

  }

}
