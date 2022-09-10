import 'package:loja_virtual/src/constants/endpoints.dart';
import 'package:loja_virtual/src/models/user_model.dart';
import 'package:loja_virtual/src/pages/auth/repository/auth_errors.dart';
import 'package:loja_virtual/src/pages/auth/result/auth_result.dart';
import 'package:loja_virtual/src/services/http_manager.dart';

class AuthRepository {
  final HttpManager _httpManager = HttpManager();

  AuthResult handleUserOrError(Map<dynamic, dynamic> result) {
    if (result['result'] != null) {
      final user = UserModel.fromJson(result['result']);

      return AuthResult.success(user);
    } else {
      var authErrorString = authErrorsString(result['error']);

      return AuthResult.error(authErrorString);
    }
  }

  Future<AuthResult> validateToken(String token) async {
    var result = await _httpManager.restRequest(
        url: Endpoints.validateToken,
        method: HttpMethods.post,
        headers: {'X-Parse-Session-Token': token});

    if (result['result'] != null) {
      final user = UserModel.fromJson(result['result']);

      return AuthResult.success(user);
    } else {
      return AuthResult.error(authErrorsString(result['error']));
    }
  }

  Future<AuthResult> signIn(
      {required String email, required String password}) async {
    final result = await _httpManager.restRequest(
        url: Endpoints.signIn,
        method: HttpMethods.post,
        body: {"email": email, "password": password});

    //Passou durante a autenticação
    return handleUserOrError(result);
  }

  Future<AuthResult> signUp(UserModel model) async {
    var result = await _httpManager.restRequest(
      url: Endpoints.signUp,
      method: HttpMethods.post,
      body: model.toJson(),
    );

    return handleUserOrError(result);
  }

  Future<void> resetPassword(String email) async {
    await _httpManager.restRequest(
      url: Endpoints.resetPassword,
      method: HttpMethods.post,
      body: {'email': email},
    );
  }
}
