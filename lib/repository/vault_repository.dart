import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vaultmesh_flutter_x/database/database.dart';
import 'package:vaultmesh_flutter_x/main.dart';
import 'package:vaultmesh_flutter_x/security/auth_state.dart';

class VaultRepository {
  final AppDatabase db;
  final Ref ref;

  VaultRepository(this.db, this.ref);

  Future<List<VaultItem>> getAllItems() async {
    return await db.select(db.vaultItems).get();
  }

  Future<void> addItem(String title, String type, String rawData) async {
    final auth = ref.read(authProvider);
    if (auth.masterKey == null) return;

    final encryption = ref.read(encryptionServiceProvider);
    final encrypted = await encryption.encrypt(rawData, auth.masterKey!);

    await db.into(db.vaultItems).insert(VaultItemsCompanion.insert(
      title: title,
      type: type,
      encryptedData: encrypted,
    ));
  }
}

final vaultRepositoryProvider = Provider((ref) {
  final db = ref.watch(databaseProvider);
  return VaultRepository(db, ref);
});
