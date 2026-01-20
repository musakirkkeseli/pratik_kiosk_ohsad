class PatientTransactionRevenueResponseModel {
  String? totalPrice;
  List<Revenues>? revenues;

  PatientTransactionRevenueResponseModel({this.totalPrice, this.revenues});

  PatientTransactionRevenueResponseModel.fromJson(Map<String, dynamic> json) {
    totalPrice = json['totalPrice'];
    if (json['revenues'] != null) {
      revenues = <Revenues>[];
      json['revenues'].forEach((v) {
        revenues!.add(Revenues.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['totalPrice'] = totalPrice;
    if (revenues != null) {
      data['revenues'] = revenues!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Revenues {
  String? paymentName;
  String? price;
  bool? isContributionFee;
  Result? result;

  Revenues({this.paymentName, this.price, this.isContributionFee, this.result});

  Revenues.fromJson(Map<String, dynamic> json) {
    paymentName = json['paymentName'];
    price = json['price'];
    isContributionFee = json['isContributionFee'];
    result = json['result'] != null ? Result.fromJson(json['result']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['paymentName'] = paymentName;
    data['price'] = price;
    data['isContributionFee'] = isContributionFee;
    if (result != null) {
      data['result'] = result!.toJson();
    }
    return data;
  }
}

class Result {
  String? revenueID;

  Result({this.revenueID});

  Result.fromJson(Map<String, dynamic> json) {
    revenueID = json['RevenueID'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['RevenueID'] = revenueID;
    return data;
  }
}
