package com.pushup5050.push_up_5050

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    companion object {
        private const val CHANNEL = "com.pushup5050.push_up_5050/deep_link"
        const val DEEP_LINK_EXTRA = "deep_link_url"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        // Set up method channel for deep link communication
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "getInitialDeepLink" -> {
                        val deepLink = intent?.data?.toString()
                        result.success(deepLink)
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
