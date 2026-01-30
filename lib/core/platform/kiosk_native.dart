import 'package:flutter/services.dart';

class KioskNative {
  static const _ch = MethodChannel('kiosk_channel');

  static Future<bool> isDeviceOwner() async =>
      (await _ch.invokeMethod<bool>('isDeviceOwner')) ?? false;

  static Future<bool> startKiosk() async =>
      (await _ch.invokeMethod<bool>('startKiosk')) ?? false;

  static Future<bool> stopKiosk() async =>
      (await _ch.invokeMethod<bool>('stopKiosk')) ?? false;
}