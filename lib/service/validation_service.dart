class ValidationService {
  static String? validateLogin({
    required String email,
    required String password,
  }) {
    if (email.trim().isEmpty) {
      return 'Please enter your email';
    }

    if (!validateEmail(email)) {
      return 'Please enter a valid email address';
    }

    if (password.isEmpty) {
      return 'Please enter your password';
    }

    if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  static bool validateEmail(String email) {
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email.trim());
  }

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  static String? validateProfileEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email';
    }

    if (!validateEmail(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  static String? validateProfilePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }

    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }

    return null;
  }

  static String? validateConfirmPassword({
    required String? confirmPassword,
    required String password,
  }) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return 'Please confirm your password';
    }

    if (confirmPassword != password) {
      return 'Passwords do not match';
    }

    return null;
  }

  static String? validateOtp(String otp) {
    if (otp.length != 4) {
      return 'Please enter the complete 4-digit OTP';
    }

    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }

    final phone = value.trim();

    if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(phone)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  static String? validateProfilePhoto(String? path) {
    if (path == null || path.isEmpty) {
      return 'Please select a profile photo';
    }

    return null;
  }
}
