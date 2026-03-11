import 'package:dio/dio.dart';
import 'package:kiosk/core/utility/logger_service.dart';

import '../model/pos_http_request_model.dart';

class PosConnectHttpService {
  Future<void> sendPosHttpRequest(PosHttpRequestModel request) async {
    MyLog("PosConnectHttpService").d("Sending POS HTTP Request");
    Dio(
          BaseOptions(
            baseUrl: '${request.pos?.baseUrl}',
            headers: request.pos?.headers,
            connectTimeout: Duration(milliseconds: request.timeoutMs ?? 5000),
          ),
        )
        .request(
          request.pos?.path ?? '',
          data: request.payload,
          options: Options(method: request.pos?.method),
        )
        .then((response) {
          MyLog("SendPosHttpResponse").d("${response.data}");
        })
        .catchError((error) {
          MyLog("SendPosHttpError").e("POS HTTP Error: $error");
        });
  }
}
