// ValidatorHelper: A utility class for validating user input.
abstract class ValidatorHelper {
  // Regular expression pattern for validating email addresses.
  static final RegExp kEmail = RegExp(
      r"^[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?");

  // Validates an email address.
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

  // Validates a password.
  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return "Por favor, entre com sua senha!";
    }

    return null;
  }
}
