import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaultmesh_flutter_x/ui/login/login_screen.dart';
import 'package:vaultmesh_flutter_x/utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: VaultMeshApp()));
}

class VaultMeshApp extends StatelessWidget {
  const VaultMeshApp({super.key});

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