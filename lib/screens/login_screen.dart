import 'package:dummy_login_ui/screens/otp_page.dart';
import 'package:dummy_login_ui/widgets/gradient_button.dart';

import 'signup_page.dart';

import '../service/snackbar_service.dart';
import '../service/validation_service.dart';
import '../service/shared_preference.dart';

import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadRegisteredEmail();
  }

  Future<void> loadRegisteredEmail() async {
    final email = await SharedPreference.getRegisteredEmail();

    if (!mounted) return;

    if (email.isNotEmpty) {
      emailController.text = email;
    }
  }

  Future<void> validateLogin() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    final error = ValidationService.validateLogin(
      email: emailController.text,
      password: passwordController.text,
    );

    if (error != null) {
      SnackbarService.showMessage(context, error);
      return;
    }

    final credentialsMatch = await SharedPreference.checkLoginCredentials(
      email: emailController.text,
      password: passwordController.text,
    );

    if (!mounted) return;

    if (!credentialsMatch) {
      SnackbarService.showMessage(
        context,
        'Incorrect email or password. Please sign up first if you do not have an account.',
      );
      return;
    }

    emailController.clear();
    passwordController.clear();

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const OtpPage()),
    );
  }

  void showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Dummy_bg.webp'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: 150,
              left: 60,
              child: Text("Login", style: TextStyle(fontSize: 40)),
            ),

            Positioned(
              top: 280,
              left: 5,
              right: 5,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(40, 45, 40, 25),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(55),
                    topRight: Radius.circular(55),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: Offset(0, -5),
                    ),
                  ],
                ),

                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Email",
                        style: TextStyle(fontSize: 22, color: Colors.black),
                      ),

                      const SizedBox(height: 18),

                      TextFormField(
                        validator: ValidationService.validateProfileEmail,
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          hintStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      const Text(
                        "Password",
                        style: TextStyle(fontSize: 22, color: Colors.black),
                      ),

                      const SizedBox(height: 18),

                      TextFormField(
                        validator: ValidationService.validateProfilePassword,
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: const TextStyle(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                          filled: true,
                          fillColor: Colors.grey[200],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 20,
                            horizontal: 20,
                          ),
                        ),
                      ),

                      const SizedBox(height: 50),

                      GradientButton(text: "Sign In", onPressed: validateLogin),
                      const SizedBox(height: 15),

                      Center(
                        child: Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account? ",
                              style: TextStyle(fontSize: 14),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignupPage(),
                                  ),
                                );
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Click here',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
