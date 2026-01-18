import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
    private var eventSink: FlutterEventSink?
    
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      let vc = window.rootViewController as! FlutterViewController
      let channel = FlutterMethodChannel(name: "com.flutter.api/device", binaryMessenger: vc.binaryMessenger)
      channel.setMethodCallHandler {[weak self] call, result in
          guard call.method == "getDeviceName" else {
              result(FlutterMethodNotImplemented)
              return
          }
          
          let messageChannel = FlutterBasicMessageChannel(name: "com.flutter.api/echo", binaryMessenger: vc.binaryMessenger, codec: FlutterStringCodec.sharedInstance())
          messageChannel.setMessageHandler { message, reply in
              let msg = message as? String ?? ""
              print("收到来自 Dart 的消息：\(msg)")
              reply("iOS 已收到：\(msg)")  // 回复给 Dart
          }
          
          let name = UIDevice.current.name
          result(name)
      }
      
      let eventChannel = FlutterEventChannel(name: "com.flutter.api/counter", binaryMessenger: vc.binaryMessenger)
      eventChannel.setStreamHandler(self)
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    
}

extension AppDelegate: FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = events

        // 模拟每秒发送一个数字
        var value = 0
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
          guard let sink = self.eventSink else {
            timer.invalidate()
            return
          }
          sink(value)
          value += 1
        }

        return nil
    }
    
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        self.eventSink = nil
        return nil
    }
}
