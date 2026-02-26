import 'dart:typed_data';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../features/utility/const/environment.dart';
import 'logger_service.dart';
import 'mixpanel_tracker.dart';
import 'sentry_service.dart';
import 'session_manager.dart';

class AnalyticsService {
  AnalyticsService._internal();

  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() => _instance;

  final MixpanelTracker _tracker = MixpanelTracker();
  final SessionManager _sessionManager = SessionManager();
  final MyLog _log = MyLog('AnalyticsService');

  bool _isInitialized = false;
  bool _staticPropsRegistered = false;

  Future<void> init() async {
    if (_isInitialized) return;
    final token = Environment.mixpanelToken;
    if (token.isEmpty) {
      _log.w('Mixpanel token missing; analytics disabled.');
      return;
    }

    await _tracker.init(token: token);
    await _registerStaticSuperProperties();
    _isInitialized = true;
  }

  Future<void> _registerStaticSuperProperties() async {
    if (_staticPropsRegistered) return;
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final props = {
        'app_version': packageInfo.version,
      };
      _tracker.setStaticSuperProperties(props);
      _staticPropsRegistered = true;
    } catch (err, st) {
      _log.e('Failed to determine package info for analytics', err, st);
    }
  }

  Future<void> identifyUser(String distinctId) async {
    if (!_isInitialized) return;
    if (distinctId.trim().isEmpty) return;
    _tracker.identify(distinctId);
  }

  Future<void> setUserProperties(Map<String, dynamic> props) async {
    if (!_isInitialized) return;
    if (props.isEmpty) return;
    _tracker.setPeopleProperties(props);
  }

  Future<void> startSession({String origin = 'home'}) async {
    if (!_isInitialized) return;
    final snapshot = _sessionManager.startNewSession();
    _tracker.attachSession(snapshot.sessionId);
    await _tracker.track('session_started', properties: {
      'origin': origin,
      ...snapshot.toJson(),
    });
  }

  Future<void> endSession(SessionEndReason reason) async {
    if (!_isInitialized) return;
    final snapshot = _sessionManager.endSession(reason: reason);
    if (snapshot == null) {
      return;
    }
    await _tracker.track('session_ended', properties: snapshot.toJson());
    _tracker.detachSession();
  }

  Future<void> trackScreenView(
    String screenName, {
    Map<String, dynamic>? extra,
  }) async {
    if (!_isInitialized) return;
    final payload = {
      'screen_name': screenName,
      'timestamp': DateTime.now().toIso8601String(),
      ...?extra,
    };
    await _tracker.track('screen_view', properties: payload);
  }

  Future<void> trackButtonClicked(
    String buttonName, {
    String? screenName,
    Map<String, dynamic>? extra,
  }) async {
    if (!_isInitialized) return;
    final payload = {
      'button_name': buttonName,
      if (screenName != null) 'screen_name': screenName,
      'timestamp': DateTime.now().toIso8601String(),
      ...?extra,
    };
    await _tracker.track('button_clicked', properties: payload);
  }

  Future<void> trackPaymentScreenOpened({
    double? amount,
    String? method,
  }) async {
    if (!_isInitialized) return;
    final payload = {
      if (amount != null) 'amount': amount,
      if (method != null) 'method': method,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _tracker.track('payment_screen_opened', properties: payload);
  }

  Future<void> trackPaymentSuccess({
    double? amount,
    Duration? duration,
  }) async {
    if (!_isInitialized) return;
    final payload = {
      if (amount != null) 'amount': amount,
      if (duration != null) ...{
        'duration_ms': duration.inMilliseconds,
        'duration_seconds': duration.inSeconds,
      },
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _tracker.track('payment_success', properties: payload);
  }

  Future<void> trackPaymentFailed({
    String? reason,
    double? amount,
  }) async {
    if (!_isInitialized) return;
    final payload = {
      if (reason != null) 'reason': reason,
      if (amount != null) 'amount': amount,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _tracker.track('payment_failed', properties: payload);
  }

  Future<void> trackApiCall({
    required String method,
    required String endpoint,
    Duration? duration,
    int? statusCode,
    bool success = true,
  }) async {
    if (!_isInitialized) return;
    final payload = {
      'method': method,
      'endpoint': endpoint,
      'status_code': statusCode,
      'duration_ms': duration?.inMilliseconds,
      'success': success,
      'timestamp': DateTime.now().toIso8601String(),
    }..removeWhere((key, value) => value == null);
    await _tracker.track('api_call', properties: payload);
  }

  // ⚠️ Sentry: Exception loglama
  void logException(
    dynamic error,
    StackTrace stackTrace, {
    Map<String, dynamic>? extras,
    String? tag,
  }) {
    // Yeni SentryService'i kullan
    SentryService().logException(
      error,
      stackTrace,
      extra: extras,
      tag: tag,
    );
  }

  // ⚠️ Sentry: Basit mesaj loglama
  void logMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? extras,
    String? tag,
  }) {
    // Yeni SentryService'i kullan
    SentryService().logEvent(
      message,
      level: level,
      extra: extras,
      tag: tag,
    );
  }

  // 📎 Sentry: Kullanıcı geri bildirimi + ekran görüntüsü
  Future<void> logUserFeedback({
    required String comment,
    required Uint8List screenshot,
    String? tag,
  }) async {
    await Sentry.captureEvent(
      SentryEvent(
        level: SentryLevel.info,
        message: SentryMessage('User Feedback'),
        extra: {'comment': comment},
      ),
      withScope: (scope) {
        if (tag != null) {
          scope.setTag('tag', tag);
        }
        scope.addAttachment(
          SentryAttachment.fromUint8List(
            screenshot,
            'user_feedback_screenshot.png',
            contentType: 'image/png',
          ),
        );
      },
    );
  }
}
