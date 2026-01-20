import 'package:flutter/material.dart';
import 'package:kiosk/features/utility/const/constant_string.dart';

import '../../../product/patient_registration_procedures/model/patient_registration_procedures_request_model.dart';
import '../../../product/doctor/view/doctors_view.dart';
import '../../../product/mandatory/model/mandatory_request_model.dart';
import '../../../product/mandatory/view/mandatory_view.dart';
import '../../../product/payment_screen/view/payment_view.dart';
import '../../../product/price_details/view/price_details_view.dart';
import '../../../product/section/view/section_view.dart';

enum EnumPatientRegistrationProcedures {
  section,
  doctor,
  // patientTransaction,
  mandatory,
  price,
  payment;

  String get label {
    switch (this) {
      case EnumPatientRegistrationProcedures.section:
        return ConstantString().sectionSelection;
      case EnumPatientRegistrationProcedures.doctor:
        return ConstantString().selectDoctor;
      // case EnumPatientRegistrationProcedures.patientTransaction:
      //   return ConstantString().patientTransaction;
      case EnumPatientRegistrationProcedures.mandatory:
        return ConstantString().mandatoryFields;
      case EnumPatientRegistrationProcedures.price:
        return ConstantString().priceInformation;
      case EnumPatientRegistrationProcedures.payment:
        return ConstantString().payment;
    }
  }

  bool get isGoBack {
    switch (this) {
      case EnumPatientRegistrationProcedures.price:
      case EnumPatientRegistrationProcedures.payment:
        return false;
      default:
        return true;
    }
  }

  Widget widget(PatientRegistrationProceduresModel model) {
    switch (this) {
      case EnumPatientRegistrationProcedures.section:
        return SectionSearchView();
      case EnumPatientRegistrationProcedures.doctor:
        return DoctorSearchView(sectionId: model.branchId ?? "0");
      // case EnumPatientRegistrationProcedures.patientTransaction:
      //   return PatientTransactionView();
      case EnumPatientRegistrationProcedures.mandatory:
        return MandatoryView(
          mandatoryRequestModel: MandatoryRequestModel(
            assocationId: model.assocationId,
          ),
        );
      case EnumPatientRegistrationProcedures.price:
        return PriceView(
          patientContent: model.patientContent,
          paymentContentList: model.paymentContentList ?? [],
        );
      case EnumPatientRegistrationProcedures.payment:
        return PaymentView(
          patientPriceDetailModel: model.patientPriceDetailModel!,
        );
    }
  }
}
