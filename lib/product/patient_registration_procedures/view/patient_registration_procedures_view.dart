import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiosk/features/utility/const/constant_string.dart';
import 'package:kiosk/features/utility/navigation_service.dart';
import 'package:kiosk/features/widget/app_dialog.dart';

import '../../../core/widget/snackbar_service.dart';
import '../../../features/utility/const/constant_color.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/enum/enum_patient_registration_procedures.dart';
import '../../../features/utility/enum/enum_payment_result_type.dart';
import '../../../features/utility/user_http_service.dart';
import '../cubit/patient_registration_procedures_cubit.dart';
import '../model/patient_registration_procedures_request_model.dart';
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
      child:
          BlocConsumer<
            PatientRegistrationProceduresCubit,
            PatientRegistrationProceduresState
          >(
            listenWhen: (previous, current) =>
                previous.status != current.status,
            listener: (context, state) {
              switch (state.status) {
                case EnumGeneralStateStatus.loading:
                  AppDialog(context).loadingDialog();
                  break;
                case EnumGeneralStateStatus.success:
                  NavigationService.ns.goBack();
                  if (state.warningCurrentAppointment == true) {
                    context
                        .read<PatientRegistrationProceduresCubit>()
                        .clearWarningCurrentAppointment();
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
                          .clearAppointmentsModel(),
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
