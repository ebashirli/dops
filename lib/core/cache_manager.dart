import 'package:dops/components/extentions.dart';
import 'package:dops/enum.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CacheManager extends GetxService {
  static final CacheManager instance = Get.find();
  final box = GetStorage();

  Future<void> saveStaff(StaffModel staffModel) async =>
      await box.write(CacheManagerKey.STAFF.toString(), staffModel.toMap());

  StaffModel? getStaff() {
    Map<String, dynamic>? logedInStaff =
        box.read(CacheManagerKey.STAFF.toString()) as Map<String, dynamic>?;

    return logedInStaff != null
        ? StaffModel.fromMap(
            logedInStaff,
            getID(),
          )
        : null;
  }

  Future<void> removeStaff() async =>
      await box.remove(CacheManagerKey.STAFF.toString());

  Future<void> savePassword(String password) async =>
      await box.write(CacheManagerKey.PASSWORD.toString(), password);

  String? getPassword() => box.read(CacheManagerKey.PASSWORD.toString());

  Future<void> saveEmail(String email) async =>
      await box.write(CacheManagerKey.EMAIL.toString(), email);

  String? getEmail() => box.read(CacheManagerKey.EMAIL.toString());

  Future<void> saveID(String id) async =>
      await box.write(CacheManagerKey.ID.toString(), id);

  String? getID() {
    String? id = box.read(CacheManagerKey.ID.toString());
    return id;
  }

  Future<void> removeID() async =>
      await box.remove(CacheManagerKey.ID.toString());

  Future<void> saveHomeState(HomeStates homeState) async {
    await box.write(CacheManagerKey.HOMESTATE.toString(), homeState.toString());
  }

  String? getHomeState() => box.read(CacheManagerKey.HOMESTATE.toString());

  Future<void> saveValueModelIds(List<String?> valueModelIds) async =>
      await box.write(CacheManagerKey.VALUEMODELIDS.toString(), valueModelIds);

  List getValueModelIds() {
    List? valueModelIds = box.read(CacheManagerKey.VALUEMODELIDS.toString());
    return valueModelIds ?? [];
  }

  Future<void> removevalueModelIds() async =>
      await box.remove(CacheManagerKey.VALUEMODELIDS.toString());
}

enum CacheManagerKey {
  EMAIL,
  PASSWORD,
  STAFF,
  ID,
  HOMESTATE,
  VALUEMODELIDS,
}
