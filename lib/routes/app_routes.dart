import 'package:flutter/material.dart';

import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/measurement_screen.dart';
import 'package:flutter_application_1/screens/history_screen.dart';

class AppRoutes {

  static const String home = '/';
  static const String login = '/login';
  static const String measurements = '/measurements';
  static const String history = '/history'; 

  static Map<String, WidgetBuilder> routes = {
    home: (context) => HomeScreen(),
    login: (context) => LoginScreen(),
    measurements: (context) => MeasurementScreen(),
    history: (context) => HistoryScreen(),
  };

}