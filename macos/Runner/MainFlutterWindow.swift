import Cocoa
import FlutterMacOS

class MainFlutterWindow: NSWindow {

  // ⚠️ 关键：必须把 handler 存为属性，否则 ARC 会释放它，导致事件发不出去
  private var counterHandler: CounterStreamHandler?

  override func awakeFromNib() {
    let flutterViewController = FlutterViewController()
    let windowFrame = self.frame
    self.contentViewController = flutterViewController
    self.setFrame(windowFrame, display: true)

    RegisterGeneratedPlugins(registry: flutterViewController)

    let deviceChannel = FlutterMethodChannel(
      name: "com.flutter.api/device",
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )

    deviceChannel.setMethodCallHandler { (call, result) in
      switch call.method {
      case "getDeviceName":
        result(Host.current().localizedName ?? "Unknown Mac")
      case "getPlatformVersion":
        let version = ProcessInfo.processInfo.operatingSystemVersion
        result("macOS \(version.majorVersion).\(version.minorVersion)")
      case "counter":
        let counter = "1"
        result("counter = \(counter)")
      default:
        result(FlutterMethodNotImplemented)
      }
    }

    let eventChannel = FlutterEventChannel(
      name: "com.flutter.api/counter",  // ← 名字必须和 Dart 端完全一致
      binaryMessenger: flutterViewController.engine.binaryMessenger
    )
    counterHandler = CounterStreamHandler()  // 强引用
    eventChannel.setStreamHandler(counterHandler!)

    super.awakeFromNib()
  }
}


// 1. 实现 FlutterStreamHandler 协议
class CounterStreamHandler: NSObject, FlutterStreamHandler {
    private var timer: Timer?
    private var count = 0
    private var eventSink: FlutterEventSink?

    // Dart 端调用 listen() 时触发
    func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink
        count = 0
        
        // 每秒发送一个递增的数字给 Dart 端
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            self.count += 1
            self.eventSink?(self.count)  // ← 发送数据到 Dart
        }
        return nil
    }

    // Dart 端调用 cancel() 时触发
    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        timer?.invalidate()
        timer = nil
        eventSink = nil
        return nil
    }
}