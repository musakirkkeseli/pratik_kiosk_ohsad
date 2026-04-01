class ResultsResponseModel {
  String? hospitalID;
  String? hospitalName;
  String? departmentID;
  String? departmentName;
  String? doctorID;
  String? doctorName;
  String? reportName;
  String? reportDate;
  String? reportStatus;
  String? reportGUID;
  String? reportObjectID;
  String? attachmentID;
  String? attachedFiles;

  ResultsResponseModel({
    this.hospitalID,
    this.hospitalName,
    this.departmentID,
    this.departmentName,
    this.doctorID,
    this.doctorName,
    this.reportName,
    this.reportDate,
    this.reportStatus,
    this.reportGUID,
    this.reportObjectID,
    this.attachmentID,
    this.attachedFiles,
  });

  ResultsResponseModel.fromJson(Map<String, dynamic> json) {
    hospitalID = json['HospitalID'];
    hospitalName = json['HospitalName'];
    departmentID = json['DepartmentID'];
    departmentName = json['DepartmentName'];
    doctorID = json['DoctorID'];
    doctorName = json['DoctorName'];
    reportName = json['ReportName'];
    reportDate = json['ReportDate'];
    reportStatus = json['ReportStatus'];
    reportGUID = json['ReportGUID'];
    reportObjectID = json['ReportObjectID'];
    attachmentID = json['AttachmentID'];
    attachedFiles = json['AttachedFiles'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['HospitalID'] = hospitalID;
    data['HospitalName'] = hospitalName;
    data['DepartmentID'] = departmentID;
    data['DepartmentName'] = departmentName;
    data['DoctorID'] = doctorID;
    data['DoctorName'] = doctorName;
    data['ReportName'] = reportName;
    data['ReportDate'] = reportDate;
    data['ReportStatus'] = reportStatus;
    data['ReportGUID'] = reportGUID;
    data['ReportObjectID'] = reportObjectID;
    data['AttachmentID'] = attachmentID;
    data['AttachedFiles'] = attachedFiles;
    return data;
  }
}
