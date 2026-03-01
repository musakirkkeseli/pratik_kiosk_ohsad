part of 'patient_registration_procedures_cubit.dart';

class PatientRegistrationProceduresState {
  final EnumPatientRegistrationProcedures startStep;
  final EnumPatientRegistrationProcedures currentStep;
  final PatientRegistrationProceduresModel model;
  final EnumGeneralStateStatus status;
  final String? message;
  final EnumPaymentResultType? paymentResultType;
  final String? totalAmount;
  final EnumQueryProcessType? queryProcessType;
  final AppointmentsModel? appointmentsModel;
  final Transaction? transaction;
  final bool isConnettedPos;
  final bool isRegisrrationWarning;
  final bool isRequiredAssociationFetch;

  const PatientRegistrationProceduresState({
    required this.model,
    required this.currentStep,
    required this.startStep,
    this.status = EnumGeneralStateStatus.initial,
    this.message,
    this.paymentResultType,
    this.totalAmount,
    this.queryProcessType,
    this.appointmentsModel,
    this.transaction,
    this.isConnettedPos = true,
    this.isRegisrrationWarning = false,
    this.isRequiredAssociationFetch = false,
  });

  PatientRegistrationProceduresState copyWith({
    EnumPatientRegistrationProcedures? startStep,
    EnumPatientRegistrationProcedures? currentStep,
    PatientRegistrationProceduresModel? model,
    EnumGeneralStateStatus? status,
    String? message,
    EnumPaymentResultType? paymentResultType,
    String? totalAmount,
    EnumQueryProcessType? queryProcessType,
    AppointmentsModel? appointmentsModel,
    Transaction? transaction,
    bool? isConnettedPos,
    bool? isRegisrrationWarning,
    bool? isRequiredAssociationFetch,
  }) {
    return PatientRegistrationProceduresState(
      startStep: startStep ?? this.startStep,
      currentStep: currentStep ?? this.currentStep,
      model: model ?? this.model,
      status: status ?? this.status,
      message: message,
      paymentResultType: paymentResultType ?? this.paymentResultType,
      totalAmount: totalAmount ?? this.totalAmount,
      queryProcessType: queryProcessType,
      appointmentsModel: appointmentsModel ?? this.appointmentsModel,
      transaction: transaction ?? this.transaction,
      isConnettedPos: isConnettedPos ?? this.isConnettedPos,
      isRegisrrationWarning:
          isRegisrrationWarning ?? this.isRegisrrationWarning,
      isRequiredAssociationFetch:
          isRequiredAssociationFetch ?? this.isRequiredAssociationFetch,
    );
  }
}
