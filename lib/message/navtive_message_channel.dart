import 'package:flutter/services.dart';

class DeviceNameApi {
  static const MethodChannel _channel = 
      MethodChannel('com.flutter.api/device');

  static Future<String> getDeviceName() async {
    final String name = await _channel.invokeMethod('getDeviceName');
    return name;
  }

  static Future<String> getPlatformVersion() async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}