import 'package:flutter/material.dart';
import 'package:huntoo/screens/thread_screen.dart';

class Routes {
  Map<String, Widget Function(BuildContext)> _routes = {};
  get routes => _routes;
  
  Routes(){
    _routes = {'thread': (context) => const ThreadScreen()};
  }
}