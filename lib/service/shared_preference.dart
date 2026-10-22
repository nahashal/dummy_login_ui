import 'package:shared_preferences/shared_preferences.dart';

import 'secure_storage.dart';

class SharedPreference {
  static Future<void> saveUserDetails({
    required String name,
    required String email,
    required String phone,

    required String profileImagePath,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('user_name', name);
    await prefs.setString('user_email', email);
    await prefs.setString('user_phone', phone);

    await prefs.setString('user_profile_image', profileImagePath);
  }

  static Future<Map<String, String>> getUserDetails() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      'name': prefs.getString('user_name') ?? '',
      'email': prefs.getString('user_email') ?? '',
      'phone': prefs.getString('user_phone') ?? '',

      'profileImagePath': prefs.getString('user_profile_image') ?? '',
    };
  }

  static Future<String> getRegisteredEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_email') ?? '';
  }

  static Future<bool> checkLoginCredentials({
    required String email,
    required String password,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_password');

    final savedEmail = prefs.getString('user_email') ?? '';
    final savedPassword = await SecureStorage.getPassword();

    return email.trim().toLowerCase() == savedEmail.trim().toLowerCase() &&
        savedPassword != null &&
        password == savedPassword;
  }
}
