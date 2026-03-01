import '../../../features/model/api_list_response_model.dart';
import '../../../features/model/api_response_model.dart';
import '../model/patient_transaction_model.dart';
import '../model/refund_otp_verify_request_model.dart';
import '../model/refund_send_otp_response_model.dart';
import '../../patient_transaction_management/service/IPatientTransactionManagementService.dart';

class PatientTransactionManagementService
    extends IPatientTransactionManagementService {
  PatientTransactionManagementService(super.http);

  @override
  Future<ApiListResponse<PatientTransactionModel>>
  getPatientTransactionList() async {
    return http.requestList<PatientTransactionModel>(
      requestFunction: () => http.get(patientTransactionListPath),
      fromJson: (json) => PatientTransactionModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<RefundSendOtpResponseModel>> postRefundSendOtp() async {
    return http.request<RefundSendOtpResponseModel>(
      requestFunction: () => http.post(refundSendOtpPath),
      fromJson: (json) =>
          RefundSendOtpResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<RefundSendOtpResponseModel>> postRefundOtpVerify(
    RefundOtpVerifyRequestModel requestModel,
  ) async {
    return http.request<RefundSendOtpResponseModel>(
      requestFunction: () => http.post(refundSendOtpPath),
      fromJson: (json) =>
          RefundSendOtpResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
