import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {
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
          
          let name = UIDevice.current.name
          result(name)
      }
      
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
