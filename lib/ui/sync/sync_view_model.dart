import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:vaultmesh_flutter_x/security/sync_security_service.dart';

class SyncState {
  final String? pairingCode;
  final bool isScanning;
  final List<String> linkedDevices;

  SyncState({this.pairingCode, this.isScanning = false, this.linkedDevices = const []});
}

class SyncNotifier extends StateNotifier<SyncState> {
  SyncNotifier() : super(SyncState());

  final _info = NetworkInfo();
  final _security = SyncSecurityService();

  Future<void> preparePairing() async {
    final ip = await _info.getWifiIP();
    if (ip == null) return;

    final data = _security.generatePairingData(ip, 8080); // Port will be dynamic in real app
    state = SyncState(pairingCode: jsonEncode(data));
  }
}

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) => SyncNotifier());
