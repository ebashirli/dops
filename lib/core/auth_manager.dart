import 'package:dops/constants/constant.dart';
import 'package:dops/modules/staff/staff_model.dart';
import 'package:dops/modules/staff/staff_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../enum.dart';

class AuthManager extends GetxService {
  static final AuthManager instance = Get.find();
  RxBool isLoading = false.obs;
  final staffRepository = Get.find<StaffRepository>();
  late Rx<StaffModel?> userModel;

  Future<UserCredential?> register(String email, password) async {
    try {
      return await auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (firebaseAuthException) {}
  }

  Future<void> login(String email, password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);

      userModel.value = await staffRepository.getModelById(userCredential.user!.uid);
    } catch (firebaseAuthException) {}
  }

  void signOut() async {
    await auth.signOut();
  }
}
