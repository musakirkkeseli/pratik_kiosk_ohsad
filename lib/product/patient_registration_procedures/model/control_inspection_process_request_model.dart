class ControlInspectionProcessRequestModel {
  String? ptId;
  String? appointmentId;

  ControlInspectionProcessRequestModel({this.ptId, this.appointmentId});

  ControlInspectionProcessRequestModel.fromJson(Map<String, dynamic> json) {
    ptId = json['ptId'];
    appointmentId = json['appointmentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ptId'] = ptId;
    data['appointmentId'] = appointmentId;
    return data;
  }
}
