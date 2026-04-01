import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'logger_service.dart';

class DeviceInfoService {
  static final DeviceInfoService _instance = DeviceInfoService._internal();
  factory DeviceInfoService() => _instance;
  DeviceInfoService._internal();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();
  final MyLog _log = MyLog('DeviceInfoService');

  String? _deviceId;
  String? _deviceModel;
  String? _osVersion;
  // final fakeDeviceId = 'BP1A.250505.005';
  final fakeDeviceId = 'TQ3C.230805.001.B2';
  // final fakeDeviceId = 'TKQ1.230110.001';
  // final fakeDeviceId = 'KIOSKPRIME';

  Future<String> getDeviceId() async {
    if (_deviceId != null) {
      return _deviceId!;
    }

    try {
      if (Platform.isAndroid && !kDebugMode) {
        final androidInfo = await _deviceInfo.androidInfo;
        // Android ID'yi kullan
        _deviceId = androidInfo.id;
        _deviceModel = androidInfo.model;
        _osVersion = androidInfo.version.release;
        _log.i('Android Device ID: $_deviceId');
        _log.i('Device Model: $_deviceModel');
        _log.i('OS Version: $_osVersion');
      } else {
        _deviceId = fakeDeviceId;
      }
    } catch (e) {
      _log.e('Error getting device ID: $e');
      // Hata durumunda fallback ID kullan
      _deviceId = 'error-device-${DateTime.now().millisecondsSinceEpoch}';
    }

    return _deviceId!;
  }

  /// Önceden alınmış device ID'yi döndürür (null olabilir)
  String? get cachedDeviceId => _deviceId;

  /// Cihaz modelini döndürür
  String? get deviceModel => _deviceModel;

  /// İşletim sistemi versiyonunu döndürür
  String? get osVersion => _osVersion;

  /// Tüm cihaz bilgilerini birlikte alır
  Future<Map<String, String>> getDeviceInfo() async {
    await getDeviceId();
    return {
      'deviceId': _deviceId ?? 'unknown',
      'deviceModel': _deviceModel ?? 'unknown',
      'osVersion': _osVersion ?? 'unknown',
      'platform': Platform.operatingSystem,
    };
  }

  /// Cache'i temizler (test için)
  void clearCache() {
    _deviceId = null;
    _deviceModel = null;
    _osVersion = null;
  }
}
