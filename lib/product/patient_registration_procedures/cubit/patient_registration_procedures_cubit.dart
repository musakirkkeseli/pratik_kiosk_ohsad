import 'package:pratik_pos_integration/pratik_pos_integration.dart';

import '../../../core/exception/network_exception.dart';
import '../../../core/utility/analytics_service.dart';
import '../../../core/utility/base_cubit.dart';
import '../../../core/utility/logger_service.dart';
import '../../../core/utility/user_login_status_service.dart';
import '../../../core/widget/snackbar_service.dart';
import '../../../features/model/patient_price_detail_model.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/enum/enum_patient_registration_procedures.dart';
import '../../../features/utility/enum/enum_payment_result_type.dart';
import '../../appointments/model/appointments_model.dart';
import '../../doctor/model/doctor_model.dart';
import '../../../features/model/patient_mandatory_model.dart';
import '../model/association_model.dart';
import '../../section/model/section_model.dart';
import '../model/patient_registration_procedures_request_model.dart';
import '../model/patient_transaction_create_request_model.dart';
import '../model/patient_transaction_create_response_model.dart';
import '../service/IPatientRegistrationProceduresService.dart';

part 'patient_registration_procedures_state.dart';

class PatientRegistrationProceduresCubit
    extends BaseCubit<PatientRegistrationProceduresState> {
  final IPatientRegistrationProceduresService service;
  final EnumPatientRegistrationProcedures startStep;
  final PatientRegistrationProceduresModel? model;

  PatientRegistrationProceduresCubit({
    required this.service,
    required this.startStep,
    required this.model,
  }) : super(
         PatientRegistrationProceduresState(
           startStep: startStep,
           currentStep: startStep,
           model: model ?? PatientRegistrationProceduresModel(),
         ),
       );

  final MyLog _log = MyLog('PatientRegistrationProceduresCubit');

  void _trackButton(String name, {Map<String, dynamic>? extra}) {
    AnalyticsService().trackButtonClicked(
      name,
      screenName: 'patient_registration',
      extra: extra,
    );
  }

  checkPosServiceAvailability() async {
    _log.d("checkPosServiceAvailability");
    try {
      final response = await PosService.instance.pairing();

      if (response.success) {
        safeEmit(
          state.copyWith(
            // status: EnumGeneralStateStatus.success,
            isConnettedPos: true,
          ),
        );
      } else {
        safeEmit(
          state.copyWith(
            // status: EnumGeneralStateStatus.success,
            isConnettedPos: false,
          ),
        );
      }
    } on PosException catch (e) {
      _log.e('PosException: $e');
      safeEmit(
        state.copyWith(
          // status: EnumGeneralStateStatus.success,
          isConnettedPos: false,
        ),
      );
    } catch (e) {
      _log.e('Exception: $e');
      safeEmit(
        state.copyWith(
          // status: EnumGeneralStateStatus.success,
          isConnettedPos: false,
        ),
      );
    }
  }

  Future<void> selectSection(SectionItems section) async {
    if (section.sectionId != null && section.sectionName != null) {
      safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
      final updatedModel = state.model;
      updatedModel.branchId = section.sectionId.toString();
      updatedModel.branchName = section.sectionName;
      _trackButton('select_section');
      try {
        final res = await service.postAppointmentByBranch(
          section.sectionId.toString(),
        );

        if (res.success && res.data is AppointmentsModel) {
          AppointmentsModel appointmentsModel = res.data!;
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              warningCurrentAppointment: true,
              appointmentsModel: appointmentsModel,
            ),
          );
          // updatedModel.appointmentId = appointmentsModel.appointmentID;
          // updatedModel.doctorId = appointmentsModel.doctorID;
          // updatedModel.doctorName = appointmentsModel.doctorName;
          // updatedModel.departmentId = appointmentsModel.departmentID;
          // updatedModel.departmentName = appointmentsModel.departmentName;
          // safeEmit(
          //   state.copyWith(
          //     model: updatedModel,
          //     currentStep: EnumPatientRegistrationProcedures.doctor,
          //     startStep: EnumPatientRegistrationProcedures.patientTransaction,
          //   ),
          // );
          // nextStep();
        } else {
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              model: updatedModel,
            ),
          );
          nextStep();
        }
      } on NetworkException catch (e) {
        _log.e('postAppointmentByBranch NetworkException: $e');
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.success,
            model: updatedModel,
          ),
        );
        nextStep();
      } catch (e) {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.success,
            model: updatedModel,
          ),
        );
        nextStep();
      }
    }
  }

  clearWarningCurrentAppointment() {
    safeEmit(state.copyWith(warningCurrentAppointment: false));
  }

  continueWithAppointment() {
    final updatedModel = state.model;
    final appointmentsModel = state.appointmentsModel;
    if (appointmentsModel != null) {
      updatedModel.appointmentId = appointmentsModel.appointmentID;
      updatedModel.doctorId = appointmentsModel.doctorID;
      updatedModel.doctorName = appointmentsModel.doctorName;
      updatedModel.departmentId = appointmentsModel.departmentID;
      updatedModel.departmentName = appointmentsModel.departmentName;
      safeEmit(
        state.copyWith(
          model: updatedModel,
          currentStep: EnumPatientRegistrationProcedures.doctor,
          startStep: EnumPatientRegistrationProcedures.doctor,
        ),
      );
    }
  }

  clearAppointmentsModel() {
    safeEmit(state.copyWith(appointmentsModel: null));
  }

  void selectDoctor(DoctorItems section) {
    if (section.doctorId != null && section.doctorName != null) {
      final updatedModel = state.model;
      updatedModel.doctorId = section.doctorId.toString();
      updatedModel.departmentId = section.departmentId.toString();
      updatedModel.departmentName = section.departmentName;
      updatedModel.doctorName = "${section.doctorTitle} ${section.doctorName}";
      safeEmit(state.copyWith(model: updatedModel));
      _trackButton('select_doctor');
      fetchAssociations();
    }
  }

  void autoSelectDoctor() {
    _log.d("autoSelectDoctor called ${state.model.doctorId}");
    if ((startStep == EnumPatientRegistrationProcedures.doctor ||
            state.startStep == EnumPatientRegistrationProcedures.doctor) &&
        state.model.doctorId is String &&
        state.model.appointmentId is String) {
      _log.d("autoSelectDoctor run");
      final updatedModel = state.model;
      updatedModel.doctorId = updatedModel.doctorId.toString();
      updatedModel.departmentId = updatedModel.departmentId.toString();
      updatedModel.departmentName = updatedModel.departmentName;
      updatedModel.doctorName = updatedModel.doctorName;
      safeEmit(state.copyWith(model: updatedModel));
      _trackButton('select_doctor');
      fetchAssociations();
    }
  }

  Future<void> fetchAssociations() async {
    _log.d("fetchAssociations called");
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    try {
      final res = await service.getAssociationList(state.model.branchId ?? "");
      if (res.success == true && res.data is List<AssocationModel>) {
        _log.d("patient: $res");
        if ((res.data ?? []).length == 1) {
          final section = res.data![0];
          if (section.assocationId != null && section.assocationName != null) {
            final updatedModel = state.model;
            updatedModel.assocationId = section.assocationId ?? "";
            updatedModel.assocationName = section.assocationName;
            updatedModel.gssAssocationId = section.gssAssocationId ?? "";
            safeEmit(
              state.copyWith(
                status: EnumGeneralStateStatus.success,
                model: updatedModel,
              ),
            );
            _trackButton(
              'select_association',
              extra: {
                'association_id': section.assocationId,
                'association_name': section.assocationName,
              },
            );
            nextStep();
          }
        } else {
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: ConstantString().insuranceTypeNotFound,
              isRegisrrationWarning: true,
            ),
          );
        }
      } else {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: res.message,
            isRegisrrationWarning: true,
          ),
        );
      }
    } on NetworkException catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: e.message,
          isRegisrrationWarning: true,
        ),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: ConstantString().errorOccurred,
          isRegisrrationWarning: true,
        ),
      );
    }
  }

  void mandatoryCheck(List<PatientMandatoryModel> mandatoryModelList) {
    patientTransactionCreate(mandatoryModelList);
  }

  Future<void> patientTransactionCreate(
    List<PatientMandatoryModel> mandatoryModelList,
  ) async {
    safeEmit(state.copyWith(status: EnumGeneralStateStatus.loading));
    PatientRegistrationProceduresModel model = state.model;
    try {
      PatientTransactionCreateRequestModel request =
          PatientTransactionCreateRequestModel(
            associationId: model.assocationId,
            associationName: model.assocationName,
            departmentId: model.departmentId,
            departmentName: model.departmentName,
            branchId: model.branchId,
            branchName: model.branchName,
            doctorId: model.doctorId,
            doctorName: model.doctorName,
            appointmentId: model.appointmentId,
            mandatoryFields: mandatoryModelList,
          );
      final res = await service.postPatientTransactionCreate(request);

      if (res.success &&
          res.data is PatientTransactionCreateResponseModel &&
          res.data!.patientId is String) {
        model.patientId = res.data!.patientId ?? "";
        model.patientTransactionId = res.data!.patientTransactionId.toString();
        fetchPatientPrice(model);
        // safeEmit(
        //   state.copyWith(status: EnumGeneralStateStatus.success, model: model),
        // );
        // nextStep();
      } else {
        patientTransactionCancel();
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: res.message,
            isRegisrrationWarning: true,
          ),
        );
      }
    } on NetworkException catch (e) {
      patientTransactionCancel();
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: e.message,
          isRegisrrationWarning: true,
        ),
      );
    } catch (e) {
      patientTransactionCancel();
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: ConstantString().errorOccurred,
          isRegisrrationWarning: true,
        ),
      );
    }
  }

  isRegisrrationWarningCleared() {
    safeEmit(state.copyWith(isRegisrrationWarning: false));
  }

  Future<void> fetchPatientPrice(
    PatientRegistrationProceduresModel model,
  ) async {
    try {
      final res = await service.postPatientTransactionDetails(model.patientId!);
      if (res.success && res.data is PatientTransactionDetailsResponseModel) {
        _log.d(res);
        List<PaymentContent>? paymentContentList = res.data!.paymentContent;
        PatientContent? patientContent = res.data!.patientContent;
        if (paymentContentList is List<PaymentContent> &&
            patientContent is PatientContent) {
          model.patientContent = patientContent;
          model.paymentContentList = paymentContentList;
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.success,
              model: model,
            ),
          );
          nextStep();
        } else {
          patientTransactionCancel();
          safeEmit(
            state.copyWith(
              status: EnumGeneralStateStatus.failure,
              message: res.message,
            ),
          );
        }
      } else {
        patientTransactionCancel();
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: res.message,
          ),
        );
      }
    } on NetworkException catch (e) {
      patientTransactionCancel();
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: e.message,
        ),
      );
    } catch (e) {
      patientTransactionCancel();
      safeEmit(
        state.copyWith(
          status: EnumGeneralStateStatus.failure,
          message: ConstantString().errorOccurred,
        ),
      );
    }
  }

  Future<void> paymentAction() async {
    final updatedModel = state.model;
    PatientTransactionDetailsResponseModel patientPriceDetailModel =
        PatientTransactionDetailsResponseModel(
          patientContent: updatedModel.patientContent,
          paymentContent: updatedModel.paymentContentList,
        );
    updatedModel.patientPriceDetailModel = patientPriceDetailModel;
    safeEmit(state.copyWith(model: updatedModel));
    final totalAmount =
        patientPriceDetailModel.patientContent?.totalPrice ?? "0";
    AnalyticsService().trackPaymentScreenOpened(
      amount: double.tryParse(updatedModel.patientContent?.totalPrice ?? '0'),
    );
    nextStep();
    List<PosProduct> products = [];
    for (PaymentContent paymentContent
        in updatedModel.paymentContentList ?? []) {
      products.add(
        PosProduct(
          amount: double.tryParse(paymentContent.price ?? "0") ?? 0.0,
          name: paymentContent.paymentName ?? "",
          taxGroupCode: (paymentContent.isContributionFee ?? false)
              ? EnumProductTaxGroupCode.contributionFee
              : EnumProductTaxGroupCode.standart,
        ),
      );
    }
    try {
      final customerInfo = {
        'firstName': UserLoginStatusService().userName ?? "",
        'familyName': UserLoginStatusService().userSurname ?? "",
        'taxNumber': UserLoginStatusService().userTcNo ?? "",
        'country': 'TR',
        'city': 'ISTANBUL',
        'district': 'KADIKOY',
      };

      // final orderNo = DateTime.now().millisecondsSinceEpoch.toString();
      final now = DateTime.now();
      final datePart =
          '${now.hour}'.padLeft(2, '0') + '${now.minute}'.padLeft(2, '0');
      final orderNo = "$datePart${updatedModel.patientId ?? '0000000'}";
      await service.postPosRequest({
        'orderNo': orderNo,
        'products': products.map((e) => e.toJson()).toList(),
        'customerInfo': customerInfo,
      });
      final PosGetSaleResultResponse result = await PosService.instance
          .completeSaleWithPolling(
            orderNo: orderNo,
            products: products,
            customerInfo: customerInfo,
            onPolling: (int attempt, PosSaleStatus status) {
              MyLog.debug('Polling Attempt: $attempt, Status: $status');
            },
          );
      await service.postPosResponse(result.toJson());
      if (result.success && result.saleStatus == PosSaleStatus.success) {
        SnackbarService().showSnackBar(ConstantString().paymentSuccess);
        patientPriceDetailModel.posContent = PosContent(
          patientTransactionId: updatedModel.patientTransactionId,
          dataId: result.id.toString(),
          orderNo: result.orderNo ?? '',
          statusId: result.statusId.toString(),
          saleNumber: result.saleNumber ?? '',
          inquiryLink: result.inquiryLink ?? '',
          amount: result.amount ?? 0.0,
        );
        patientTransactionRevenue(patientPriceDetailModel);
      } else {
        SnackbarService().showSnackBar(ConstantString().paymentFailure);
        patientTransactionCancel();
        safeEmit(
          state.copyWith(
            paymentResultType: EnumPaymentResultType.failure,
            totalAmount: totalAmount,
          ),
        );
      }
    } on PosException catch (e) {
      SnackbarService().showSnackBar(
        "${ConstantString().paymentFailure} ${e.message}",
      );
      patientTransactionCancel();
      safeEmit(
        state.copyWith(
          paymentResultType: EnumPaymentResultType.failure,
          totalAmount: totalAmount,
        ),
      );
    } catch (e) {
      SnackbarService().showSnackBar("${ConstantString().paymentFailure}, $e");
      patientTransactionCancel();
      safeEmit(
        state.copyWith(
          paymentResultType: EnumPaymentResultType.failure,
          totalAmount: totalAmount,
        ),
      );
    }
  }

  Future<void> patientTransactionRevenue(
    PatientTransactionDetailsResponseModel patientPriceDetailModel,
  ) async {
    MyLog("patientTransactionRevenue").d(patientPriceDetailModel.toJson());
    try {
      final res = await service.postPatientTransactionRevenue(
        patientPriceDetailModel,
      );

      // Total amount'u al
      final totalAmount =
          patientPriceDetailModel.patientContent?.totalPrice ?? "0";

      if (res.success) {
        _log.d("Ödeme Tamamlandı");
        AnalyticsService().trackPaymentSuccess(
          amount: double.tryParse(totalAmount),
        );
        safeEmit(
          state.copyWith(
            paymentResultType: EnumPaymentResultType.success,
            totalAmount: totalAmount,
          ),
        );
      } else {
        AnalyticsService().trackPaymentFailed(
          amount: double.tryParse(totalAmount),
          reason: res.message,
        );
        safeEmit(
          state.copyWith(
            paymentResultType: EnumPaymentResultType.failure,
            totalAmount: totalAmount,
          ),
        );
      }
    } on NetworkException catch (e) {
      _log.d("NetworkException ${e.message}");
      AnalyticsService().trackPaymentFailed(
        amount: double.tryParse(
          patientPriceDetailModel.patientContent?.totalPrice ?? '0',
        ),
        reason: e.message,
      );
      safeEmit(
        state.copyWith(
          paymentResultType: EnumPaymentResultType.failure,
          totalAmount:
              patientPriceDetailModel.patientContent?.totalPrice ?? "0",
          message: e.message,
        ),
      );
    } catch (e) {
      AnalyticsService().trackPaymentFailed(
        amount: double.tryParse(
          patientPriceDetailModel.patientContent?.totalPrice ?? '0',
        ),
        reason: e.toString(),
      );
      safeEmit(
        state.copyWith(
          paymentResultType: EnumPaymentResultType.failure,
          totalAmount:
              patientPriceDetailModel.patientContent?.totalPrice ?? "0",
          message: ConstantString().errorOccurred,
        ),
      );
    }
  }

  Future<void> patientTransactionCancel() async {
    PatientRegistrationProceduresModel model = state.model;
    String? patientId = model.patientId;
    if (patientId is String) {
      try {
        await service.postPatientTransactionCancel(patientId);
      } on NetworkException catch (e) {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: e.message,
          ),
        );
      } catch (e) {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: ConstantString().errorOccurred,
          ),
        );
      }
    }
  }

  void nextStep() {
    final currentStep = state.currentStep;
    if (currentStep.index <
        EnumPatientRegistrationProcedures.values.length - 1) {
      safeEmit(
        state.copyWith(
          currentStep:
              EnumPatientRegistrationProcedures.values[currentStep.index + 1],
        ),
      );
    }
  }

  void previousStep() {
    final currentStep = state.currentStep;
    final model = state.model;

    switch (state.currentStep) {
      case EnumPatientRegistrationProcedures.section:
        break;
      case EnumPatientRegistrationProcedures.doctor:
        model.branchId = null;
        model.branchName = null;
        safeEmit(state.copyWith(model: model));
        break;
      // case EnumPatientRegistrationProcedures.patientTransaction:
      //   model.doctorId = null;
      //   model.doctorName = null;
      //   safeEmit(state.copyWith(model: model));
      //   break;
      case EnumPatientRegistrationProcedures.payment:
        model.assocationId = null;
        model.assocationName = null;
        safeEmit(state.copyWith(model: model));
        break;
      case EnumPatientRegistrationProcedures.mandatory:
        model.assocationId = null;
        model.assocationName = null;
        model.doctorId = null;
        model.doctorName = null;
        safeEmit(state.copyWith(model: model));
        break;
      case EnumPatientRegistrationProcedures.price:
        break;
    }
    if (currentStep.index > 0) {
      safeEmit(
        state.copyWith(
          currentStep:
              EnumPatientRegistrationProcedures.values[currentStep.index - 1],
        ),
      );
    }
  }
}
