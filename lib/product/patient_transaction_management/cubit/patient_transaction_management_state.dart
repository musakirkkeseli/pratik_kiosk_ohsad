part of 'patient_transaction_management_cubit.dart';

class PatientTransactionManagementState {
  final EnumGeneralStateStatus status;
  final EnumGeneralStateStatus status2;
  final List<PatientTransactionModel> data;
  final PatientTransactionModel? selectedModel;
  final String? encriptedData;
  final String? message;

  const PatientTransactionManagementState({
    this.status = EnumGeneralStateStatus.loading,
    this.status2 = EnumGeneralStateStatus.initial,
    this.data = const [],
    this.selectedModel,
    this.encriptedData,
    this.message,
  });

  PatientTransactionManagementState copyWith({
    EnumGeneralStateStatus? status,
    EnumGeneralStateStatus? status2,
    List<PatientTransactionModel>? data,
    PatientTransactionModel? selectedModel,
    String? encriptedData,
    String? message,
  }) {
    return PatientTransactionManagementState(
      status: status ?? this.status,
      status2: status2 ?? this.status2,
      data: data ?? this.data,
      selectedModel: selectedModel ?? this.selectedModel,
      encriptedData: encriptedData ?? this.encriptedData,
      message: message ?? this.message,
    );
  }
}
