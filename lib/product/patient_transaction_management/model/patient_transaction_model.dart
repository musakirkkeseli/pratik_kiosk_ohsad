class PatientTransactionModel {
  int? patientId;
  int? patientProcessId;
  String? orderId;
  String? branchName;
  String? doctorName;
  String? date;
  String? time;
  int? totalAmount;
  List<Revenues>? revenues;

  PatientTransactionModel({
    this.patientId,
    this.patientProcessId,
    this.orderId,
    this.totalAmount,
    this.revenues,
  });

  PatientTransactionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    patientId = json['PatientId'];
    patientProcessId = json['PatientProcessId'];
    orderId = json['OrderId'];
    totalAmount = json['totalAmount'];
    if (json['Revenues'] != null) {
      revenues = <Revenues>[];
      json['Revenues'].forEach((v) {
        revenues!.add(Revenues.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PatientId'] = patientId;
    data['PatientProcessId'] = patientProcessId;
    data['OrderId'] = orderId;
    data['totalAmount'] = totalAmount;
    if (revenues != null) {
      data['Revenues'] = revenues!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Revenues {
  String? revenueId;
  String? processName;

  Revenues({this.revenueId, this.processName});

  Revenues.fromJson(Map<String, dynamic> json) {
    revenueId = json['RevenueId'];
    processName = json['ProcessName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RevenueId'] = revenueId;
    data['ProcessName'] = processName;
    return data;
  }
}
