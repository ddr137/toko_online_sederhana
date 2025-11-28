import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:toko_online_sederhana/core/clients/storage/shared_preferences_client.dart';
import 'package:toko_online_sederhana/core/db/app_database.dart';

part 'providers.g.dart';

@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
}

@Riverpod(keepAlive: true)
SharedPreferencesClient sharedPreferencesClient(Ref ref) =>
    SharedPreferencesClient();

