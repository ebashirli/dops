import 'package:dops/models/base_model.dart';

abstract class StorageService {
  Future<void> create(BaseModel model);
  Future<Map<String, dynamic>> retrieve();
  Future<void> update(String id, dynamic value);
  Future<void> delete(id);
}
