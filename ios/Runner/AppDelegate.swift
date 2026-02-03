import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    private var eventSink: FlutterEventSink?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication
            .LaunchOptionsKey: Any]?
    ) -> Bool {

        return super.application(
            application,
            didFinishLaunchingWithOptions: launchOptions
        )
    }

    // 所有插件注册必须搬到这里
    func didInitializeImplicitFlutterEngine(
        _ engineBridge: FlutterImplicitEngineBridge
    ) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)

//                GeneratedPluginRegistrant.register(with: self)
        //        let vc = window.rootViewController as! FlutterViewController
//        let channel = FlutterMethodChannel(
//            name: "com.flutter.api/device",
//            binaryMessenger: engineBridge.applicationRegistrar.messenger()
//        )
//        channel.setMethodCallHandler { [weak self] call, result in
//            guard call.method == "getDeviceName" else {
//                result(FlutterMethodNotImplemented)
//                return
//            }
//
//            let messageChannel = FlutterBasicMessageChannel(
//                name: "com.flutter.api/echo",
//                binaryMessenger: engineBridge.applicationRegistrar.messenger(),
//                codec: FlutterStringCodec.sharedInstance()
//            )
//            messageChannel.setMessageHandler { [weak self] message, reply in
//                let msg = message as? String ?? ""
//                print("收到来自 Dart 的消息：\(msg)")
//                reply("iOS 已收到：\(msg)")  // 回复给 Dart
//                let vc = ApplePayVC()
//                self?.window?.rootViewController?.present(vc, animated: true)
//            }
//
//            let name = UIDevice.current.name
//            result(name)
//        }
//
//        let eventChannel = FlutterEventChannel(
//            name: "com.flutter.api/counter",
//            binaryMessenger: engineBridge.applicationRegistrar.messenger()
//        )
//        eventChannel.setStreamHandler(self)

    }

    override func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {

    }

    override func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

}

extension AppDelegate: FlutterStreamHandler {
    func onListen(
        withArguments arguments: Any?,
        eventSink events: @escaping FlutterEventSink
    ) -> FlutterError? {
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
