import '../../../features/utility/enum/enum_query_process_type.dart';
import '../../appointments/model/appointments_model.dart';

class QueryProcessResponseModel {
  EnumQueryProcessType? type;
  AppointmentsModel? appointment;
  Transaction? transaction;

  QueryProcessResponseModel({this.type, this.appointment, this.transaction});

  QueryProcessResponseModel.fromJson(Map<String, dynamic> json) {
    type = EnumQueryProcessType.fromString(json['type']);
    appointment = json['appointment'] != null
        ? AppointmentsModel.fromJson(json['appointment'])
        : null;
    transaction = json['transaction'] != null
        ? Transaction.fromJson(json['transaction'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type?.toValue();
    if (appointment != null) {
      data['appointment'] = appointment!.toJson();
    }
    if (transaction != null) {
      data['transaction'] = transaction!.toJson();
    }
    return data;
  }
}

class Transaction {
  String? uPN;
  String? patientName;
  String? ptId;
  String? protId;
  String? doctorName;
  String? branchId;
  String? branchName;
  String? departmentName;
  String? ctime;
  String? doctorId;
  String? departmentId;

  Transaction({
    this.uPN,
    this.patientName,
    this.ptId,
    this.protId,
    this.doctorName,
    this.branchId,
    this.branchName,
    this.departmentName,
    this.ctime,
    this.doctorId,
    this.departmentId,
  });

  Transaction.fromJson(Map<String, dynamic> json) {
    uPN = json['UPN'];
    patientName = json['PatientName'];
    ptId = json['PtId'];
    protId = json['ProtId'];
    doctorName = json['DoctorName'];
    branchId = json['BranchId'];
    branchName = json['BranchName'];
    departmentName = json['DepartmentName'];
    ctime = json['Ctime'];
    doctorId = json['DoctorId'];
    departmentId = json['DepartmentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['UPN'] = uPN;
    data['PatientName'] = patientName;
    data['PtId'] = ptId;
    data['ProtId'] = protId;
    data['DoctorName'] = doctorName;
    data['BranchId'] = branchId;
    data['BranchName'] = branchName;
    data['DepartmentName'] = departmentName;
    data['Ctime'] = ctime;
    data['DoctorId'] = doctorId;
    data['DepartmentId'] = departmentId;
    return data;
  }
}
