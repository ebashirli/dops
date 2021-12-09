import 'package:dops/constants/constant.dart';
import 'package:dops/core/cache_manager.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:dops/modules/staff/staff_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthManager extends GetxService with CacheManager {
  static final AuthManager instance = Get.find();
  RxBool isLoading = false.obs;
  final staffRepository = Get.find<StaffRepository>();
  Rx<StaffModel?> staffModel = Rxn<StaffModel>();
  UserCredential? userCredential;
  Future<UserCredential?> register(String email, password) async {
    try {
      return await auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (firebaseAuthException) {}
  }

  Future<void> login(String email, password) async {
    isLoading.value = true;
    try {
      if (staffController.documents.where((element) => element.email == email).isNotEmpty)
        await auth.signInWithEmailAndPassword(email: email, password: password);
      initializeStaffModel();
    } catch (firebaseAuthException) {}
    isLoading.value = false;
  }

  Future<void> initializeStaffModel() async {
    staffModel.value = staffController.documents.singleWhere((element) => element.id == auth.currentUser!.uid);
  }

  void signOut() async {
    await auth.signOut();
  }
}
