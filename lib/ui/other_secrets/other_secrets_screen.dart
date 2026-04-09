import 'package:flutter/material.dart';

class OtherSecretsScreen extends StatelessWidget {
  const OtherSecretsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Other Secrets Vault')),
      body: const Center(child: Text('Manage your other secrets here.')),
    );
  }
