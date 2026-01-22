package com.pushup5050.push_up_5050

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.pushup5050.push_up_5050.widget.WidgetUpdateReceiver

class MainActivity: FlutterActivity() {
    companion object {
        private const val DEEP_LINK_CHANNEL = "com.pushup5050.push_up_5050/deep_link"
        private const val WIDGET_CHANNEL = "com.pushup5050/widget"
        const val DEEP_LINK_EXTRA = "deep_link_url"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Set up method channel for deep link communication
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, DEEP_LINK_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialDeepLink" -> {
                        val deepLink = intent?.data?.toString()
                        result.success(deepLink)
                    }
                    else -> result.notImplemented()
                }
            }

        // Set up method channel for widget operations
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, WIDGET_CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "scheduleMidnightUpdate" -> {
                        WidgetUpdateReceiver.scheduleMidnightUpdate(this)
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    override fun onNewIntent(intent: android.content.Intent) {
        super.onNewIntent(intent)
        // Update the intent so new deep links are processed
        setIntent(intent)

        // Notify Flutter of the new deep link
        val deepLink = intent.data?.toString()
        if (deepLink != null) {
            flutterEngine?.dartExecutor?.binaryMessenger?.let {
                MethodChannel(it, "com.pushup5050.push_up_5050/deep_link")
                    .invokeMethod("onDeepLink", mapOf("url" to deepLink))
            }
        }
    }
}
