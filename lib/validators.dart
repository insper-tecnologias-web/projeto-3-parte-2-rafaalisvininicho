class Validator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Preencha o Campo';
    }
    if (!value.contains('@')) {
      return 'Email inválido';
    }
    final emailAddresses = value.split(',').map((e) => e.trim());

    if (emailAddresses.length == 1) {
      final emailRegex =
          RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
      if (!emailRegex.hasMatch(emailAddresses.first)) {
        return "Email inválido, digite novamente";
      }
    } else {
      return "Apenas um email deve ser informado";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Preencha o Campo';
    }
    if (value.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }
    return null;
  }
}
