class ResultsRequestModel {
  String? startDate;
  String? endDate;

  ResultsRequestModel({this.startDate, this.endDate});

  ResultsRequestModel.fromJson(Map<String, dynamic> json) {
    startDate = json['StartDate'];
    endDate = json['EndDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['StartDate'] = startDate;
    data['EndDate'] = endDate;
    return data;
  }
}
