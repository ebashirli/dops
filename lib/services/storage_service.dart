abstract class StorageService<T> {
  // Future<Map> find(int id);
  Stream<List<Map<T, T>>> getAll();
  Future<int> insert(Map map);
  Future<void> update(Map map);
  // Future<String> delete(Map map);
  Future<void> deleteById(String id);
}
