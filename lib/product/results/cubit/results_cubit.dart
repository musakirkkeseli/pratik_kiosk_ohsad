import 'package:kiosk/core/utility/base_cubit.dart';

import '../../../core/exception/network_exception.dart';
import '../../../features/utility/const/constant_string.dart';
import '../../../features/utility/enum/enum_general_state_status.dart';
import '../model/result_file_request_model.dart';
import '../model/result_file_response_model.dart';
import '../model/results_request_model.dart';
import '../model/results_response_model.dart';
import '../service/IResultsService.dart';

part 'results_state.dart';

class ResultsCubit extends BaseCubit<ResultsState> {
  final IResultsService service;
  ResultsCubit(this.service) : super(ResultsState());

  Future<void> fetchResults() async {
    try {
      final res = await service.getResults(ResultsRequestModel());
      if (res.success == true && res.data is List<ResultsResponseModel>) {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.success,
            data: res.data,
          ),
        );
      } else {
        safeEmit(
          state.copyWith(
            status: EnumGeneralStateStatus.failure,
            message: res.message,
          ),
        );
      }
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

  Future<void> fetchResultFile(ResultFileRequestModel requestModel) async {
    safeEmit(state.copyWith(fileStatus: EnumGeneralStateStatus.loading));
    try {
      final res = await service.getResultsFile(requestModel);
      if (res.success && res.data is ResultFileResponseModel) {
        safeEmit(
          state.copyWith(
            fileStatus: EnumGeneralStateStatus.success,
            fileUrl: res.data?.pdfFilePath,
          ),
        );
      } else {
        safeEmit(
          state.copyWith(
            fileStatus: EnumGeneralStateStatus.failure,
            message: res.message,
            fileUrl: null,
          ),
        );
      }
    } on NetworkException catch (e) {
      safeEmit(
        state.copyWith(
          fileStatus: EnumGeneralStateStatus.failure,
          message: e.message,
          fileUrl: null,
        ),
      );
    } catch (e) {
      safeEmit(
        state.copyWith(
          fileStatus: EnumGeneralStateStatus.failure,
          message: ConstantString().errorOccurred,
          fileUrl: null,
        ),
      );
    }
  }
}
