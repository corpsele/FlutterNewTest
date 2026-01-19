package com.example.flutternewtest

import android.os.Build
import android.os.Handler
import android.os.Looper
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.BasicMessageChannel
import io.flutter.plugin.common.StringCodec
class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.flutter.api/device"
    private val EVENT_CHANNEL = "com.fluuter.api/counter"
    private val MESSAGE_CHANNEL = "com.flutter.api/echo"

    private var eventSink: EventChannel.EventSink? = null
    private var count = 0
    private val handler = Handler(Looper.getMainLooper())


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // 3. 设置 MethodChannel 处理器
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->

            // 4. 根据 call.method 判断 Flutter 调用了哪个方法
            if (call.method == "getPlatformVersion") {
                // 获取 Android 版本
                val version = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    "Android " + Build.VERSION.RELEASE + " (API " + Build.VERSION.SDK_INT + ")"
                } else {
                    "Old Version"
                }

                print("getPlatformVersion = $version")

                // 返回成功结果给 Flutter
                result.success(version)

            } else if (call.method == "calculateSquare") {
                // 接收参数
                val number = call.argument<Int>("number")

                if (number != null) {
                    val square = number * number
                    // 返回计算结果
                    result.success(square)
                } else {
                    // 返回错误结果
                    result.error("INVALID_ARGUMENT", "参数不能为空", null)
                }

            } else {
                // 如果 Flutter 调用了未实现的方法
                result.notImplemented()
            }
        }

        // ==========================================
        // 1. 配置 EventChannel (用于发送事件流)
        // ==========================================
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    // Flutter 开始监听时触发
                    eventSink = events
                    // 可以在这里自动开始，或者等待 Flutter 的 MethodChannel 命令
                }

                override fun onCancel(arguments: Any?) {
                    // Flutter 取消监听时触发
                    eventSink = null
                    handler.removeCallbacks(counterRunnable)
                }
            }
        )


        // 1. 建立 BasicMessageChannel
        // 使用 StringCodec.INSTANCE 对应 Flutter 端的 StringCodec
        val messageChannel = BasicMessageChannel<String>(flutterEngine.dartExecutor.binaryMessenger, MESSAGE_CHANNEL, StringCodec.INSTANCE)

        // 2. 设置消息处理器 (处理 Flutter 发来的消息)
        messageChannel.setMessageHandler { message, reply ->
            // message: Flutter 发来的内容
            // reply: 用于回复 Flutter 的回调对象

            println("收到 Flutter 的消息: $message")

            // 处理消息：这里简单地把消息转换成大写
            val processedMessage = message?.uppercase() ?: "空消息"

            // 返回处理后的消息给 Flutter (异步)
            reply.reply(processedMessage)
        }

        // 3. 演示：Android 主动发送消息给 Flutter
        // 比如在 Activity 启动时，告知 Flutter "Android 系统已就绪"
        // 注意：要等 Flutter 端的 MessageHandler 绑定好了再发，否则 Flutter 收不到
        // 这里为了演示，我们在主线程延迟 1 秒发送
        Handler().postDelayed({
            messageChannel.send("Android: 系统已就绪，随时待命！") { replyFromFlutter ->
                // 如果我们发送消息并期待 Flutter 回复，可以在这里处理
                println("Flutter 对我们主动消息的回复: $replyFromFlutter")
            }
        }, 1000)
    }

    // 定义一个递增的 Runnable
    private val counterRunnable = object : Runnable {
        override fun run() {
            count++
            // 1. 通过 EventSink 发送数据给 Flutter (Event)
            eventSink?.success(count)
            // 1秒后再执行一次
            handler.postDelayed(this, 1000)
        }
    }
}
