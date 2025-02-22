class AppCustomWidgets {
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter your full name";
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter your email";
    } else if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$").hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return "Enter your phone number";
    } else if (!RegExp(r"^[0-9]{10,15}$").hasMatch(value)) {
      return "Enter a valid phone number";
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  }

  static String? validateConfirmPassword(String? value, String password) {
    if (value == null || value.isEmpty) {
      return "Confirm your password";
    } else if (value != password) {
      return "Passwords do not match";
    }
    return null;
  }
}
