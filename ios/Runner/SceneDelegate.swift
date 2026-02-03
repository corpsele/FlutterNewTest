//
//  SceneDelegate.swift
//  ios16.2_Temp
//
//  Created by corpsele_n on 2026/1/28.
//

import UIKit
import Flutter

class SceneDelegate: FlutterSceneDelegate {

    private var eventSink: FlutterEventSink?
    
    let flutterEngine = FlutterEngine(name: "FlutterNewEngine")  // 手动创建引擎
    

    override func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)

        flutterEngine.run()  // 运行引擎
        GeneratedPluginRegistrant.register(with: flutterEngine)  // 注册插件
        self.registerSceneLifeCycle(with: flutterEngine)  // 注册场景生命周期
        let viewController = FlutterViewController(engine: flutterEngine,nibName: "Main", bundle: Bundle.main)  // 创建 FlutterViewController
        window?.rootViewController = viewController
        window?.makeKeyAndVisible()

        let channel = FlutterMethodChannel(
            name: "com.flutter.api/device",
            binaryMessenger: viewController.binaryMessenger
        )
        channel.setMethodCallHandler { [weak self] call, result in
            guard call.method == "getDeviceName" else {
                result(FlutterMethodNotImplemented)
                return
            }

            let messageChannel = FlutterBasicMessageChannel(
                name: "com.flutter.api/echo",
                binaryMessenger: viewController.binaryMessenger,
                codec: FlutterStringCodec.sharedInstance()
            )
            messageChannel.setMessageHandler { [weak self] message, reply in
                let msg = message as? String ?? ""
                print("收到来自 Dart 的消息：\(msg)")
                reply("iOS 已收到：\(msg)")  // 回复给 Dart
                let vc = ApplePayVC()
                self?.window?.rootViewController?.present(vc, animated: true)
            }

            let name = UIDevice.current.name
            result(name)
        }

        let eventChannel = FlutterEventChannel(
            name: "com.flutter.api/counter",
            binaryMessenger: viewController.binaryMessenger
        )
        eventChannel.setStreamHandler(self)
    }
    
    override func sceneDidDisconnect(_ scene: UIScene) {
        self.unregisterSceneLifeCycle(with: flutterEngine)
    }

}


extension SceneDelegate: FlutterStreamHandler {
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
