import '../../../core/utility/http_service.dart';
import '../../../features/model/api_list_response_model.dart';
import '../../../features/model/api_response_model.dart';
import '../../../features/model/empty_response.dart';
import '../../../features/model/patient_price_detail_model.dart';
import '../../appointments/model/appointments_model.dart';
import '../model/association_model.dart';
import '../model/patient_transaction_create_request_model.dart';
import '../model/patient_transaction_create_response_model.dart';
import '../model/patient_transaction_revenue_response_model.dart';

abstract class IPatientRegistrationProceduresService {
  final IHttpService http;

  IPatientRegistrationProceduresService(this.http);

  final String associationListPath =
      IPatientRegistrationProceduresServicePath.associationList.rawValue;
  final String patientTransactionCreatePath =
      IPatientRegistrationProceduresServicePath
          .patientTransactionCreate
          .rawValue;
  final String posRequestPath =
      IPatientRegistrationProceduresServicePath.posRequest.rawValue;
  final String posResponsePath =
      IPatientRegistrationProceduresServicePath.posResponse.rawValue;
  final String posErrorResponsePath =
      IPatientRegistrationProceduresServicePath.posErrorResponse.rawValue;
  final String patientTransactionRevenuePath =
      IPatientRegistrationProceduresServicePath
          .patientTransactionRevenue
          .rawValue;
  final String patientTransactionCancelPath =
      IPatientRegistrationProceduresServicePath
          .patientTransactionCancel
          .rawValue;
  final String patientTransactionDetailsPath =
      IPatientRegistrationProceduresServicePath
          .patientTransactionDetails
          .rawValue;
  final String appointmentByBranchPath =
      IPatientRegistrationProceduresServicePath.appointmentByBranch.rawValue;

  Future<ApiListResponse<AssocationModel>> getAssociationList(String branchId);
  Future<ApiResponse<PatientTransactionCreateResponseModel>>
  postPatientTransactionCreate(PatientTransactionCreateRequestModel request);
  postPosRequest(Map posRequest);
  postPosResponse(Map posResponse);
  postPosErrorResponse(String type, Map posErrorResponse);
  Future<ApiResponse<PatientTransactionRevenueResponseModel>>
  postPatientTransactionRevenue(PatientTransactionDetailsResponseModel request);
  Future<ApiResponse<EmptyResponse>> postPatientTransactionCancel(
    String patientId,
  );
  Future<ApiResponse<PatientTransactionDetailsResponseModel>>
  postPatientTransactionDetails(String patientId);
  Future<ApiResponse<AppointmentsModel>> postAppointmentByBranch(
    String branchId,
  );
}

enum IPatientRegistrationProceduresServicePath {
  associationList,
  patientTransactionCreate,
  posRequest,
  posResponse,
  posErrorResponse,
  patientTransactionRevenue,
  patientTransactionCancel,
  patientTransactionDetails,
  appointmentByBranch,
}

//BaseUrl'nin sonuna Search sayfasının requesti için gelecek olan eklenti için oluşturuldu
extension IMandatoryServicePathExtension
    on IPatientRegistrationProceduresServicePath {
  String get rawValue {
    final root = '/patient-transaction';
    switch (this) {
      case IPatientRegistrationProceduresServicePath.associationList:
        return '/patient-transaction/associations';
      case IPatientRegistrationProceduresServicePath.patientTransactionCreate:
        return '$root/create';
      case IPatientRegistrationProceduresServicePath.posRequest:
        return '/pos/sent';
      case IPatientRegistrationProceduresServicePath.posResponse:
        return '/pos/receive';
      case IPatientRegistrationProceduresServicePath.posErrorResponse:
        return '/pos/error-log';
      case IPatientRegistrationProceduresServicePath.patientTransactionRevenue:
        return '$root/revenue';
      case IPatientRegistrationProceduresServicePath.patientTransactionCancel:
        return '$root/cancel';
      case IPatientRegistrationProceduresServicePath.patientTransactionDetails:
        return '$root/transaction-details';
      case IPatientRegistrationProceduresServicePath.appointmentByBranch:
        return '$root/appointment-by-branch';
    }
  }
}
