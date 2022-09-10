import 'package:get/get.dart';

bool isEmail(String em) {
  String p =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

  RegExp regExp = RegExp(p);

  return regExp.hasMatch(em);
}

String? emailValidator(email) {
  if (email == null || email.isEmpty) {
    return 'Digite seu email!';
  }

  if (!isEmail(email)) {
    return 'Digite um email válido';
  }
  return null;
}

String? passwordValidator(password) {
  if (password == null || password.isEmpty) {
    return 'Digite sua senha';
  }

  if (password.length < 7) {
    return 'Digite uma senha com pelo menos 7 dígitos';
  }

  return null;
}

String? nameValidator(String? name) {
  if (name == null || name.isEmpty) {
    return 'Digite um nome';
  }

  var isACompostName = name.split(' ').length > 1;
  if (isACompostName == false) {
    return 'Digite seu nome e sobrenome';
  }

  return null;
}

String? phoneValidator(String? phoneNumber) {
  if (phoneNumber == null || phoneNumber.isEmpty) {
    return 'Digite seu número';
  }

  if (phoneNumber.length < 12 || !phoneNumber.isPhoneNumber) {
    return 'Digite um número de telefone válido';
  }

  return null;
}

String? cpfValidator(String? cpf) {
  if (cpf == null || cpf.isEmpty) {
    return 'Digite seu CPF';
  }

  if (!cpf.isCpf) {
    return 'Digite um CPF válido';
  }

  return null;
}
