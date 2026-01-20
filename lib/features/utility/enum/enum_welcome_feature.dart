import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:kiosk/features/utility/const/constant_string.dart';

enum WelcomeFeature {
  patientRegistration,
  takeAppointment,
  registerPatientForAppointment,
  // viewTestResults,
}

extension WelcomeFeatureExt on WelcomeFeature {
  /// Human readable label (Turkish) for each feature. Change or localize as needed.
  String get label {
    switch (this) {
      case WelcomeFeature.patientRegistration:
        return ConstantString().patientRegistration;
      case WelcomeFeature.takeAppointment:
        return ConstantString().takeAppointment;
      case WelcomeFeature.registerPatientForAppointment:
        return ConstantString().registerPatientForAppointment;
      // case WelcomeFeature.viewTestResults:
      //   return ConstantString().viewTestResults;
    }
  }

  Widget icon(Color color) {
    switch (this) {
      case WelcomeFeature.patientRegistration:
        return Iconify(
          MaterialSymbols.holiday_village_rounded,
          color: color,
          size: 40,
        );
      case WelcomeFeature.takeAppointment:
        return Iconify(
          MaterialSymbols.calendar_month_outline_rounded,
          color: color,
          size: 40,
        );
      case WelcomeFeature.registerPatientForAppointment:
        return Iconify(
          MaterialSymbols.air_purifier_gen_outline,
          color: color,
          size: 40,
        );
      // case WelcomeFeature.viewTestResults:
      //   return Iconify(MaterialSymbols.list, color: color, size: 40);
    }
  }

  /// A fixed position expressed as percentages of the full screen size.
  /// The Offset values are in the range 0..1 where
  /// - dx = horizontal position (0 = left, 1 = right)
  /// - dy = vertical position (0 = top, 1 = bottom)
  /// These are used by the welcome screen to place each feature at a
  /// deterministic location instead of moving them dynamically.
  Offset get positionPercent {
    switch (this) {
      case WelcomeFeature.patientRegistration:
        return const Offset(0.22, 0.35);
      case WelcomeFeature.takeAppointment:
        return const Offset(0.78, 0.30);
      case WelcomeFeature.registerPatientForAppointment:
        return const Offset(0.25, 0.75);
      // case WelcomeFeature.viewTestResults:
      //   return const Offset(0.75, 0.75);
    }
  }

  /// Optional: provide a short id string if needed.
  String get id => toString().split('.').last;
}
