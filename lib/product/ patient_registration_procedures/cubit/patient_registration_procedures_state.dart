part of 'patient_registration_procedures_cubit.dart';

class PatientRegistrationProceduresState {
  final EnumPatientRegistrationProcedures startStep;
  final EnumPatientRegistrationProcedures currentStep;
  final PatientRegistrationProceduresModel model;
  final EnumGeneralStateStatus status;
  final String? message;
  final EnumPaymentResultType? paymentResultType;
  final String? totalAmount;
  final bool warningCurrentAppointment;
  final AppointmentsModel? appointmentsModel;
  final bool isConnettedPos;
  final bool isRegisrrationWarning;

  const PatientRegistrationProceduresState({
    required this.model,
    required this.currentStep,
    required this.startStep,
    this.status = EnumGeneralStateStatus.initial,
    this.message,
    this.paymentResultType,
    this.totalAmount,
    this.warningCurrentAppointment = false,
    this.appointmentsModel,
    this.isConnettedPos = true,
    this.isRegisrrationWarning = false,
  });

  PatientRegistrationProceduresState copyWith({
    EnumPatientRegistrationProcedures? startStep,
    EnumPatientRegistrationProcedures? currentStep,
    PatientRegistrationProceduresModel? model,
    EnumGeneralStateStatus? status,
    String? message,
    EnumPaymentResultType? paymentResultType,
    String? totalAmount,
    bool? warningCurrentAppointment,
    AppointmentsModel? appointmentsModel,
    bool? isConnettedPos,
    bool? isRegisrrationWarning,
  }) {
    return PatientRegistrationProceduresState(
      startStep: startStep ?? this.startStep,
      currentStep: currentStep ?? this.currentStep,
      model: model ?? this.model,
      status: status ?? this.status,
      message: message,
      paymentResultType: paymentResultType ?? this.paymentResultType,
      totalAmount: totalAmount ?? this.totalAmount,
      warningCurrentAppointment:
          warningCurrentAppointment ?? this.warningCurrentAppointment,
      appointmentsModel: appointmentsModel ?? this.appointmentsModel,
      isConnettedPos: isConnettedPos ?? this.isConnettedPos,
      isRegisrrationWarning:
          isRegisrrationWarning ?? this.isRegisrrationWarning,
    );
  }
}
