import '../../../features/model/patient_mandatory_model.dart';

class PatientTransactionCreateRequestModel {
  String? doctorId;
  String? doctorName;
  String? departmentId;
  String? departmentName;
  String? branchId;
  String? branchName;
  String? associationId;
  String? associationName;
  String? appointmentId;
  List<PatientMandatoryModel>? mandatoryFields;

  PatientTransactionCreateRequestModel({
    this.doctorId,
    this.doctorName,
    this.departmentId,
    this.departmentName,
    this.branchId,
    this.branchName,
    this.associationId,
    this.associationName,
    this.appointmentId,
    this.mandatoryFields,
  });

  PatientTransactionCreateRequestModel.fromJson(Map<String, dynamic> json) {
    doctorId = json['doctorId'];
    doctorName = json['doctorName'];
    departmentId = json['departmentId'];
    departmentName = json['departmentName'];
    branchId = json['branchId'];
    branchName = json['branchName'];  
    associationId = json['associationId'];
    associationName = json['associationName'];
    appointmentId = json['appointmentId'];
    if (json['mandatoryFields'] != null) {
      mandatoryFields = <PatientMandatoryModel>[];
      json['mandatoryFields'].forEach((v) {
        mandatoryFields!.add(PatientMandatoryModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['doctorId'] = doctorId;
    data['doctorName'] = doctorName;
    data['departmentId'] = departmentId;
    data['departmentName'] = departmentName;
    data['branchId'] = branchId;
    data['branchName'] = branchName;
    data['associationId'] = associationId;
    data['associationName'] = associationName;
    data['appointmentId'] = appointmentId;
    if (mandatoryFields != null) {
      data['mandatoryFields'] = mandatoryFields!
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}
