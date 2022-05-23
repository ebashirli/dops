import 'package:dops/modules/staff/staff_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CacheManager extends GetxService {
  static final CacheManager instance = Get.find();
  final box = GetStorage();

  Future<void> saveStaff(StaffModel staffModel) async =>
      await box.write(CacheManagerKey.STAFF.toString(), staffModel.toMap());

  StaffModel? get getStaff {
    Map<String, dynamic>? logedInStaff =
        box.read(CacheManagerKey.STAFF.toString()) as Map<String, dynamic>?;

    return logedInStaff != null
        ? StaffModel.fromMap(
            logedInStaff,
            getID,
          )
        : null;
  }

  Future<void> removeStaff() async =>
      await box.remove(CacheManagerKey.STAFF.toString());

  Future<void> savePassword(String password) async =>
      await box.write(CacheManagerKey.PASSWORD.toString(), password);

  String? get getPassword => box.read(CacheManagerKey.PASSWORD.toString());

  Future<void> saveEmail(String email) async =>
      await box.write(CacheManagerKey.EMAIL.toString(), email);

  String? get getEmail => box.read(CacheManagerKey.EMAIL.toString());

  Future<void> saveID(String id) async =>
      await box.write(CacheManagerKey.ID.toString(), id);

  String? get getID => box.read(CacheManagerKey.ID.toString());

  Future<void> removeID() async =>
      await box.remove(CacheManagerKey.ID.toString());

  Future<void> saveSelectedIndex(int index) async =>
      await box.write(CacheManagerKey.INDEX.toString(), index);

  int? get getIndex => box.read(CacheManagerKey.INDEX.toString());

  Future<void> removevalueModelIds() async =>
      await box.remove(CacheManagerKey.VALUEMODELIDS.toString());
}

enum CacheManagerKey {
  EMAIL,
  PASSWORD,
  STAFF,
  ID,
  INDEX,
  VALUEMODELIDS,
}
