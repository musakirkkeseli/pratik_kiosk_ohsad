import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/widget/loading_widget.dart';
import '../../../features/utility/const/constant_color.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../../../features/utility/extension/text_theme_extension.dart';
import '../../../features/utility/navigation_service.dart';
import '../../../features/utility/user_http_service.dart';
import '../../../features/widget/app_dialog.dart';
import '../cubit/patient_transaction_management_cubit.dart';
import '../model/patient_transaction_model.dart';
import '../service/patient_transaction_management_service.dart';
import 'widget/patient_transaction_card.dart';

class PatientTransactionManagementView extends StatefulWidget {
  const PatientTransactionManagementView({super.key});

  @override
  State<PatientTransactionManagementView> createState() =>
      _PatientTransactionManagementViewState();
}

class _PatientTransactionManagementViewState
    extends State<PatientTransactionManagementView> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PatientTransactionManagementCubit(
        PatientTransactionManagementService(UserHttpService()),
      )..fecthPatientTransactionManagement(),
      child:
          BlocConsumer<
            PatientTransactionManagementCubit,
            PatientTransactionManagementState
          >(
            listener: (context, state) {
              switch (state.status2) {
                case EnumGeneralStateStatus.loading:
                  AppDialog(context).loadingDialog();
                  break;
                case EnumGeneralStateStatus.success:
                  NavigationService.ns.goBack();
                  if (state.encriptedData != null &&
                      state.selectedModel != null) {
                    _showSmsCodeDialog(context);
                  } else {
                    AppDialog(context).infoDialog(
                      "ConstantString().procedureCancellationSuccessful",
                      "ConstantString().procedureCancellationDetails",
                    );
                  }
                  break;
                case EnumGeneralStateStatus.failure:
                  NavigationService.ns.goBack();
                  AppDialog(context).infoDialog(
                    ConstantString().errorOccurred,
                    state.message ?? ConstantString().errorOccurred,
                    afterFunc: (onValue) => context
                        .read<PatientTransactionManagementCubit>()
                        .clearStatus2(),
                  );
                  break;
                default:
              }
            },
            builder: (context, state) {
              return Scaffold(
                backgroundColor: ConstColor.grey100,
                appBar: AppBar(
                  title: Text(ConstantString().arrivalOpening),
                  backgroundColor: ConstColor.white,
                  elevation: 0,
                ),
                body: _body(context, state),
              );
            },
          ),
    );
  }

  _body(BuildContext context, PatientTransactionManagementState state) {
    switch (state.status) {
      case EnumGeneralStateStatus.loading:
        return LoadingWidget();
      case EnumGeneralStateStatus.success:
        return ListView.separated(
          shrinkWrap: true,
          padding: const EdgeInsets.all(20.0),
          itemCount: state.data.length,
          itemBuilder: (context, index) {
            PatientTransactionModel model =
                state.data[index];
            return PatientTransactionCard(
              model: model,
              onCancel: () {
                _showCancelConfirmation(context, model);
              },
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 16),
        );
      default:
        return Center(
          child: Text(state.message ?? ConstantString().errorOccurred),
        );
    }
  }

  void _showCancelConfirmation(
    BuildContext cubitContext,
    PatientTransactionModel model,
  ) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text("Ödeme İadesi Al", style: context.sectionTitle),
          content: Text(
            "Ödeme işlemini gerçekleştirdiğiniz kaydınız için yaptığınız ödemenin iadesi yapılacaktır. Bu işlem hastane yönetiminden onay gerektirmektedir. Bu sebeple iade işlemlerinde hastane personelinden destek almanız gerekmektedir.",
            style: context.bodyPrimary,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Vazgeç", style: context.bodySecondary),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                cubitContext
                    .read<PatientTransactionManagementCubit>()
                    .sendOtp(model);
              },
              style: ElevatedButton.styleFrom(backgroundColor: ConstColor.red),
              child: Text("Devam et", style: context.whiteButtonText),
            ),
          ],
        );
      },
    );
  }

  void _showSmsCodeDialog(BuildContext context) {
    final TextEditingController smsController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text("SMS Doğrulama", style: context.sectionTitle),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Telefonunuza gönderilen SMS kodunu giriniz.",
                style: context.bodyPrimary,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: smsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "SMS Kodu",
                  border: OutlineInputBorder(),
                ),
                maxLength: 6,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Vazgeç", style: context.bodySecondary),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<PatientTransactionManagementCubit>().otpVerify(
                  smsController.text,
                );
              },
              style: ElevatedButton.styleFrom(backgroundColor: ConstColor.red),
              child: Text("Onayla", style: context.whiteButtonText),
            ),
          ],
        );
      },
    );
  }
}
