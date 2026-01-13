// fonction de detection d'acceptabilité des mot de passe ----------
String evaluatePasswordStrength(String password) {
  if (password.length < 6) return "Faible";
  final hasUppercase = password.contains(RegExp(r'[A-Z]'));
  final hasDigits = password.contains(RegExp(r'\d'));
  final hasSpecialChars = password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  if (password.length >= 10 && hasUppercase && hasDigits && hasSpecialChars) {
    return "Fort";
  } else if ((hasUppercase && hasDigits) || hasSpecialChars) {
    return "Moyen";
  } else {
    return "Faible";
  }
}
