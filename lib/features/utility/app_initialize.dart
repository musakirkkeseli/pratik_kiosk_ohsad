import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:pratik_pos_integration/pratik_pos_integration.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import '../../core/utility/analytics_service.dart';
import '../../core/utility/sentry_service.dart';
import 'const/environment.dart';

final class AppInitialize {
  AppInitialize._();

  static Future<void> initialize() async {
    SentryWidgetsFlutterBinding.ensureInitialized();

    //uygulamada yaşanacak beklenmedik büyük hatalarda ekrana AppErrorWidget widgeti gösterilir
    // ErrorWidget.builder = (FlutterErrorDetails details) {
    //   return CustomErrorWidget();
    // };

    final _ = PosService.instance;
    // final MyLog _log = MyLog('AppInitialize');

    await dotenv.load(fileName: Environment.fileName);

    // Sentry'yi başlat
    await SentryService().init();

    await AnalyticsService().init();

    // // final isOwner1 = await KioskNative.isDeviceOwner();
    // // final started = await KioskNative.startKiosk();
    // // debugPrint("KIOSK isOwner=$isOwner1 started=$started");

    // try {
    //   if (Platform.isAndroid) {
    //     final isOwner = await KioskNative.isDeviceOwner();
    //     if (isOwner) {
    //       await KioskNative.startKiosk();
    //     }
    //   }
    // } catch (e) {
    //   _log.e('Error getting device ID: $e');
    // }
  }
}
