import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bluetooth_plugin/flutter_bluetooth_plugin.dart';

class BluetoothManager {
  final bluetooth = FlutterBluetoothPlugin();
  StreamSubscription? _scanSub;

  /// 初始化蓝牙 + 请求权限
  Future<bool> init() async {
    // 1. 请求权限
    // ── 第 1 步：请求权限 ──
    Map<String, BluetoothPermissionStatus> permissions;
    try {
      permissions = await bluetooth.requestPermissions();
    } on PlatformException catch (e) {
      debugPrint('权限请求异常: ${e.message}');
      print('权限请求异常: ${e.message}');
      // debugPrint('蓝牙权限未授予: ${permissions.values.toString()}');
      return false;
    }

    final bluetoothPermission = permissions.values.firstOrNull;
    // 或者更精确地取：permissions[PermissionType.bluetooth]

    if (bluetoothPermission == BluetoothPermissionStatus.granted) {
      // ✅ 权限已授予，继续检查蓝牙电源
      // await _checkBluetoothAndScan();
      print("权限已授予，继续检查蓝牙电源");
    } else if (bluetoothPermission == BluetoothPermissionStatus.denied) {
      // ❌ 用户点了"不允许"，系统不会再弹窗
      // setState(() => _status = '蓝牙权限被拒绝，请到系统设置中手动开启');
      print("用户点了\"不允许\"，系统不会再弹窗");
      return false;
    } else if (bluetoothPermission ==
        BluetoothPermissionStatus.permanentlyDenied) {
      // ❌ 永久拒绝
      debugPrint('蓝牙权限被永久拒绝');
      print('蓝牙权限被永久拒绝');

      return false;
    }

    // 2. 检查适配器状态
    // final state = await bluetooth.getAdapterState();
    // print("蓝牙适配器state = $state");
    // if (state != BluetoothAdapterState.poweredOn) {
    //   final opened = await bluetooth.requestEnable();
    //   print("蓝牙适配器open = $opened");
    //   if (opened != true) {
    //     print("蓝牙适配器未开启");
    //     // await bluetooth.openBluetoothSettings();
    //     return false;
    //   }
    // }

    final completer = Completer<bool>();

    final sub = bluetooth.adapterState.listen((state) async {
      print('蓝牙状态变化: $state');

      if (state == BluetoothAdapterState.poweredOn) {
        print("蓝牙适配器开启");
        if (!completer.isCompleted) {
          completer.complete(true);
        }
      } else if (state == BluetoothAdapterState.poweredOff) {
        // 蓝牙没开，尝试引导开启
        // bluetooth.openBluetoothSettings();
        print("蓝牙适配器未开启");
        if (!completer.isCompleted) {

          completer.complete(false);
          
        }
      } else if (state == BluetoothAdapterState.unsupported) {
        print("蓝牙适配器不支持");
        if (!completer.isCompleted) {
          completer.complete(false);
          
        }
      }
      // unknown / turningOn / resetting 继续等
    });

    // 3. 超时保护：最多等 5 秒
    Future.delayed(Duration(seconds: 5), () {
      print('等待蓝牙状态超时');
      if (!completer.isCompleted) {
        // completer.complete(false);
        
      }
    });

    final result = await completer.future;
    await sub.cancel();
    return result;
  }

  /// 开始扫描
  void startScan({
    List<String>? serviceUuids,
    Duration? timeout,
    bool allowDuplicates = false,
    BluetoothScanMode scanMode = BluetoothScanMode.ble,
  }) {
    // 先取消之前的订阅
    _scanSub?.cancel();

    _scanSub = bluetooth.scanResults.listen((result) {
      final name = result.device.name ?? result.localName ?? 'Unnamed';
      debugPrint('发现设备: $name | ${result.device.id} | RSSI: ${result.rssi}');
    });

    bluetooth.startScan(
      serviceUuids: serviceUuids ?? const [],
      timeout: timeout ?? const Duration(seconds: 15),
      allowDuplicates: allowDuplicates,
      scanMode: scanMode,
    );
  }

  /// 停止扫描
  Future<void> stopScan() async {
    await bluetooth.stopScan();
    await _scanSub?.cancel();
    _scanSub = null;
  }

  /// 连接设备并发现服务
  Future<void> connect(String deviceId) async {
    await bluetooth.connect(deviceId);
    final services = await bluetooth.discoverServices(deviceId);
    for (final s in services) {
      debugPrint('Service: ${s.uuid}');
      // 访问 s.characteristics
    }
  }

  /// 释放资源
  void dispose() {
    _scanSub?.cancel();
    _scanSub = null;
    // FlutterBluetoothPlugin 没有 dispose() 方法，不需要调用
  }
}
