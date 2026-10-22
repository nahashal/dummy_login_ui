import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dummy_login_ui/widgets/custom_textfield.dart';
import 'package:dummy_login_ui/widgets/gradient_button.dart';

import 'login_screen.dart';
import '../service/validation_service.dart';
import '../service/snackbar_service.dart';
import '../service/shared_preference.dart';
import '../service/secure_storage.dart';
import '../service/hive_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ImagePicker picker = ImagePicker();

  XFile? profilePhoto;

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool isSaving = false;

  Future<void> selectProfilePhoto() async {
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (!mounted) return;

    if (image != null) {
      setState(() {
        profilePhoto = image;
      });
    }
  }

  void validateSignup() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      SnackbarService.showMessage(
        context,
        'Please correct the errors in the form',
      );
      return;
    }

    final photoError = ValidationService.validateProfilePhoto(
      profilePhoto?.path,
    );

    if (photoError != null) {
      SnackbarService.showMessage(context, photoError);
      return;
    }

    saveSignup();
  }

  Future<void> saveSignup() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      await SharedPreference.saveUserDetails(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),

        profileImagePath: profilePhoto!.path,
      );

      await HiveService.savePhone(phoneController.text.trim());

      await SecureStorage.savePassword(passwordController.text);

      if (!mounted) return;

      SnackbarService.showMessage(
        context,
        'Registration successful!',
        isError: false,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    } catch (e) {
      if (!mounted) return;

      SnackbarService.showMessage(
        context,
        'Unable to save registration details',
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

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
              child: Text(
                'Sign Up',
                style: TextStyle(fontSize: 40, color: Colors.black),
              ),
            ),

            Positioned(
              top: 240,
              left: 5,
              right: 5,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.fromLTRB(35, 25, 35, 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(55),
                    topRight: Radius.circular(55),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 20,
                      spreadRadius: 2,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 45,
                                backgroundImage: profilePhoto != null
                                    ? FileImage(File(profilePhoto!.path))
                                    : null,
                                child: profilePhoto == null
                                    ? const Icon(Icons.person, size: 45)
                                    : null,
                              ),

                              TextButton.icon(
                                onPressed: selectProfilePhoto,
                                icon: const Icon(Icons.photo_camera),
                                label: const Text('Choose Photo'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 10),

                        const Text('Full Name', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),

                        CustomTextFormfield(
                          label: 'Name',
                          hint: 'Enter your full name',
                          icon: Icons.person,
                          controller: nameController,
                          validator: ValidationService.validateName,
                        ),

                        const SizedBox(height: 18),

                        const Text('Email', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),

                        CustomTextFormfield(
                          label: 'Email',
                          hint: 'Enter your email',
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                          validator: ValidationService.validateProfileEmail,
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          'Phone Number',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),

                        CustomTextFormfield(
                          label: 'Phone',
                          hint: 'Enter your phone number',
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                          controller: phoneController,
                          validator: ValidationService.validatePhone,
                        ),

                        const SizedBox(height: 18),

                        const Text('Password', style: TextStyle(fontSize: 18)),
                        const SizedBox(height: 10),

                        CustomTextFormfield(
                          label: 'Password',
                          hint: 'Create a password',
                          icon: Icons.lock,
                          controller: passwordController,
                          obscureText: hidePassword,
                          showVisibilityIcon: true,
                          onVisibilityToggle: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          validator: ValidationService.validateProfilePassword,
                        ),

                        const SizedBox(height: 18),

                        const Text(
                          'Confirm Password',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 10),

                        CustomTextFormfield(
                          label: 'Confirm Password',
                          hint: 'Re-enter your password',
                          icon: Icons.lock_outline,
                          controller: confirmPasswordController,
                          obscureText: hideConfirmPassword,
                          showVisibilityIcon: true,
                          onVisibilityToggle: () {
                            setState(() {
                              hideConfirmPassword = !hideConfirmPassword;
                            });
                          },
                          validator: (value) =>
                              ValidationService.validateConfirmPassword(
                                confirmPassword: value,
                                password: passwordController.text,
                              ),
                        ),

                        const SizedBox(height: 25),

                        GradientButton(
                          text: isSaving
                              ? 'Creating Account...'
                              : 'Create Account',
                          onPressed: isSaving ? () {} : validateSignup,
                        ),

                        const SizedBox(height: 15),

                        Center(
                          child: Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text(
                                'Already have an account',
                                style: TextStyle(fontSize: 14),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const LoginPage(),
                                    ),
                                  );
                                },
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize:
                                      MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: const Text(
                                  'Login here',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: .bold,
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
            ),
          ],
        ),
      ),
    );
  }
}
