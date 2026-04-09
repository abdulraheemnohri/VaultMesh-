import 'package:flutter/material.dart';
import 'package:vaultmesh_flutter_x/repository/vault_repository.dart';
import 'dart:convert';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final _vaultRepository = VaultRepository();
  final _categoryController = TextEditingController();
  List<String> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final categories = await _vaultRepository.getItem('categories');
    setState(() {
      _categories = categories != null ? List<String>.from(jsonDecode(categories)) : [];
    });
  }

  Future<void> _addCategory() async {
    if (_categoryController.text.isNotEmpty) {
      _categories.add(_categoryController.text);
      await _vaultRepository.saveItem('categories', jsonEncode(_categories));
      _categoryController.clear();
      await _loadCategories();
    }
  }

  Future<void> _deleteCategory(int index) async {
    _categories.removeAt(index);
    await _vaultRepository.saveItem('categories', jsonEncode(_categories));
    await _loadCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Categories Management')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _categoryController,
                    decoration: const InputDecoration(labelText: 'Category Name'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addCategory,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_categories[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteCategory(index),
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