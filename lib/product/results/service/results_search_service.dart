import '../../../features/model/api_list_response_model.dart';
import '../../../features/model/api_response_model.dart';
import '../model/result_file_request_model.dart';
import '../model/result_file_response_model.dart';
import '../model/results_request_model.dart';
import '../model/results_response_model.dart';
import 'IResultsService.dart';

class ResultsService extends IResultsService {
  ResultsService(super.http);

  @override
  Future<ApiListResponse<ResultsResponseModel>> getResults(
    ResultsRequestModel requestModel,
  ) async {
    return http.requestList<ResultsResponseModel>(
      requestFunction: () => http.post(resultsPath, data: requestModel.toJson()),
      fromJson: (json) => ResultsResponseModel.fromJson(json),
    );
  }

  @override
  Future<ApiResponse<ResultFileResponseModel>> getResultsFile(
    ResultFileRequestModel requestModel,
  ) async {
    return http.request<ResultFileResponseModel>(
      requestFunction: () =>
          http.post(resultFilePath, data: requestModel.toJson()),
      fromJson: (json) =>
          ResultFileResponseModel.fromJson(json as Map<String, dynamic>),
    );
  }
}
