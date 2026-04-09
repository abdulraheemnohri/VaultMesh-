import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Change Master Password'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Enable Biometric Authentication'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: const Text('Auto-lock Timer'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Clipboard Auto-clear'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: const Text('Screenshot Protection'),
            trailing: Switch(
              value: false,
              onChanged: (value) {},
            ),
          ),
          ListTile(
            title: const Text('Export Backup'),
            onTap: () {},
          ),
          ListTile(
            title: const Text('Import Backup'),
            onTap: () {},
          ),
        ],
      ),
    );
  }
