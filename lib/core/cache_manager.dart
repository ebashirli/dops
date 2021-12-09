import 'package:get_storage/get_storage.dart';

mixin CacheManager {
  Future<void> saveEmail(String email) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.EMAIL.toString(), email);
  }

  Future<void> savePassword(String password) async {
    final box = GetStorage();
    await box.write(CacheManagerKey.PASSWORD.toString(), password);
  }

  String? getEmail() {
    final box = GetStorage();
    return box.read(CacheManagerKey.EMAIL.toString());
  }

  String? getPassword() {
    final box = GetStorage();
    return box.read(CacheManagerKey.PASSWORD.toString());
  }

  // Future<void> removeStaff() async {
  //   final box = GetStorage();
  //   await box.remove(CacheManagerKey.STAFF.toString());
  // }

}

enum CacheManagerKey { EMAIL, PASSWORD }
