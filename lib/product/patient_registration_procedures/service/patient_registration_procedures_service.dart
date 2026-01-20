import '../../../features/model/api_list_response_model.dart';
import '../../../features/model/api_response_model.dart';
import '../../../features/model/empty_response.dart';
import '../../../features/model/patient_price_detail_model.dart';
import '../../appointments/model/appointments_model.dart';
import '../model/association_model.dart';
import '../model/patient_transaction_create_request_model.dart';
import '../model/patient_transaction_create_response_model.dart';
import '../model/patient_transaction_revenue_response_model.dart';
import 'IPatientRegistrationProceduresService.dart';

class PatientRegistrationProceduresService
    extends IPatientRegistrationProceduresService {
  PatientRegistrationProceduresService(super.http);

  @override
  Future<ApiListResponse<AssocationModel>> getAssociationList(
    String branchId,
  ) async {
    return http.requestList<AssocationModel>(
      requestFunction: () =>
          http.get("$associationListPath?branchId=$branchId"),
      fromJson: (json) => AssocationModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<PatientTransactionCreateResponseModel>>
  postPatientTransactionCreate(
    PatientTransactionCreateRequestModel request,
  ) async {
    return http.request<PatientTransactionCreateResponseModel>(
      requestFunction: () =>
          http.post(patientTransactionCreatePath, data: request.toJson()),
      fromJson: (json) => PatientTransactionCreateResponseModel.fromJson(
        json as Map<String, dynamic>,
      ),
    );
  }

  @override
  Future<ApiResponse<PatientTransactionRevenueResponseModel>>
  postPatientTransactionRevenue(
    PatientTransactionDetailsResponseModel request,
  ) async {
    return http.request<PatientTransactionRevenueResponseModel>(
      requestFunction: () =>
          http.post(patientTransactionRevenuePath, data: request.toJson()),
      fromJson: (json) => PatientTransactionRevenueResponseModel.fromJson(
        json as Map<String, dynamic>,
      ),
    );
  }

  @override
  Future<ApiResponse<EmptyResponse>> postPatientTransactionCancel(
    String patientId,
  ) async {
    return http.request<EmptyResponse>(
      requestFunction: () => http.post(
        patientTransactionCancelPath,
        data: {"patientId": patientId},
      ),
      fromJson: (json) => EmptyResponse.fromJson(json as Map<String, dynamic>),
    );
  }

  @override
  Future<ApiResponse<PatientTransactionDetailsResponseModel>>
  postPatientTransactionDetails(String patientId) async {
    return http.request<PatientTransactionDetailsResponseModel>(
      requestFunction: () => http.post(
        patientTransactionDetailsPath,
        data: {'PatientID': patientId},
      ),
      fromJson: (json) => PatientTransactionDetailsResponseModel.fromJson(
        json as Map<String, dynamic>,
      ),
    );
  }

  @override
  Future<ApiResponse<AppointmentsModel>> postAppointmentByBranch(
    String branchId,
  ) async {
    return http.request<AppointmentsModel>(
      requestFunction: () =>
          http.post(appointmentByBranchPath, data: {"branchId": branchId}),
      fromJson: (json) =>
          AppointmentsModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
