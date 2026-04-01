import 'dart:async';

import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../features/utility/inactivity_controller.dart';
import '../../features/utility/navigation_service.dart';
import '../../features/utility/user_http_service.dart';
import '../../product/patient_registration_procedures/service/patient_registration_procedures_service.dart';
import 'analytics_service.dart';
import 'timeout_cancel_context_service.dart';
import 'sentry_service.dart';
import 'session_manager.dart';
import 'logger_service.dart';

enum UserLoginStatus { online, offline }

class UserLoginStatusService {
  /// Singleton instance
  static UserLoginStatusService? _instance;

  final StreamController<UserLoginStatus> _controller =
      StreamController<UserLoginStatus>.broadcast();

  /// Private constructor
  UserLoginStatusService._internal() {
    _loadInitialStatus();
  }

  String? _accessToken;
  String? _userName;
  String? _userSurname;
  String? _userTcNo;
  String? _currentSessionId; // Hasta session tracking için

  Stream<UserLoginStatus> get statusStream => _controller.stream;

  String? get accessToken => _accessToken;
  String? get fullName => "${_userName ?? ""} ${_userSurname ?? ""}".trim();
  String? get userName => _userName;
  String? get userSurname => _userSurname;
  String? get userTcNo => _userTcNo;

  Future<void> _loadInitialStatus() async {
    _controller.add(
      _accessToken == null ? UserLoginStatus.offline : UserLoginStatus.online,
    );
  }

  /// Singleton erişimi (ilk seferde cubit verilebilir)
  factory UserLoginStatusService() {
    return _instance ??= UserLoginStatusService._internal();
  }

  Future<void> login({
    required String accessToken,
    required int userId,
    required String name,
    required String surname,
    required String tcNo,
  }) async {
    TimeoutCancelContextService().clear();

    _accessToken = accessToken;
    _userName = name;
    _userSurname = surname;
    _userTcNo = tcNo;

    // Her hasta girişinde benzersiz session ID oluştur
    _currentSessionId = const Uuid().v4();

    _controller.add(UserLoginStatus.online);
    _inactivityStartSafe();

    await AnalyticsService().identifyUser(userId.toString());
    await AnalyticsService().startSession(origin: 'patient_login');
    await AnalyticsService().setUserProperties({
      "Name": "Lokman Hekim 3.kat",
      // "Phone": phone,
      // "Company City": cityName,
      // "Login Time": DateTime.now().toIso8601String(),
    });

    // ✅ Sentry'ye hasta context'ini ekle (Anonim ID kullan, TC Kimlik değil!)
    SentryService().setPatientContext(
      patientId: 'patient_$userId', // Anonim ID
      sessionId: _currentSessionId,
    );
    SentryService().addBreadcrumb(
      message: 'Hasta giriş yaptı: $name $surname',
      category: 'auth',
      data: {'session_id': _currentSessionId!, 'user_id': userId},
    );

    MyLog.debug("UserLoginStatusService login - Session: $_currentSessionId");
  }

  refreshTokens({required String accessToken, required String refreshToken}) {
    _accessToken = accessToken;
  }

  Future<void> logout({
    SessionEndReason reason = SessionEndReason.manual,
  }) async {
    if (reason == SessionEndReason.timeout) {
      await _tryCancelPatientTransactionOnTimeout();
    }

    // ✅ Sentry breadcrumb ve context temizle
    SentryService().addBreadcrumb(
      message: 'Hasta çıkış yaptı',
      category: 'auth',
      data: {
        'reason': reason.name,
        'session_id': _currentSessionId ?? 'unknown',
      },
    );
    SentryService().clearPatientContext();

    _accessToken = null;
    _userName = null;
    _userSurname = null;
    _userTcNo = null;
    _currentSessionId = null;

    await AnalyticsService().endSession(reason);
    _controller.add(UserLoginStatus.offline);
    _inactivityStopSafe();
    TimeoutCancelContextService().clear();
    NavigationService.ns.gotoMain();
  }

  Future<void> _tryCancelPatientTransactionOnTimeout() async {
    final snapshot = TimeoutCancelContextService().snapshot;

    if (snapshot == null || !snapshot.canCancelOnTimeout) {
      MyLog.debug("Timeout cancel skipped: no eligible context");
      return;
    }

    final patientId = snapshot.patientId;
    if (patientId == null || patientId.isEmpty) {
      MyLog.debug("Timeout cancel skipped: missing patientId");
      return;
    }

    SentryService().addBreadcrumb(
      message: 'Timeout cancel istegi denendi',
      category: 'auth',
      data: {
        'patient_id': patientId,
        'updated_at': snapshot.updatedAt.toIso8601String(),
      },
    );

    try {
      await PatientRegistrationProceduresService(UserHttpService())
          .postPatientTransactionCancel(patientId)
          .timeout(const Duration(seconds: 2));

      SentryService().addBreadcrumb(
        message: 'Timeout cancel istegi basarili',
        category: 'auth',
        data: {'patient_id': patientId},
      );
      MyLog.debug("Timeout cancel succeeded for patientId: $patientId");
    } catch (e) {
      SentryService().addBreadcrumb(
        message: 'Timeout cancel istegi basarisiz',
        category: 'auth',
        data: {'patient_id': patientId, 'error': e.toString()},
      );
      MyLog.debug("Timeout cancel failed: $e");
    }
  }

  void _inactivityStartSafe() {
    final ctx = NavigationService.ns.navigatorKey.currentContext;
    if (ctx == null) return;
    try {
      ctx.read<InactivityController>().start();
      MyLog.debug("InactivityController.start() called");
    } catch (e) {
      MyLog.debug("Inactivity start failed: $e");
    }
  }

  void _inactivityStopSafe() {
    final ctx = NavigationService.ns.navigatorKey.currentContext;
    if (ctx == null) return;
    try {
      ctx.read<InactivityController>().stop();
      MyLog.debug("InactivityController.stop() called");
    } catch (e) {
      MyLog.debug("Inactivity stop failed: $e");
    }
  }
}
