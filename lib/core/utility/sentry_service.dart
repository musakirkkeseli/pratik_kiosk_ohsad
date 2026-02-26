import 'package:flutter/foundation.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../features/utility/const/environment.dart';
import 'device_info_service.dart';
import 'logger_service.dart';

/// Sentry entegrasyon servisi
/// Hastane bazlı kiosk cihazları için detaylı hata takibi sağlar
class SentryService {
  SentryService._internal();
  static final SentryService _instance = SentryService._internal();
  factory SentryService() => _instance;

  final MyLog _log = MyLog('SentryService');

  bool _isInitialized = false;

  // Kiosk bilgileri (hospital login sonrası set edilecek)
  String? _hospitalName;
  String? _kioskDeviceId;

  /// Sentry'yi başlatır
  Future<void> init() async {
    if (_isInitialized) return;

    final dsn = Environment.sentryDsn;
    if (dsn.isEmpty) {
      _log.w('Sentry DSN boş, Sentry devre dışı.');
      return;
    }

    try {
      await SentryFlutter.init(
        (options) async {
          options.dsn = dsn;

          // Environment ayarları
          options.environment = kDebugMode ? 'debug' : 'production';

          // Trace sampling - production'da %10, debug'da %100
          options.tracesSampleRate = kDebugMode ? 1.0 : 0.1;

          // Profiling sampling - production'da %10
          options.profilesSampleRate = kDebugMode ? 1.0 : 0.1;

          // Otomatik breadcrumb'lar
          options.enableAutoSessionTracking = true;
          // Session tracking interval (deprecated, artık gerekli değil)

          // Debug modunda log
          options.debug = kDebugMode;

          // App hang tracking (UI donması tespiti)
          options.enableAppHangTracking = true;
          options.appHangTimeoutInterval = const Duration(seconds: 5);

          // Release bilgisi
          final packageInfo = await PackageInfo.fromPlatform();
          options.release = '${packageInfo.version}+${packageInfo.buildNumber}';
          options.dist = packageInfo.buildNumber;

          // Cihaz bilgilerini context olarak ekle
          await _setInitialDeviceContext();

          // HTTP client hataları
          options.captureFailedRequests = true;

          // PII (Personally Identifiable Information) - Dikkatli kullan
          options.sendDefaultPii = false; // GDPR uyumluluğu için kapalı

          // Before send callback - hassas verileri temizle
          options.beforeSend = (event, hint) {
            // Debug modunda her şeyi gönder
            if (kDebugMode) return event;

            // Production'da hassas verileri temizle
            return _sanitizeEvent(event);
          };
        },
      );

      _isInitialized = true;
      _log.i('Sentry başarıyla başlatıldı');
    } catch (e, st) {
      _log.e('Sentry başlatma hatası', e, st);
    }
  }

  /// Cihaz bilgilerini Sentry context'ine ekler
  Future<void> _setInitialDeviceContext() async {
    try {
      final deviceInfo = await DeviceInfoService().getDeviceInfo();

      Sentry.configureScope((scope) {
        // Cihaz bilgileri
        scope.setContexts('device', {
          'device_id': deviceInfo['deviceId'] ?? 'unknown',
          'model': deviceInfo['deviceModel'] ?? 'unknown',
          'os_version': deviceInfo['osVersion'] ?? 'unknown',
          'platform': deviceInfo['platform'] ?? 'unknown',
        });

        // Tags - filtreleme için kullanışlı
        scope.setTag('device_model', deviceInfo['deviceModel'] ?? 'unknown');
        scope.setTag('os_version', deviceInfo['osVersion'] ?? 'unknown');
      });
    } catch (e) {
      _log.e('Cihaz bilgileri Sentry\'ye eklenirken hata: $e');
    }
  }

  /// Hastane giriş yaptıktan sonra hastane bilgilerini set et
  void setHospitalContext({
    required String hospitalName,
    String? hospitalId,
    required String kioskDeviceId,
  }) {
    _hospitalName = hospitalName;
    _kioskDeviceId = kioskDeviceId;

    Sentry.configureScope((scope) {
      // User - Hastane bilgisi (hasta değil, hastane!)
      scope.setUser(SentryUser(
        id: hospitalId,
        username: hospitalName,
        data: {
          'kiosk_device_id': kioskDeviceId,
          'type': 'hospital_kiosk',
        },
      ));

      // Tags - Dashboard'da filtreleme için
      scope.setTag('hospital_name', hospitalName);
      if (hospitalId != null) {
        scope.setTag('hospital_id', hospitalId);
      }
      scope.setTag('kiosk_device_id', kioskDeviceId);
      scope.setTag('kiosk_type', 'hospital');

      // Context - Ek bilgiler
      scope.setContexts('hospital', {
        'name': hospitalName,
        'id': hospitalId ?? 'unknown',
        'kiosk_device_id': kioskDeviceId,
        'login_time': DateTime.now().toIso8601String(),
      });
    });

    _log.i('Sentry: Hastane context set edildi - $hospitalName ($kioskDeviceId)');
  }

