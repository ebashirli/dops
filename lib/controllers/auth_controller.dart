import 'package:dops/constants/constant.dart';
import 'package:dops/enum.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:dops/modules/staff/staff_repository.dart';
import 'package:dops/routes/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  final staffRepository = Get.find<StaffRepository>();
  late Rx<User?> firebaseUser;
  late Rx<UserRole?> userRole = UserRole.User.obs;
  @override
  onReady() {
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());
    ever(firebaseUser, _setInitialScreen);
  }

  _setInitialScreen(User? user) async {
    if (user == null) {
      // if the user is not found then the user is navigated to the Register Screen
      Get.offAndToNamed(Routes.LOGIN);
    } else {
      // if the user exists and logged in the the user is navigated to the Home Screen
      StaffModel userModel = await staffRepository.getModelById(user.uid);
      switch (userModel.systemDesignation) {
        case 'Coordinator':
          userRole.value = UserRole.Coordinator;
          break;
        case 'Admin':
          userRole.value = UserRole.Admin;
          break;
        default:
          userRole.value = UserRole.User;
      }
      print(userRole);
      Get.offAndToNamed(Routes.HOME, parameters: {'id': user.uid});
    }
  }

  Future<UserCredential?> register(String email, password) async {
    try {
      return await auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (firebaseAuthException) {}
  }

  Future<void> login(String email, password) async {
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (firebaseAuthException) {}
  }

  void signOut() async {
    await auth.signOut();
  }
}
