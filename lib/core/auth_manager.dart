import 'package:dops/constants/constant.dart';
import 'package:dops/core/cache_manager.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:dops/modules/staff/staff_repository.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthManager extends GetxService with CacheManager {
  static final AuthManager instance = Get.find();
  RxBool isLoading = false.obs;
  final staffRepository = Get.find<StaffRepository>();
  Rx<StaffModel?> logedInStaff = Rxn<StaffModel>();
  UserCredential? userCredential;

  Future<UserCredential?> register(String email, password) async {
    try {
      return await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (firebaseAuthException) {}
    return null;
  }

  Future<void> login(String email, password) async {
    isLoading.value = true;
    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (auth.currentUser != null) initializeStaffModel();
    } catch (firebaseAuthException) {
      print(firebaseAuthException);
    }

    isLoading.value = false;
  }

  Future<void> initializeStaffModel() async {
    logedInStaff.value = staffController.getById(auth.currentUser!.uid);
    saveID(auth.currentUser!.uid);
    saveStaff(logedInStaff.value!);
  }

  void signOut() async {
    await auth.signOut();
    removeStaff();
    removeID();
    Get.offAndToNamed(Routes.SPLASH);
  }
}
