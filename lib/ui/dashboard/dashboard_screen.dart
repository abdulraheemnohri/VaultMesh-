import 'package:flutter/material.dart';
import 'package:vaultmesh_flutter_x/ui/passwords/passwords_screen.dart';
import 'package:vaultmesh_flutter_x/ui/notes/notes_screen.dart';
import 'package:vaultmesh_flutter_x/ui/documents/documents_screen.dart';
import 'package:vaultmesh_flutter_x/ui/api_keys/api_keys_screen.dart';
import 'package:vaultmesh_flutter_x/ui/links/links_screen.dart';
import 'package:vaultmesh_flutter_x/ui/other_secrets/other_secrets_screen.dart';
import 'package:vaultmesh_flutter_x/ui/settings/settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    PasswordsScreen(),
    NotesScreen(),
    DocumentsScreen(),
    ApiKeysScreen(),
    LinksScreen(),
    OtherSecretsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VaultMesh Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.password), label: 'Passwords'),
          BottomNavigationBarItem(icon: Icon(Icons.note), label: 'Notes'),
          BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Documents'),
          BottomNavigationBarItem(icon: Icon(Icons.key), label: 'API Keys'),
          BottomNavigationBarItem(icon: Icon(Icons.link), label: 'Links'),
          BottomNavigationBarItem(icon: Icon(Icons.security), label: 'Secrets'),
        ],
      ),
    );
  }
}