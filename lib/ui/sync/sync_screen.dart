import 'package:flutter/material.dart';
import 'package:vaultmesh_flutter_x/utils/qr_sync.dart';
import 'package:vaultmesh_flutter_x/utils/local_sync.dart';
import 'package:vaultmesh_flutter_x/utils/local_sync_server.dart';
import 'package:vaultmesh_flutter_x/security/encryption_manager.dart';
import 'package:vaultmesh_flutter_x/repository/vault_repository.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  String? scannedDeviceIp;
  String? scannedDeviceId;
  bool _isServerRunning = false;
  final _deviceIdController = TextEditingController(text: 'device_${DateTime.now().millisecondsSinceEpoch}');
  final _encryptionManager = EncryptionManager(Key.fromUtf8('32-length-secret-key...'), IV.fromLength(16));
  final _vaultRepository = VaultRepository();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sync Devices')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _deviceIdController,
              decoration: const InputDecoration(labelText: 'Device ID'),
              readOnly: true,
            ),
            const SizedBox(height: 10),
            QRSync.buildQRCode(_deviceIdController.text, '192.168.1.100'), // آپ کا لوکل IP یہاں آئے گا
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (!_isServerRunning) {
                  await LocalSyncServer.startServer(
                    deviceId: _deviceIdController.text,
                    encryptionManager: _encryptionManager,
                    vaultRepository: _vaultRepository,
                  );
                  setState(() => _isServerRunning = true);
                }
              },
              child: Text(_isServerRunning ? 'Server Running' : 'Start Sync Server'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final qrData = await QRSync.scanQRCode();
                if (qrData != null) {
                  final parts = qrData.split(':');
                  if (parts.length == 4) {
                    setState(() {
                      scannedDeviceIp = parts[3];
                      scannedDeviceId = parts[2];
                    });
                    await LocalSync.syncWithDevice(scannedDeviceIp!, scannedDeviceId!);
                  }
                }
              },
              child: const Text('Scan QR Code to Sync'),
            ),
            if (scannedDeviceIp != null) Text('Connected to: $scannedDeviceIp'),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    LocalSyncServer.stopServer();
    super.dispose();
  }
}