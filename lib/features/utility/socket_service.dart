import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../core/utility/logger_service.dart';
import '../../core/utility/login_status_service.dart';
import 'const/constant_string.dart';

class SocketService {
  SocketService._internal();
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;

  IO.Socket? _socket;

  void init() {}

  void connect() {
    if (_socket != null) {
      _socket!.disconnect();
      _socket!.destroy();
      _socket = null;
    }

    _socket = IO.io(
      '${ConstantString.backendUrl}/chat',
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
      ?..on('joinedRoom', _handleSimpleLog)
      ..on('userJoined', _handleSimpleLog)
      ..on('userLeft', _handleSimpleLog)
      ..on('otherMessages', _handleOtherMessages);
  }

  void _handleSimpleLog(dynamic data) => MyLog.debug('[Socket] $data');

  void _handleOtherMessages(dynamic data) {}

  void joinRoom({
    required int otherCompanyId,
    required Function() onNewMessage,
  }) {
    _emit('joinRoom', {'otherCompanyId': otherCompanyId});
    _off('newMessage');
    _on('newMessage', (data) {});
  }

  void sendMessage({required int roomId, required String content}) =>
      _emit('sendMessage', {'roomId': roomId, 'content': content});

  void leaveRoom(int roomId) {
    _emit('leaveRoom', {'roomId': roomId});
    _off('newMessage');
  }
}
