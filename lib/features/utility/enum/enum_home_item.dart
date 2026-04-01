import 'package:flutter/material.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';
import 'package:iconify_flutter/icons/mdi.dart';
import 'package:kiosk/features/utility/navigation_service.dart';

import '../../../product/appointments/view/appointments_view.dart';
import '../../../product/home/view/widget/results_button_widget.dart';
import '../../../product/home/view/widget/section_button_widget.dart';
import '../../../product/questionnaire/view/questionnaire_view.dart';
import '../const/constant_string.dart';
import '../extension/color_extension.dart';

enum EnumHomeItem {
  appointments,
  registration,
  results,
  // patientTransactionManagment,
  qr;

  String get label {
    switch (this) {
      case EnumHomeItem.appointments:
        return ConstantString().appointmentRegistration;
      case EnumHomeItem.registration:
        return ConstantString().registration;
      case EnumHomeItem.results:
        return ConstantString().medicalResults;
      case EnumHomeItem.qr:
        return ConstantString().survey;
      // case EnumHomeItem.patientTransactionManagment:
      //   return ConstantString().arrivalOpening;
    }
  }

  Widget icon(BuildContext context) {
    switch (this) {
      case EnumHomeItem.appointments:
        return Iconify(
          MaterialSymbols.calendar_month_outline_rounded,
          color: context.primaryColor,
        );
      case EnumHomeItem.registration:
        return Iconify(
          MaterialSymbols.holiday_village_rounded,
          color: context.primaryColor,
        );
      case EnumHomeItem.results:
        return Iconify(
          MaterialSymbols.medication_liquid_outline_rounded,
          color: context.primaryColor,
        );
      case EnumHomeItem.qr:
        return Iconify(Mdi.clipboard_list, color: context.primaryColor);
      // case EnumHomeItem.patientTransactionManagment:
      //   return Iconify(Mdi.account_check, color: context.primaryColor);
    }
  }

  Widget? get trailing {
    switch (this) {
      case EnumHomeItem.appointments:
        return OutlinedButton(
          onPressed: () {
            NavigationService.ns.routeTo("SectionSearchView");
          },
          child: Text(ConstantString().takeAppointment),
        );
      default:
        return null;
    }
  }

  Widget widget() {
    switch (this) {
      case EnumHomeItem.appointments:
        return AppointmentsView();
      case EnumHomeItem.registration:
        return SectionButtonWidget();
      case EnumHomeItem.results:
        return ResultsButtonWidget();
      case EnumHomeItem.qr:
        return QuestionnaireView();
      // case EnumHomeItem.patientTransactionManagment:
      //   return PatientTransactionManagmentButton();
    }
  }
}
