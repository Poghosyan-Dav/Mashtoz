import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const accessToken = 'access_token';
  static const refreshToken = 'refresh_token';
  static const cutsomerId = 'customer_id';
}

class SessionDataProvider {
  final _storage = const FlutterSecureStorage();
  Future<void> setAccessToken(String value) async {
    final storage = await _storage;
    storage.write(key: _Keys.accessToken, value: value);
  }

  Future<String?> readsAccessToken() async {
    final storage = await _storage;
    return storage.read(key: _Keys.accessToken);
  }

  Future<void> setRefreshToken(String value) async {
    final storage = await _storage;
    storage.write(key: _Keys.refreshToken, value: value);
  }

  Future<String?> readRefreshToken() async {
    final storage = await _storage;
    return storage.read(key: _Keys.refreshToken);
  }

  Future<void> setCustomerId(int value) async {
    final storage = await _storage;
    storage.write(key: _Keys.cutsomerId, value: value.toString());
  }

  Future<String?> readCustomerId() async {
    final storage = await _storage;
    return storage.read(key: _Keys.cutsomerId);
  }

  deleteAllToken() async {
    final storage = await _storage;
    storage.deleteAll();
  }

  void setRegtoken(token) {}
}
