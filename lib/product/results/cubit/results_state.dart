part of 'results_cubit.dart';

class ResultsState {
  final EnumGeneralStateStatus status;
  final EnumGeneralStateStatus fileStatus;
  final List<ResultsResponseModel> data;
  final String? fileUrl;
  final String? message;

  const ResultsState({
    this.status = EnumGeneralStateStatus.loading,
    this.fileStatus = EnumGeneralStateStatus.initial,
    this.data = const [],
    this.fileUrl,
    this.message,
  });

  ResultsState copyWith({
    EnumGeneralStateStatus? status,
    EnumGeneralStateStatus? fileStatus,
    List<ResultsResponseModel>? data,
    String? fileUrl,
    String? message,
  }) {
    return ResultsState(
      status: status ?? this.status,
      fileStatus: fileStatus ?? this.fileStatus,
      data: data ?? this.data,
      fileUrl: fileUrl ?? this.fileUrl,
      message: message,
    );
  }
}
