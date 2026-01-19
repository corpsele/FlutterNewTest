import 'package:flutter/services.dart';

import 'dart:async';
import 'package:flutter/services.dart';

// param
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

  Future<String> getPlatformVersion() async {
    try{
      final result = await _channel.invokeMethod("getPlatformVersion");
      return result as String;
    }catch(e){
      rethrow;
    }
  }
}

// event
class CounterStream {
  static const _channel = EventChannel('com.flutter.api/counter');

  Stream<int> counter() {
    return _channel.receiveBroadcastStream().map((e) => e as int);
  }
}

// message
class EchoChannel {
  static const _channel = BasicMessageChannel<String>(
    'com.flutter.api/echo',
    StringCodec(),
  );

  Future<String> send(String message) async {
    final reply = await _channel.send(message);
    return reply as String;
  }

  void setMessageHandler(Future<String> Function(String? message) handler) {
    _channel.setMessageHandler(handler);
  }
}