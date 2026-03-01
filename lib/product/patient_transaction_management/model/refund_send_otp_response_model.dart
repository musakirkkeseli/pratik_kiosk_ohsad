class RefundSendOtpResponseModel {
  String? encryptedOtp;

  RefundSendOtpResponseModel({this.encryptedOtp});

  RefundSendOtpResponseModel.fromJson(Map<String, dynamic> json) {
    encryptedOtp = json['encryptedOtp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['encryptedOtp'] = encryptedOtp;
    return data;
  }
}
