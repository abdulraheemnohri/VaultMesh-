import 'package:flutter/material.dart';
import 'package:vaultmesh_flutter_x/repository/vault_repository.dart';
import 'package:vaultmesh_flutter_x/security/encryption_manager.dart';
import 'dart:convert';

class EmailAccountsScreen extends StatefulWidget {
  const EmailAccountsScreen({super.key});

  @override
  State<EmailAccountsScreen> createState() => _EmailAccountsScreenState();
}

class _EmailAccountsScreenState extends State<EmailAccountsScreen> {
  final _vaultRepository = VaultRepository();
  final _encryptionManager = EncryptionManager(Key.fromUtf8('32-length-secret-key...'), IV.fromLength(16));
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _notesController = TextEditingController();

  List<Map<String, dynamic>> _emailAccounts = [];

  @override
  void initState() {
    super.initState();
    _loadEmailAccounts();
  }

  Future<void> _loadEmailAccounts() async {
    final accounts = await _vaultRepository.getAllData();
    setState(() {
      _emailAccounts = accounts.entries
          .where((entry) => entry.key.startsWith('email_'))
          .map((entry) => {
            'id': entry.key,
            'email': jsonDecode(entry.value)['email'],
            'password': jsonDecode(entry.value)['password'],
            'notes': jsonDecode(entry.value)['notes'],
          })
          .toList();
    });
  }

  Future<void> _addEmailAccount() async {
    if (_formKey.currentState!.validate()) {
      final emailAccount = {
        'email': _emailController.text,
        'password': _passwordController.text,
        'notes': _notesController.text,
      };

      final encryptedData = _encryptionManager.encrypt(jsonEncode(emailAccount));
      final key = 'email_${DateTime.now().millisecondsSinceEpoch}';
      await _vaultRepository.saveItem(key, encryptedData);

      _emailController.clear();
      _passwordController.clear();
      _notesController.clear();
      await _loadEmailAccounts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Email Accounts')),
      body: Column(
        children: [
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                    validator: (value) => value!.isEmpty ? 'Enter email' : null,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) => value!.isEmpty ? 'Enter password' : null,
                  ),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(labelText: 'Notes'),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _addEmailAccount,
                    child: const Text('Add Email Account'),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _emailAccounts.length,
              itemBuilder: (context, index) {
                final account = _emailAccounts[index];
                return ListTile(
                  title: Text(account['email']),
                  subtitle: Text(account['notes']),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {
                      await _vaultRepository.deleteItem(account['id']);
                      await _loadEmailAccounts();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}