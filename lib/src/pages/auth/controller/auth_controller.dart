import 'package:get/get.dart';
import 'package:loja_virtual/src/models/user_model.dart';
import 'package:loja_virtual/src/pages/auth/repository/auth_repository.dart';
import 'package:loja_virtual/src/pages_routes/app_pages.dart';
import 'package:loja_virtual/src/services/utils_services.dart';

class AuthController extends GetxController {
  RxBool isLoading = false.obs;

  final AuthRepository _authRepository = AuthRepository();
  final UtilsServices _utilsServices = UtilsServices();

  UserModel user = UserModel();

  Future<void> signIn({required String email, required String password}) async {
    isLoading.value = true;

    var authResult =
        await _authRepository.signIn(email: email, password: password);

    isLoading.value = false;

    authResult.when(
      success: (s) {
        user = s;

        Get.offAllNamed(PageRoutes.baseRoute);
      },
      error: (e) {
        _utilsServices.showToast(
          message: e,
          isError: true,
        );
      },
    );
  }
}
