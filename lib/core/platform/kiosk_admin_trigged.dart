import 'dart:async';
import 'package:flutter/material.dart';
import '../../features/utility/navigation_service.dart';
import '../widget/snackbar_service.dart';
import 'admin_pin_dialog.dart';
import 'kiosk_native.dart';

class KioskAdminTrigger extends StatefulWidget {
  const KioskAdminTrigger({
    super.key,
    required this.child,
    required this.correctPin,
  });

  final Widget? child;
  final String correctPin;

  @override
  State<KioskAdminTrigger> createState() => _KioskAdminTriggerState();
}

class _KioskAdminTriggerState extends State<KioskAdminTrigger> {
  int _tapCount = 0;
  Timer? _resetTimer;
  bool _busy = false;

  void _bump() {
    debugPrint("ADMIN TAP: ${_tapCount + 1}");

    // 2 sn içinde 7 tık olmazsa sıfırla
    _resetTimer?.cancel();
    _resetTimer = Timer(const Duration(seconds: 3), () {
      _tapCount = 0;
    });

    _tapCount++;
    if (_tapCount >= 7) {
      _tapCount = 0;
      _resetTimer?.cancel();
      _openAdmin();
    }
  }

  Future<void> _openAdmin() async {
    if (_busy) return;
    _busy = true;

    try {
      // ✅ Navigator context'i ile dialog aç
      final navCtx =
          NavigationService.ns.navigatorKey.currentContext ?? context;

      final ok = await showAdminPinDialog(
        context: navCtx,
        correctPin: widget.correctPin,
      );

      if (ok == true) {
        await KioskNative.stopKiosk();
        if (mounted) {
          SnackbarService().showSnackBar('Kiosk modu kapatıldı');
        }
      } else if (ok == false) {
        if (mounted) {
          SnackbarService().showSnackBar('PIN hatalı');
        }
      }
    } catch (e) {
      debugPrint("ADMIN DIALOG ERROR: $e");
    } finally {
      _busy = false;
    }
  }

  @override
  void dispose() {
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (widget.child != null) widget.child!,

        // 🔒 Gizli tıklama alanı (sol üst)
        // Logo senin UI’da başka yerdeyse burayı taşıyabiliriz.
        // Positioned(
        //   left: 0,
        //   top: MediaQuery.of(context).padding.top, // ✅ status bar altı
        //   width: 200, // ✅ test için büyüttük
        //   height: 160,
        //   child: GestureDetector(
        //     behavior: HitTestBehavior.opaque, // ✅ daha güvenli
        //     onTap: _bump,
        //     child: const SizedBox.expand(),
        //   ),
        // ),
      ],
    );
  }
}
