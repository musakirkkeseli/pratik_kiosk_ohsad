class AssocationModel {
  String? assocationId;
  String? assocationName;
  String? mainAssocationId;
  String? mainAssocationName;
  String? gssAssocationId;
  String? gssAssocationName;

  AssocationModel({
    this.assocationId,
    this.assocationName,
    this.mainAssocationId,
    this.mainAssocationName,
    this.gssAssocationId,
    this.gssAssocationName,
  });

  AssocationModel.fromJson(Map<String, dynamic> json) {
    assocationId = json['AssocationId'];
    assocationName = json['AssocationName'];
    mainAssocationId = json['MainAssocationId'];
    mainAssocationName = json['MainAssocationName'];
    gssAssocationId = json['GssAssocationId'];
    gssAssocationName = json['GssAssocationName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['AssocationId'] = assocationId;
    data['AssocationName'] = assocationName;
    data['MainAssocationId'] = mainAssocationId;
    data['MainAssocationName'] = mainAssocationName;
    data['GssAssocationId'] = gssAssocationId;
    data['GssAssocationName'] = gssAssocationName;
    return data;
  }
}
