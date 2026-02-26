import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:kiosk/core/utility/logger_service.dart';
import 'package:kiosk/core/utility/sentry_service.dart';

/// Sentry entegrasyonunu test etmek için basit script
void main() async {
  MyLog('🔍 Sentry Test Başlatılıyor...\n');

  // .env dosyasını yükle
  await dotenv.load(fileName: '.env');

  // Sentry DSN kontrolü
  final dsn = dotenv.env['SENTRY_DSN'] ?? '';
  if (dsn.isEmpty) {
    MyLog('❌ HATA: SENTRY_DSN bulunamadı!');
    return;
  }

  MyLog('✅ SENTRY_DSN bulundu');
  MyLog('📍 DSN: ${dsn.substring(0, 30)}...\n');

  // Sentry servisi başlat
  try {
    await SentryService().init();
    MyLog('✅ Sentry başarıyla başlatıldı!\n');

    // Test event gönder
    MyLog('📤 Test event gönderiliyor...');
    SentryService().logEvent(
      'Sentry Test Event - Kiosk Projesi',
      extra: {
        'test_time': DateTime.now().toIso8601String(),
        'source': 'test_sentry.dart',
      },
    );

    MyLog('✅ Test event gönderildi!\n');
    MyLog('🎉 Sentry entegrasyonu çalışıyor!');
    MyLog('👉 Sentry dashboard\'ınızı kontrol edin: https://sentry.io');
  } catch (e) {
    MyLog('❌ HATA: $e');
  }
}
