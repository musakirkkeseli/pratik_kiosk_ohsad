import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/const/constant_string.dart';
import 'package:kiosk/features/utility/navigation_service.dart';
import 'package:kiosk/features/widget/app_dialog.dart';
import 'package:mylog/logger_service.dart';

import '../../../core/widget/snackbar_service.dart';
import '../../../features/utility/const/constant_color.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/enum/enum_patient_registration_procedures.dart';
import '../../../features/utility/enum/enum_payment_result_type.dart';
import '../../../features/utility/enum/enum_query_process_type.dart';
import '../../../features/utility/extension/text_theme_extension.dart';
import '../../../features/utility/user_http_service.dart';
import '../cubit/patient_registration_procedures_cubit.dart';
import '../model/patient_registration_procedures_request_model.dart';
import '../model/query_process_response_model.dart';
import '../service/patient_registration_procedures_service.dart';
import 'widget/payment_result_widget.dart';
import 'widget/patient_pos_pairing_warning_widget.dart';
import 'widget/procedures_widget.dart';

class PatientRegistrationProceduresView extends StatelessWidget {
  final EnumPatientRegistrationProcedures startStep;
  final PatientRegistrationProceduresModel? model;
  const PatientRegistrationProceduresView({
    super.key,
    required this.startStep,
    this.model,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientRegistrationProceduresCubit(
        service: PatientRegistrationProceduresService(UserHttpService()),
        startStep: startStep,
        model: model,
      )..checkPosServiceAvailability(),
      child: BlocConsumer<PatientRegistrationProceduresCubit, PatientRegistrationProceduresState>(
        listenWhen: (previous, current) => previous.status != current.status,
        listener: (context, state) {
          switch (state.status) {
            case EnumGeneralStateStatus.loading:
              AppDialog(context).loadingDialog();
              break;
            case EnumGeneralStateStatus.success:
              NavigationService.ns.goBack();
              MyLog.debug('queryProcessType ${state.queryProcessType}');
              if (state.queryProcessType != null) {
                context
                    .read<PatientRegistrationProceduresCubit>()
                    .clearQueryProcessType();
                switch (state.queryProcessType) {
                  case EnumQueryProcessType.appointment:
                    AppDialog(context).infoDialog(
                      ConstantString().appointmentExistsForSelectedSection,
                      ConstantString().appointmentDetails,
                      firstActionText: ConstantString().continueWithAppointment,
                      firstOnPressed: () {
                        context
                            .read<PatientRegistrationProceduresCubit>()
                            .continueWithAppointment();
                        NavigationService.ns.goBack();
                      },
                      secondActionText:
                          ConstantString().cancelAndSelectAnotherSection,
                      secondOnPressed: () {
                        NavigationService.ns.goBack();
                      },
                      afterFunc: (onValue) => context
                          .read<PatientRegistrationProceduresCubit>()
                          .clearAppointmentAndTransaction(),
                    );
                    break;
                  default:
                    Transaction transaction =
                        state.transaction ?? Transaction();
                    Navigator.of(context)
                        .push(
                          RawDialogRoute(
                            pageBuilder:
                                (
                                  dialogcontext,
                                  animation,
                                  secondaryAnimation,
                                ) => AlertDialog(
                                  backgroundColor: ConstColor.white,
                                  title: Text(
                                    ConstantString().controlInspectionProcess,
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        ConstantString()
                                            .controlInspectionProcessMessage(
                                              transaction.ctime ?? "",
                                              transaction.doctorName ?? "",
                                            ),
                                        // "${transaction.ctime} tarihinde ${transaction.doctorName} doktorumuza oluşturulmuş dosyanızın üzerinden 10 gün geçmediği için kontrol muayenesi yapılacaktır.",
                                      ),
                                      state.queryProcessType ==
                                              EnumQueryProcessType
                                                  .appointmentWithTransaction
                                          ? Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(height: 10),
                                                Text(
                                                  ConstantString()
                                                      .controlInspectionProcessAppointmentMessage(
                                                        state
                                                                .appointmentsModel!
                                                                .appointmentTime ??
                                                            "",
                                                      ),
                                                  // "Kontrol Muayeneniz ${state.appointmentsModel!.appointmentTime} tarihli bir randevunuz üzerine işlenecektir.",
                                                ),
                                              ],
                                            )
                                          : SizedBox(),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        NavigationService.ns.goBack();
                                      },
                                      child: Text(
                                        ConstantString()
                                            .cancelAndSelectAnotherSection,
                                        style: context.dialogContent,
                                      ),
                                    ),
                                    OutlinedButton(
                                      onPressed: () {
                                        context
                                            .read<
                                              PatientRegistrationProceduresCubit
                                            >()
                                            .continueWithControlInspection(
                                              state.queryProcessType ==
                                                  EnumQueryProcessType
                                                      .appointmentWithTransaction,
                                            );
                                        NavigationService.ns.goBack();
                                      },
                                      child: Text(
                                        ConstantString()
                                            .controlInspectionProcessCreate,
                                        style: context.dialogContent,
                                      ),
                                    ),
                                  ],
                                ),
                          ),
                        )
                        .then(
                          (onValue) => context
                              .read<PatientRegistrationProceduresCubit>()
                              .clearAppointmentAndTransaction(),
                        );
                }
              } else if (state.message != null) {
                AppDialog(context).infoDialog(
                  ConstantString().completedSuccessfully,
                  state.message ?? ConstantString().success,
                  firstActionText: ConstantString().ok,
                  firstOnPressed: () {
                    NavigationService.ns.goBack();
                    NavigationService.ns.gotoMain();
                  },
                  afterFunc: (onValue) => context
                      .read<PatientRegistrationProceduresCubit>()
                      .isRegisrrationWarningCleared(),
                );
              }
              break;
            case EnumGeneralStateStatus.failure:
              NavigationService.ns.goBack();
              switch (state.isRegisrrationWarning) {
                case true:
                  AppDialog(context).infoDialog(
                    ConstantString().pleaseProceedToPatientAdmission,
                    state.message ?? 'Error',
                    firstActionText: ConstantString().ok,
                    firstOnPressed: () {
                      NavigationService.ns.goBack();
                    },
                    afterFunc: (onValue) => context
                        .read<PatientRegistrationProceduresCubit>()
                        .isRegisrrationWarningCleared(),
                  );
                  break;
                default:
                  SnackbarService().showSnackBar(state.message ?? 'Error');
              }
              break;
            default:
          }
        },
        builder: (context, state) {
          return Scaffold(body: _body(context, state));
        },
      ),
    );
  }

  _body(BuildContext context, PatientRegistrationProceduresState state) {
    if (state.paymentResultType is EnumPaymentResultType) {
      return PaymentResultWidget(
        paymentResultType: state.paymentResultType!,
        totalAmount: state.totalAmount,
        doctorName: state.model.doctorName,
        sectionName: state.model.branchName,
        transactionId: state.model.patientTransactionId,
      );
    }
    if (state.isConnettedPos == false) {
      return const PatientPosPairingWarningWidget();
    }
    return ProceduresWidget(
      iColor: ConstColor.grey300,
      aColor: Theme.of(context).colorScheme.primary,
      textTheme: Theme.of(context).textTheme,
      startStep: state.startStep,
      currentStep: state.currentStep,
      model: state.model,
    );
  }
}
