import '../../../core/utility/http_service.dart';
import '../../../features/model/api_list_response_model.dart';
import '../../../features/model/api_response_model.dart';
import '../model/patient_transaction_model.dart';
import '../model/refund_otp_verify_request_model.dart';
import '../model/refund_send_otp_response_model.dart';

abstract class IPatientTransactionManagementService {
  final IHttpService http;

  IPatientTransactionManagementService(this.http);

  final String patientTransactionListPath =
      IPatientTransactionManagementServicePath
          .patientTransactionList
          .rawValue;
  final String refundSendOtpPath =
      IPatientTransactionManagementServicePath.refundSendOtp.rawValue;
  final String refundOtpVerifyPath =
      IPatientTransactionManagementServicePath.refundOtpVerify.rawValue;

  Future<ApiListResponse<PatientTransactionModel>>
  getPatientTransactionList();
  Future<ApiResponse<RefundSendOtpResponseModel>> postRefundSendOtp();
  Future<ApiResponse<RefundSendOtpResponseModel>> postRefundOtpVerify(
    RefundOtpVerifyRequestModel requestModel,
  );
}

enum IPatientTransactionManagementServicePath {
  patientTransactionList,
  refundSendOtp,
  refundOtpVerify,
}

//BaseUrl'nin sonuna Search sayfasının requesti için gelecek olan eklenti için oluşturuldu
extension IPatientTransactionManagementServicePathExtension
    on IPatientTransactionManagementServicePath {
  String get rawValue {
    switch (this) {
      case IPatientTransactionManagementServicePath.patientTransactionList:
        return '/patient-transaction/todays-processes';
      case IPatientTransactionManagementServicePath.refundSendOtp:
        return "/pos/cancel-sms-sent";
      case IPatientTransactionManagementServicePath.refundOtpVerify:
        return "/pos/verify-cancel-code";
    }
  }
}
