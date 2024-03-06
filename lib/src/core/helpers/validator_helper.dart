abstract class ValidatorHelper {
  static final RegExp kEmail = RegExp(
      r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Por favor, entre com seu email!";
    }
    if (!kEmail.hasMatch(value)) {
      return "E-mail inválido!";
    }
    if (value.contains(" ")) {
      return "Por favor remover espaços!";
    }

    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Por favor, entre com sua senha!";
    }

    return null;
  }
}
