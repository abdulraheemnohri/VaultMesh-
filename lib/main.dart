import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaultmesh_flutter_x/database/database.dart';
import 'package:vaultmesh_flutter_x/security/auth_state.dart';
import 'package:vaultmesh_flutter_x/security/encryption_service.dart';
import 'package:vaultmesh_flutter_x/ui/login/login_screen.dart';
import 'package:vaultmesh_flutter_x/ui/dashboard/dashboard_screen.dart';

final databaseProvider = Provider((ref) => AppDatabase());
final encryptionServiceProvider = Provider((ref) => EncryptionService());

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const ProviderScope(
      child: VaultMeshApp(),
    ),
  );
}

class VaultMeshApp extends ConsumerWidget {
  const VaultMeshApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);

    Widget home;
    if (authState.status == AuthStatus.authenticated) {
      home = const DashboardScreen();
    } else if (authState.status == AuthStatus.initial) {
      home = const Scaffold(body: Center(child: CircularProgressIndicator()));
    } else {
      home = const LoginScreen();
    }

    return MaterialApp(
      title: 'VaultMesh Flutter X',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
      ),
      home: home,
    );
  }
}
