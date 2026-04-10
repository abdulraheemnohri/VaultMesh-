import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:uuid/uuid.dart';

part 'database.g.dart';

class VaultItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get syncId => text().clientDefault(() => const Uuid().v4())();
  TextColumn get type => text()();
  TextColumn get encryptedData => text()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get folderId => integer().nullable().references(Folders, #id)();
  TextColumn get title => text().withLength(min: 1, max: 255)();
  TextColumn get tags => text().nullable()();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

class Folders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get syncId => text().clientDefault(() => const Uuid().v4())();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  BoolColumn get isDeleted => boolean().withDefault(const Constant(false))();
}

class Devices extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get deviceId => text()();
  TextColumn get deviceName => text()();
  TextColumn get publicKey => text()();
  DateTimeColumn get lastSync => dateTime().nullable()();
}

@DriftDatabase(tables: [VaultItems, Folders, Devices])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'vault.db'));
    return NativeDatabase(file);
  });
}
