import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../core/utility/logger_service.dart';
import '../../core/utility/login_status_service.dart';
import '../model/pos_http_request_model.dart';
import 'pos_connect_http_service.dart';

class SocketService {
  SocketService._internal();
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  IO.Socket? _socket;

  void connect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.destroy();
      _socket = null;
    }

    _socket = IO.io(
      'http://127.0.0.1:5004',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setExtraHeaders({
            'Authorization': 'Bearer ${LoginStatusService().accessToken}',
          })
          .build(),
    );

    _attachCoreListeners();
    _attachBusinessListeners();

    _socket!.connect();
  }

  void disconnect() => _socket?.disconnect();

  void _emit(String event, dynamic data) => _socket?.emit(event, data);
  void _on(String event, Function(dynamic) cb) => _socket?.on(event, cb);
  void _off(String event) => _socket?.off(event);

  void _attachCoreListeners() {
    _socket
      ?..onConnect((_) => MyLog.debug('[Socket] Connected'))
      ..onDisconnect((_) => MyLog.debug('[Socket] Disconnected'))
      ..onConnectError((d) => MyLog.error('[Socket] Connect Error: $d'))
      ..onError((d) => MyLog.error('[Socket] Error: $d'));
  }

  void _attachBusinessListeners() {
    _socket
      ?..on('pong-test', _handleSimpleLog)
      ..on("pos-event", _handlePosEvent);
  }

  void _handleSimpleLog(dynamic data) =>
      MyLog.debug('[Socket _handleSimpleLog] $data');
  void _handlePosEvent(dynamic data) async {
    MyLog.debug('[Socket _handlePosEvent] $data');
    PosHttpRequestModel request = PosHttpRequestModel.fromJson(data);
    await PosConnectHttpService().sendPosHttpRequest(request);
  }

  void joinRoom() {
    _emit('ping-test', {"message": "Postman'den merhaba!"});
  }

  void posConfigure() {
    _emit('pos-configure', {"message": "Postman'den merhaba!"});
  }

  void sendMessage({required int roomId, required String content}) =>
      _emit('sendMessage', {'roomId': roomId, 'content': content});

  void leaveRoom(int roomId) {
    _off('pong-test');
  }
}
