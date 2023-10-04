//Services para poder cambiar si más adelante se quiere SQLite
//abs si yo quiero cambiar la implementación tiene que cumplir las siguientes relgas
import 'key_value_storage_services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  @override
  Future<T?> getValue<T>(String key) async {
    final String? stringValue = await _secureStorage.read(key: key);

    if (stringValue == null) {
      return null;
    }

    switch (T) {
      case int:
        return int.tryParse(stringValue) as T?;
      case String:
        return stringValue as T?;
      case bool:
        return (stringValue == 'true') as T?;
      default:
        throw UnimplementedError('GET Type not supported ${T.runtimeType}');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    await _secureStorage.delete(key: key);
    //Note by SG: flutter_secure_storage does not return a bool, assume true upon successful delete
    return true; 
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    String stringValue;
    switch (T) {
      case int:
        stringValue = value.toString();
        break;
      case String:
        stringValue = value as String;
        break;
      case bool:
        stringValue = (value as bool).toString();
        break;
      default:
        throw UnimplementedError('SET Type not supported ${T.runtimeType}');
    }
    await _secureStorage.write(key: key, value: stringValue);
  }
}
