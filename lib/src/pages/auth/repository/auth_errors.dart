String authErrorsString(String? code) {
  switch (code) {
    case 'INVALID_CREDENTIALS':
      return 'Email e/ou senha inválidos';
    case 'Invalid session token':
      return 'Token expirado';
    case 'INVALID_USERNAME':
      return 'Ocorreu um erro ao cadastrar um usuário: Nome inválido';
    case 'INVALID_PHONE':
      return 'Ocorreu um erro ao cadastrar um usuário: Celular inválido';
    case 'INVALID_CPF':
      return 'Ocorreu um erro ao cadastrar um usuário: CPF inválido';
    default:
      return 'Error interno do servidor';
  }
}
