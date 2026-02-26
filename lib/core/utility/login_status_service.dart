import 'dart:async';

import 'package:pratik_pos_integration/pratik_pos_integration.dart';

import '../../features/utility/navigation_service.dart';
import 'sentry_service.dart';

enum LoginStatus { online, offline }

class LoginStatusService {
  /// Singleton instance
  static LoginStatusService? _instance;

  final StreamController<LoginStatus> _controller =
      StreamController<LoginStatus>.broadcast();

  /// Private constructor
  LoginStatusService._internal() {
    _loadInitialStatus();
  }

  String? _accessToken;
  String? _refreshToken;

  Stream<LoginStatus> get statusStream => _controller.stream;

  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  Future<void> _loadInitialStatus() async {
    _controller.add(
      _accessToken == null ? LoginStatus.offline : LoginStatus.online,
    );
  }

  /// Singleton erişimi (ilk seferde cubit verilebilir)
  factory LoginStatusService() {
    return _instance ??= LoginStatusService._internal();
  }

  Future<void> saveToken({
    required String accessToken,
    required String refreshToken,
  }) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  Future<void> login() async {
    if (_accessToken is String && _refreshToken is String) {
      _controller.add(LoginStatus.online);
    }
  }

  refreshTokens({required String accessToken, required String refreshToken}) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
  }

  Future<void> logout() async {
    // ✅ Sentry hastane context'ini temizle
    SentryService().addBreadcrumb(
      message: 'Hastane çıkış yaptı',
      category: 'auth',
    );
    SentryService().clearHospitalContext();
    
    _accessToken = null;
    _refreshToken = null;
    _controller.add(LoginStatus.offline);
    PosService.instance.clearConfig();
    NavigationService.ns.gotoMain();
  }
}
