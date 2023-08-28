//Services para poder cambiar si más adelante se quiere SQLite
//abs si yo quiero cambiar la implementación tiene que cumplir las siguientes relgas
abstract class KeyValueStorageService {
  Future<void> setKeyValue<T>(String key, T value);
  Future<T?> getValue<T>(String key);
  Future<bool> removeKey(String key);
}