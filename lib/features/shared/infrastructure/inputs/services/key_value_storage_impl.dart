//Services para poder cambiar si más adelante se quiere SQLite
//abs si yo quiero cambiar la implementación tiene que cumplir las siguientes relgas
import 'package:shared_preferences/shared_preferences.dart';
import 'key_value_storage_services.dart';

class KeyValueStorageServiceImpl extends KeyValueStorageService {
  Future<SharedPreferences> getSharePrefs() async {
    return await SharedPreferences.getInstance();
  }

  @override
  Future<T?> getValue<T>(String key) async {
    final prefs = await getSharePrefs();
    switch (T) {
      case int:
        return prefs.getInt(key) as T?;
      case String:
        return prefs.getString(key) as T?;

      default:
        throw UnimplementedError('GET Type not supported ${T.runtimeType}');
    }
  }

  @override
  Future<bool> removeKey(String key) async {
    final prefs = await getSharePrefs();
    return await prefs.remove(key);
  }

  @override
  Future<void> setKeyValue<T>(String key, T value) async {
    final prefs = await getSharePrefs();
    switch (T) {
      case int:
        prefs.setInt(key, value as int);
        break;
      case String:
        prefs.setString(key, value as String);
        break;

      default:
        throw UnimplementedError('SET Type not supported ${T.runtimeType}');
    }
  }
}
