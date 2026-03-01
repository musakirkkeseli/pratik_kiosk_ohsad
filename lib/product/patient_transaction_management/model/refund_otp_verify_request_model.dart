class RefundOtpVerifyRequestModel {
  String? encryptedOtp;
  String? code;

  RefundOtpVerifyRequestModel({this.encryptedOtp, this.code});

  RefundOtpVerifyRequestModel.fromJson(Map<String, dynamic> json) {
    encryptedOtp = json['encryptedOtp'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['encryptedOtp'] = encryptedOtp;
    data['code'] = code;
    return data;
  }
}
