/// -------------------------------
/// Created with Flutter Dart File.
/// User tianNanYiHao@163.com
/// Date: 2020-08-10
/// Time: 11:26
/// Des: 用于记录一些 全局共享的基础数据
/// -------------------------------

///

import 'dart:ui';

class GlobalUtils {
  static late num screenW; //设备的宽高
  static late num screenH; //设备的宽高
  static late num devicePixelRatio; // 设备的像素密度
  static late Size physicalSize; // 设备的尺寸... (px)

  /// 初始化设备的宽高
  /// 全局记录设备的基本信息
  GlobalUtils.initDeviceW_H() {
    // 从 window对象获取屏幕的物理尺寸(px) 及 像素密度
    final physicalSize = window.physicalSize;
    final devicePixelRatio = window.devicePixelRatio;
    GlobalUtils.devicePixelRatio = devicePixelRatio;
    GlobalUtils.physicalSize = physicalSize;
    // 计算出ios/android 常用的屏幕宽高 (dp / pt);
    GlobalUtils.screenW =
        GlobalUtils.physicalSize.width / GlobalUtils.devicePixelRatio;
    GlobalUtils.screenH =
        GlobalUtils.physicalSize.height / GlobalUtils.devicePixelRatio;
  }
}
