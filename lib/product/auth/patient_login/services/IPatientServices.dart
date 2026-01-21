import '../../../../core/utility/http_service.dart';
import '../../../../features/model/api_list_response_model.dart';
import '../../../../features/model/api_response_model.dart';
import '../model/patient_login_request_model.dart';
import '../model/patient_register_request_model.dart';
import '../model/patient_response_model.dart';
import '../model/patient_send_login_otp_response_model.dart';
import '../model/patient_validate_identity_response_model.dart';
import '../model/slider_model.dart';

abstract class IPatientServices {
  final IHttpService http;

  IPatientServices(this.http);

  final String directLoginPath = IPatientServicesPath.directLogin.rawValue;
  final String userLoginPath = IPatientServicesPath.userLogin.rawValue;
  final String userRegisterPath = IPatientServicesPath.userRegister.rawValue;
  final String validateIdentityPath =
      IPatientServicesPath.validateIdentity.rawValue;
  final String sendOtpLoginPath = IPatientServicesPath.sendOtpLogin.rawValue;
  final String slidersPath = IPatientServicesPath.sliders.rawValue;

  Future<ApiResponse<PatientResponseModel>> postDirectLogin(String tcNo);
  Future<ApiResponse<PatientResponseModel>> postUserLogin(
    PatientLoginRequestModel patientLoginRequestModel,
  );
  Future<ApiResponse<PatientResponseModel>> postUserRegister(
    PatientRegisterRequestModel patientRegisterRequestModel,
  );
  Future<ApiResponse<PatientValidateIdentityResponseModel>>
  postValidateIdentify(String tc);
  Future<ApiResponse<PatientSendLoginOtpResponseModel>> postSendLoginOtp(
    String encryptedUserData,
  );
  Future<ApiListResponse<SliderModel>> getSliders();
}

enum IPatientServicesPath {
  directLogin,
  userLogin,
  userRegister,
  validateIdentity,
  sendOtpLogin,
  sliders,
}

extension IHospitalAndUserLoginServicesExtension on IPatientServicesPath {
  String get rawValue {
    final root = "/user-auth";
    switch (this) {
      case IPatientServicesPath.directLogin:
        return '$root/login';
      case IPatientServicesPath.userLogin:
        return '$root/loginVTwo';
      case IPatientServicesPath.userRegister:
        return '$root/register';
      case IPatientServicesPath.validateIdentity:
        return '$root/validate-identity';
      case IPatientServicesPath.sendOtpLogin:
        return '$root/send-login-otp';
      case IPatientServicesPath.sliders:
        return '/kiosk-device/sliders';
    }
  }
}
