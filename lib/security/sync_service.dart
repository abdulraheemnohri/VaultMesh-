import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:nsd/nsd.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_router/shelf_router.dart';
import 'package:vaultmesh_flutter_x/database/database.dart';
import 'package:http/http.dart' as http;
import 'package:vaultmesh_flutter_x/security/sync_security_service.dart';

class SyncService {
  final AppDatabase db;
  final SyncSecurityService _security = SyncSecurityService();
  HttpServer? _server;
  Discovery? _discovery;
  Registration? _registration;

  // Stores the secret for each paired device (syncId -> secret)
  final Map<String, String> _pairedDevices = {};

  SyncService(this.db);

  Future<void> startServer() async {
    final router = Router();

    router.get('/ping', (Request request) => Response.ok('pong'));

    router.post('/sync', (Request request) async {
      final body = await request.readAsString();
      final data = jsonDecode(body);
      final deviceSyncId = data['syncId'];
      final encryptedPayload = data['payload'];

      final secret = _pairedDevices[deviceSyncId];
      if (secret == null) return Response.forbidden('Unauthorized');

      final decrypted = await _security.decryptFromSync(encryptedPayload, secret);
      // Logic to merge data into db goes here

      return Response.ok(jsonEncode({'status': 'synced'}));
    });

    _server = await io.serve(router, InternetAddress.anyIPv4, 0);
    _registration = await register(Service(
      name: 'VaultMesh-${Platform.localHostname}',
      type: '_vaultmesh._tcp',
      port: _server!.port,
    ));
  }

  Future<void> discoverAndSync() async {
    _discovery = await startDiscovery('_vaultmesh._tcp');
    _discovery!.addListener(() async {
      for (final service in _discovery!.services) {
        if (service.host != null && service.port != null) {
          // Check if this is a known device and trigger sync if needed
        }
      }
    });
  }

  Future<void> stop() async {
    await _registration?.dispose();
    await _discovery?.dispose();
    await _server?.close();
  }
}
