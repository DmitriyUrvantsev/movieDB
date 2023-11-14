import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const sessionId = 'session_id';
  static const accountId = 'account_id';
}

class SessionDataProvider {
  static const _secureStorage = FlutterSecureStorage();

//?------------------------------------
  Future<String?> getSessionId() => _secureStorage.read(key: _Keys.sessionId);
  //!получить sessionId

  Future<void> setSessionId(String? value) {
    //!записать или удальть essionId
    if (value != null) {
      return _secureStorage.write(key: _Keys.sessionId, value: value);
    } else {
      return _secureStorage.delete(key: _Keys.sessionId);
    }
  }
//?-----------------------------------

//?------------------------------------
  Future<String?> getAccountId() => _secureStorage.read(key: _Keys.accountId);
  //!получить sessionId

  Future<void> setAccountId(String? value) {
    //!записать или удальть essionId
    if (value != null) {
      return _secureStorage.write(key: _Keys.accountId, value: value);
    } else {
      return _secureStorage.delete(key: _Keys.accountId);
    }
  }
//?-----------------------------------
}
