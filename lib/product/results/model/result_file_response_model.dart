class ResultFileResponseModel {
  String? pdfFilePath;

  ResultFileResponseModel({this.pdfFilePath});

  ResultFileResponseModel.fromJson(Map<String, dynamic> json) {
    pdfFilePath = json['PdfFilePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PdfFilePath'] = pdfFilePath;
    return data;
  }
}
