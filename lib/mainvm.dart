import 'dart:ffi';

import 'package:flutter/services.dart' show rootBundle;

class MainVM {

  MainVM._();

  static MainVM _instance = MainVM._();

  factory MainVM() => _instance;

  late List listDatas;

  static Future<void> loadDatas() async{

  }
}