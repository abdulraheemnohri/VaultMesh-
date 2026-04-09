import 'package:flutter/material.dart';
import 'package:vaultmesh_flutter_x/utils/qr_sync.dart';
import 'package:vaultmesh_flutter_x/utils/local_sync.dart';

class SyncScreen extends StatefulWidget {
  const SyncScreen({super.key});

  @override
  State<SyncScreen> createState() => _SyncScreenState();
}

class _SyncScreenState extends State<SyncScreen> {
  String? scannedDeviceIp;
  String? scannedDeviceId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sync Devices')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            const SizedBox(height: 20),
            if (scannedDeviceIp != null)
              Text('Connected to: $scannedDeviceIp'),
          ],
        ),
      ),
    );
  }
}