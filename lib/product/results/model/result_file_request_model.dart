class ResultFileRequestModel {
  String? reportGUID;

  ResultFileRequestModel({this.reportGUID});

  ResultFileRequestModel.fromJson(Map<String, dynamic> json) {
    reportGUID = json['ReportGUID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ReportGUID'] = reportGUID;
    return data;
  }
}
