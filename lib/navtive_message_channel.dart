import 'package:flutter/services.dart';

class DeviceNameApi {
  static const _channel = MethodChannel('com.flutter.api/device');

  Future<String> getDeviceName() async {
    try{
      final result = await _channel.invokeMethod("getDeviceName");
      return result as String;
    }catch(e){
      // 原生报错输出
      rethrow;
    }
  }
}