  /// Hasta giriş yaptığında hasta bilgilerini ekle (opsiyonel)
  /// Not: Hasta TC kimlik gibi hassas bilgiler GÖNDERİLMEMELİ!
  void setPatientContext({
    String? patientId, // Anonim ID kullan, TC kimlik NO!
    String? sessionId,
  }) {
    Sentry.configureScope((scope) {
      // Breadcrumb olarak ekle
      scope.addBreadcrumb(Breadcrumb(
        message: 'Hasta giriş yaptı',
        category: 'patient',
        level: SentryLevel.info,
        data: {
          'patient_id': patientId ?? 'unknown',
          'session_id': sessionId ?? 'unknown',
          'timestamp': DateTime.now().toIso8601String(),
        },
      ));

      // Tag olarak session ekle
      if (sessionId != null) {
        scope.setTag('patient_session', sessionId);
      }

      // Context
      scope.setContexts('patient_session', {
        'patient_id': patientId ?? 'unknown',
        'session_id': sessionId ?? 'unknown',
        'login_time': DateTime.now().toIso8601String(),
      });
    });
  }

  /// Hasta çıkış yaptığında session'ı temizle
  void clearPatientContext() {
    Sentry.configureScope((scope) {
      scope.removeTag('patient_session');
      scope.removeContexts('patient_session');

      scope.addBreadcrumb(Breadcrumb(
        message: 'Hasta çıkış yaptı',
        category: 'patient',
        level: SentryLevel.info,
      ));
    });
  }

  /// Hastane çıkış yaptığında context'i temizle
  void clearHospitalContext() {
    _hospitalName = null;
    _kioskDeviceId = null;

    Sentry.configureScope((scope) {
      scope.setUser(null);
      scope.removeTag('hospital_name');
      scope.removeTag('hospital_id');
      scope.removeTag('kiosk_device_id');
      scope.removeTag('patient_session');
      scope.removeContexts('hospital');
      scope.removeContexts('patient_session');
    });

    _log.i('Sentry: Hastane context temizlendi');
  }

  /// Özel event logla
  void logEvent(
    String message, {
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? extra,
    String? tag,
  }) {
    if (!_isInitialized) return;

    Sentry.captureMessage(
      message,
      level: level,
      withScope: (scope) {
        if (tag != null) {
          scope.setTag('custom_tag', tag);
        }
        if (extra != null) {
          extra.forEach((key, value) {
            scope.setExtra(key, value);
          });
        }
      },
    );
  }

  /// Exception logla
  void logException(
    dynamic exception,
    StackTrace? stackTrace, {
    Map<String, dynamic>? extra,
    String? tag,
    SentryLevel level = SentryLevel.error,
  }) {
    if (!_isInitialized) return;

    Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: (scope) {
        scope.level = level;

        if (tag != null) {
          scope.setTag('error_tag', tag);
        }
        if (extra != null) {
          // setContext kullan (setExtra deprecated)
          scope.setContexts('error_extra', extra);
        }

        // Kiosk bilgilerini context olarak ekle
        if (_hospitalName != null || _kioskDeviceId != null) {
          scope.setContexts('error_context', {
            if (_hospitalName != null) 'current_hospital': _hospitalName!,
            if (_kioskDeviceId != null) 'current_kiosk_device': _kioskDeviceId!,
          });
        }
      },
    );
  }

  /// Breadcrumb ekle (kullanıcı etkileşim izleme)
  void addBreadcrumb({
    required String message,
    String? category,
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? data,
  }) {
    if (!_isInitialized) return;

    Sentry.addBreadcrumb(Breadcrumb(
      message: message,
      category: category ?? 'default',
      level: level,
      data: data,
      timestamp: DateTime.now(),
    ));
  }

  /// Transaction başlat (performance monitoring)
  ISentrySpan? startTransaction(
    String name,
    String operation, {
    Map<String, dynamic>? data,
  }) {
    if (!_isInitialized) return null;

    final transaction = Sentry.startTransaction(
      name,
      operation,
      bindToScope: true,
    );

    if (data != null) {
      data.forEach((key, value) {
        transaction.setData(key, value);
      });
    }

    return transaction;
  }

  /// Hassas verileri event'ten temizle
  SentryEvent _sanitizeEvent(SentryEvent event) {
    // Request body'den hassas alanları kaldır
    if (event.request?.data != null) {
      final data = event.request!.data;
      if (data is Map) {
        // TC kimlik, şifre gibi hassas alanları kaldır
        data.remove('password');
        data.remove('tc_kimlik');
        data.remove('identityNumber');
        data.remove('creditCard');
        data.remove('cvv');
      }
    }

    return event;
  }

  /// Getter'lar
  bool get isInitialized => _isInitialized;
  String? get currentHospital => _hospitalName;
  String? get currentKioskDevice => _kioskDeviceId;
}
