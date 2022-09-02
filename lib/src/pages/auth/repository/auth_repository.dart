import 'package:loja_virtual/src/constants/endpoints.dart';
import 'package:loja_virtual/src/models/user_model.dart';
import 'package:loja_virtual/src/pages/auth/repository/auth_errors.dart';
import 'package:loja_virtual/src/pages/auth/result/auth_result.dart';
import 'package:loja_virtual/src/services/http_manager.dart';

class AuthRepository {
  final HttpManager _httpManager = HttpManager();

  Future<AuthResult> signIn(
      {required String email, required String password}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.signIn,
        method: HttpMethods.post,
        body: {"email": email, "password": password});

    //Passou durante a autenticação
    if (result['result'] != null) {
      final user = UserModel.fromJson(result['result']);

      return AuthResult.success(user);
    } else {
      var authErrorString = authErrorsString(result['error']);

      return AuthResult.error(authErrorString);
    }
  }
}
