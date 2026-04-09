import 'dart:io';
import 'dart:convert';
import 'package:vaultmesh_flutter_x/repository/vault_repository.dart';
import 'package:vaultmesh_flutter_x/security/encryption_manager.dart';

class LocalSyncServer {
  static HttpServer? _server;
  static bool _isRunning = false;
  static String _deviceId = '';
  static late EncryptionManager _encryptionManager;
  static late VaultRepository _vaultRepository;

  static Future<void> startServer({
    required String deviceId,
    required EncryptionManager encryptionManager,
    required VaultRepository vaultRepository,
    int port = 8080,
  }) async {
    _deviceId = deviceId;
    _encryptionManager = encryptionManager;
    _vaultRepository = vaultRepository;

    if (_isRunning) return;

    _server = await HttpServer.bind(InternetAddress.anyIPv4, port);
    _isRunning = true;

    print('Local sync server started on port $port for device $_deviceId');

    await for (HttpRequest request in _server!) {
      if (request.uri.path == '/sync') {
        if (WebSocketTransformer.isUpgradeRequest(request)) {
          final socket = await WebSocketTransformer.upgrade(request);
          _handleSyncSocket(socket);
        }
      } else {
        request.response.statusCode = HttpStatus.notFound;
        request.response.close();
      }
    }
  }

  static void _handleSyncSocket(WebSocket socket) {
    print('New sync connection from ${socket.remoteAddress}');

    socket.listen((data) async {
      final message = jsonDecode(data as String);
      if (message is Map && message.containsKey('action')) {
        if (message['action'] == 'sync_request') {
          final theirDeviceId = message['deviceId'];
          print('Sync request from device $theirDeviceId');

          // ڈیٹا سینک کرنے کا لاجک یہاں آئے گا
          final allData = await _vaultRepository.getAllData();
          final encryptedData = _encryptionManager.encrypt(jsonEncode(allData));

          socket.add(jsonEncode({
            'action': 'sync_response',
            'deviceId': _deviceId,
            'data': encryptedData,
          }));
        }
      }
    });
  }

  static Future<void> stopServer() async {
    if (_isRunning && _server != null) {
      await _server!.close();
      _isRunning = false;
      print('Local sync server stopped');
    }
  }
}