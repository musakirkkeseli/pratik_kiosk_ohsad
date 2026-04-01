import '../../../core/utility/http_service.dart';
import '../../../features/model/api_list_response_model.dart';
import '../../../features/model/api_response_model.dart';
import '../model/result_file_request_model.dart';
import '../model/result_file_response_model.dart';
import '../model/results_request_model.dart';
import '../model/results_response_model.dart';

abstract class IResultsService {
  final IHttpService http;

  IResultsService(this.http);

  final String resultsPath = IResultsServicePath.results.rawValue;
  final String resultFilePath = IResultsServicePath.resultFile.rawValue;

  Future<ApiListResponse<ResultsResponseModel>> getResults(
    ResultsRequestModel requestModel,
  );
  Future<ApiResponse<ResultFileResponseModel>> getResultsFile(
    ResultFileRequestModel requestModel,
  );
}

enum IResultsServicePath { results, resultFile }

//BaseUrl'nin sonuna Search sayfasının requesti için gelecek olan eklenti için oluşturuldu
extension IResultsServicePathExtension on IResultsServicePath {
  String get rawValue {
    switch (this) {
      case IResultsServicePath.results:
        return "/lab/reports/list";
      case IResultsServicePath.resultFile:
        return "/lab/reports/file";
    }
  }
}
