import '../../../features/model/patient_price_detail_model.dart';

class PatientRegistrationProceduresModel {
  String? doctorId;
  String? doctorName;
  String? departmentId;
  String? departmentName;
  String? branchId;
  String? branchName;
  String? appointmentId;
  String? assocationId;
  String? assocationName;
  String? gssAssocationId;
  String? patientId;
  String? patientTransactionId;
  PatientTransactionDetailsResponseModel? patientPriceDetailModel;
  List<PaymentContent>? paymentContentList;
  PatientContent? patientContent;
  PatientRegistrationProceduresModel({
    this.doctorId,
    this.doctorName,
    this.branchId,
    this.branchName,
    this.departmentId,
    this.departmentName,
    this.appointmentId,
    this.assocationId,
    this.assocationName,
    this.gssAssocationId,
    this.patientId,
    this.patientTransactionId,
    this.patientPriceDetailModel,
    this.paymentContentList,
    this.patientContent,
  });
}
