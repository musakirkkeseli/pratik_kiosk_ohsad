import '../../../../features/model/api_list_response_model.dart';
import '../../../../features/model/api_response_model.dart';

import '../model/patient_login_request_model.dart';
import '../model/patient_register_request_model.dart';
import '../model/patient_response_model.dart';
import '../model/patient_send_login_otp_response_model.dart';
import '../model/patient_validate_identity_response_model.dart';
import '../model/slider_model.dart';
import 'IPatientServices.dart';

class PatientServices extends IPatientServices {
  PatientServices(super.http);

  @override
  Future<ApiResponse<PatientResponseModel>> postDirectLogin(
    String tcNo,
  ) {
    return http.request<PatientResponseModel>(
      requestFunction: () =>
          http.post(directLoginPath, data: {'tcNo': tcNo}),
      fromJson: (json) =>
          PatientResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<PatientResponseModel>> postUserLogin(
    PatientLoginRequestModel patientLoginRequestModel,
  ) {
    return http.request<PatientResponseModel>(
      requestFunction: () =>
          http.post(userLoginPath, data: patientLoginRequestModel.toJson()),
      fromJson: (json) =>
          PatientResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<PatientResponseModel>> postUserRegister(
    PatientRegisterRequestModel patientRegisterRequestModel,
  ) {
    return http.request<PatientResponseModel>(
      requestFunction: () => http.post(
        userRegisterPath,
        data: patientRegisterRequestModel.toJson(),
      ),
      fromJson: (json) =>
          PatientResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<PatientValidateIdentityResponseModel>>
  postValidateIdentify(String tcNo) {
    return http.request<PatientValidateIdentityResponseModel>(
      requestFunction: () =>
          http.post(validateIdentityPath, data: {'tcNo': tcNo}),
      fromJson: (json) => PatientValidateIdentityResponseModel.fromJson(
        json as Map<String, dynamic>,
      ),
    );
  }

  @override
  Future<ApiResponse<PatientSendLoginOtpResponseModel>> postSendLoginOtp(
    String encryptedUserData,
  ) {
    return http.request<PatientSendLoginOtpResponseModel>(
      requestFunction: () => http.post(
        sendOtpLoginPath,
        data: {'encryptedUserData': encryptedUserData},
      ),
      fromJson: (json) => PatientSendLoginOtpResponseModel.fromJson(
        json as Map<String, dynamic>,
      ),
    );
  }

  @override
  Future<ApiListResponse<SliderModel>> getSliders() async {
    return http.requestList<SliderModel>(
      requestFunction: () => http.get(slidersPath),
      fromJson: (json) => SliderModel.fromJson(json),
    );
  }
}
