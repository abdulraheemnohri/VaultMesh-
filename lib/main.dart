import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaultmesh_flutter_x/ui/login/login_screen.dart';
import 'package:vaultmesh_flutter_x/utils/theme.dart';
import 'package:vaultmesh_flutter_x/utils/auto_update_checker.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();

  runApp(const ProviderScope(child: VaultMeshApp()));
}

class VaultMeshApp extends StatefulWidget {
  const VaultMeshApp({super.key});

  @override
  State<VaultMeshApp> createState() => _VaultMeshAppState();
}

class _VaultMeshAppState extends State<VaultMeshApp> {
  @override
  void initState() {
    super.initState();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    await Future.delayed(const Duration(seconds: 3)); // ایپ شروع ہونے کا انتظار کریں
    final updateAvailable = await AutoUpdateChecker.isUpdateAvailable();
    if (updateAvailable && mounted) {
      AutoUpdateChecker.showUpdateDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VaultMesh X',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const LoginScreen(),
    );
  }
}