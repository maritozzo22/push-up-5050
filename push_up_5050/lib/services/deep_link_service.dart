import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:push_up_5050/screens/series_selection/series_selection_screen.dart';

/// Service for handling deep links from Android widgets
class DeepLinkService {
  static const String _channelName = 'com.pushup5050.push_up_5050/deep_link';
  static const String _seriesSelectionUrl = 'pushup5050://series_selection';

  MethodChannel? _channel;
  final void Function(String route) onDeepLink;

  DeepLinkService({required this.onDeepLink});

  /// Initialize deep link service
  Future<void> initialize() async {
    _channel = const MethodChannel(_channelName);

    // Check for initial deep link (app cold start)
    final initialLink = await _channel?.invokeMethod('getInitialDeepLink');
    if (initialLink != null && initialLink is String) {
      _handleDeepLink(initialLink);
    }

    // Listen for new deep links (app already running)
    _channel?.setMethodCallHandler((call) async {
      if (call.method == 'onDeepLink') {
        final url = call.arguments as Map?;
        final urlString = url?['url'] as String?;
        if (urlString != null) {
          _handleDeepLink(urlString);
        }
      }
    });
  }

  void _handleDeepLink(String url) {
    if (url == _seriesSelectionUrl) {
      onDeepLink(SeriesSelectionScreen.routeName);
    }
  }
}
