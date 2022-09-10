import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:loja_virtual/src/constants/storage_keys.dart';
import 'package:loja_virtual/src/models/user_model.dart';
import 'package:loja_virtual/src/pages/auth/repository/auth_repository.dart';
import 'package:loja_virtual/src/pages/auth/result/auth_result.dart';
import 'package:loja_virtual/src/pages_routes/app_pages.dart';
import 'package:loja_virtual/src/services/utils_services.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;

  final AuthRepository _authRepository = AuthRepository();
  final UtilsServices _utilsServices = UtilsServices();

  UserModel user = UserModel();

  Future<void> validateToken() async {
    String? token = await _utilsServices.getLocalData(key: StorageKeys.token);

    if (token == null) {
      Get.offAllNamed(PageRoutes.signInRoute);
      return;
    }

    AuthResult result = await _authRepository.validateToken(token);

    result.when(
      success: (s) {
        user = s;

        saveTokenAndProceedToBase();
      },
      error: (e) {
        signOut();
      },
    );
  }

  Future<void> signOut() async {
    user = UserModel();

    await _utilsServices.removeLocalData(key: StorageKeys.token);

    Get.offAllNamed(PageRoutes.signInRoute);
  }

  void saveTokenAndProceedToBase() {
    _utilsServices.saveLocalData(key: StorageKeys.token, data: user.token!);

    Get.offAllNamed(PageRoutes.baseRoute);
  }

  Future<void> signUp() async {
    isLoading.value = true;

    var registerResult = await _authRepository.signUp(user);

    isLoading.value = false;

    registerResult.when(
      success: (user) {
        this.user = user;

        saveTokenAndProceedToBase();
      },
      error: (error) {
        _utilsServices.showToast(
          message: error,
          isError: true,
        );
      },
    );
  }

  Future<void> signIn({required String email, required String password}) async {
    isLoading.value = true;

    var authResult =
        await _authRepository.signIn(email: email, password: password);

    isLoading.value = false;

    authResult.when(
      success: (s) {
        user = s;

        saveTokenAndProceedToBase();
      },
      error: (e) {
        _utilsServices.showToast(
          message: e,
          isError: true,
        );
      },
    );
  }

  Future<void> resetPassword(String email) async {
    await _authRepository.resetPassword(email);
  }
}
