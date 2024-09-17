import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AppEncryptedStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

/*  IOSOptions _getIOSOptions() => const IOSOptions(
        accountName: "flutter_secure_storage_service",
      );

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );*/

  Future<void> addItem({required String key, required String value}) async {
    await _storage.write(
      key: key,
      value: value,
    );
  }

  Future<String?> readItem({required String key}) async {
    return await _storage.read(key: key);
  }

  Future<void> deleteItem({required String key}) async {
    await _storage.delete(key: key);
  }
}
