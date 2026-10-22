import 'package:dummy_login_ui/widgets/custom_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../service/shared_preference.dart';

import '../service/snackbar_service.dart';
import '../service/validation_service.dart';
import '../service/hive_service.dart';

import 'dart:io';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  final List<String> skills = ['Flutter', 'Dart', 'Firebase', 'UI/UX Design'];

  final List<String> countries = ['India', 'USA', 'UK', 'Canada', 'Australia'];

  final List<String> languages = [
    'English',
    'Malayalam',
    'Hindi',
    'Tamil',
    'Arabic',
  ];

  final Map<String, List<String>> countryStates = {
    'India': ['Kerala', 'Karnataka', 'Tamil Nadu', 'Delhi'],
    'USA': ['California', 'Texas', 'New York', 'Florida'],
    'UK': ['England', 'Scotland', 'Wales', 'Northern Ireland'],
    'Canada': ['Ontario', 'Quebec', 'British Columbia', 'Alberta'],
    'Australia': [
      'New South Wales',
      'Victoria',
      'Queensland',
      'Western Australia',
    ],
  };

  PlatformFile? resume;
  final ImagePicker picker = ImagePicker();
  XFile? profilePhoto;

  double experienceLevel = 0;
  bool hideConfirmPassword = true;
  bool hidePassword = true;
  bool notificationsEnabled = false;

  DateTime? selectedDate;
  String? selectedGender;
  String? selectedCountry;
  String? selectedState;
  String? selectedLanguage;

  final List<String> selectedSkills = [];

  bool validateProfile() {
    final isFormValid = formKey.currentState!.validate();
    if (!isFormValid) {
      SnackbarService.showMessage(
        context,
        'Please correct the errors in the form',
      );
      return false;
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    loadProfileDetails();
  }

  Future<void> loadProfileDetails() async {
    final details = await SharedPreference.getUserDetails();
    final savedPhone = HiveService.getPhone();

    setState(() {
      nameController.text = details['name'] ?? '';
      emailController.text = details['email'] ?? '';
      passwordController.text = details['password'] ?? '';
      confirmPasswordController.text = details['password'] ?? '';
      phoneController.text = savedPhone.isEmpty
          ? savedPhone
          : details['phone'] ?? '';
      dobController.text = details['dateOfBirth'] ?? '';

      final savedPhotoPath = details['profileImagePath'] ?? '';

      if (savedPhotoPath.isNotEmpty && File(savedPhotoPath).existsSync()) {
        profilePhoto = XFile(savedPhotoPath);
      }
      if (!mounted) return;
    });
  }

  Future<void> selectResume() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );

    if (!mounted) return;

    if (result != null && result.isNotEmpty) {
      setState(() {
        resume = result.first;
      });
    }
  }

  Future<void> selectProfilePhoto() async {
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (!mounted) return;

    if (image != null) {
      setState(() {
        profilePhoto = image;
      });
    }
  }

  Future<void> selectDateOfBirth() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );

    if (!mounted) return;

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        dobController.text =
            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year}';
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    dobController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Your Profile')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormfield(
                  label: 'Name',
                  hint: 'Enter your name',
                  icon: Icons.person,
                  controller: nameController,
                  validator: ValidationService.validateName,
                ),

                const SizedBox(height: 20),

                CustomTextFormfield(
                  label: 'Email',
                  hint: 'Enter your email',
                  icon: Icons.email,
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: ValidationService.validateProfileEmail,
                ),

                const SizedBox(height: 20),

                CustomTextFormfield(
                  label: 'Phone',
                  hint: 'Enter your phone number',
                  icon: Icons.phone,
                  keyboardType: TextInputType.phone,
                  controller: phoneController,
                ),

                const SizedBox(height: 20),

                CustomTextFormfield(
                  label: 'Address',
                  hint: 'Enter your address',
                  icon: Icons.home,
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                ),

                const SizedBox(height: 20),

                CustomTextFormfield(
                  label: 'City',
                  hint: 'Enter your city',
                  icon: Icons.location_city,
                ),

                const SizedBox(height: 20),

                CustomTextFormfield(
                  label: 'PIN Code',
                  hint: 'Enter your PIN code',
                  icon: Icons.markunread_mailbox,
                  keyboardType: TextInputType.number,
                ),

                const SizedBox(height: 20),

                const Text(
                  'Gender',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                RadioGroup<String>(
                  groupValue: selectedGender,
                  onChanged: (value) {
                    setState(() {
                      selectedGender = value;
                    });
                  },
                  child: const Column(
                    children: [
                      RadioListTile<String>(title: Text('Male'), value: 'Male'),
                      RadioListTile<String>(
                        title: Text('Female'),
                        value: 'Female',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Skills',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                ...skills.map((skill) {
                  return CheckboxListTile(
                    title: Text(skill),
                    value: selectedSkills.contains(skill),
                    onChanged: (checked) {
                      setState(() {
                        if (checked == true) {
                          selectedSkills.add(skill);
                        } else {
                          selectedSkills.remove(skill);
                        }
                      });
                    },
                  );
                }),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  initialValue: selectedCountry,
                  hint: const Text('Select your country'),
                  decoration: const InputDecoration(
                    labelText: 'Country',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    prefixIcon: Icon(Icons.public),
                  ),
                  items: countries.map((country) {
                    return DropdownMenuItem<String>(
                      value: country,
                      child: Text(country),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCountry = value;
                      selectedState = null;
                    });
                  },
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  key: ValueKey(selectedCountry),
                  initialValue: selectedState,
                  hint: const Text('Select your state'),
                  decoration: const InputDecoration(
                    labelText: 'State',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    prefixIcon: Icon(Icons.location_city),
                  ),
                  items: selectedCountry == null
                      ? []
                      : countryStates[selectedCountry]!.map((state) {
                          return DropdownMenuItem<String>(
                            value: state,
                            child: Text(state),
                          );
                        }).toList(),
                  onChanged: selectedCountry == null
                      ? null
                      : (value) {
                          setState(() {
                            selectedState = value;
                          });
                        },
                ),

                const SizedBox(height: 20),

                DropdownButtonFormField<String>(
                  initialValue: selectedLanguage,
                  hint: const Text('Select your language'),
                  decoration: const InputDecoration(
                    labelText: 'Language',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    prefixIcon: Icon(Icons.language),
                  ),
                  items: languages.map((language) {
                    return DropdownMenuItem<String>(
                      value: language,
                      child: Text(language),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedLanguage = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                TextFormField(
                  controller: dobController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Date of Birth',
                    hintText: 'Select your date of birth',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_month),
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                  onTap: selectDateOfBirth,
                ),

                const SizedBox(height: 20),

                SwitchListTile(
                  title: const Text('Enable Notifications'),
                  subtitle: const Text('Receive notifications and updates'),
                  secondary: const Icon(Icons.notifications),
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                CustomTextFormfield(
                  label: 'About Me',
                  hint: 'Write a short description about yourself',
                  icon: Icons.description,
                  maxLines: 3,
                  minLines: 1,
                ),

                const SizedBox(height: 20),

                CustomTextFormfield(
                  label: 'Password',
                  hint: 'Enter your password',
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

                const SizedBox(height: 20),

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

                const SizedBox(height: 20),

                Text(
                  'Experience Level: ${experienceLevel.toInt()} years',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Slider(
                  value: experienceLevel,
                  min: 0,
                  max: 10,
                  divisions: 10,
                  label: '${experienceLevel.toInt()} years',
                  onChanged: (value) {
                    setState(() {
                      experienceLevel = value;
                    });
                  },
                ),

                const SizedBox(height: 20),

                const Text(
                  'Profile Photo',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                Center(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 55,
                        backgroundImage: profilePhoto != null
                            ? FileImage(File(profilePhoto!.path))
                            : null,
                        child: profilePhoto == null
                            ? const Icon(Icons.person, size: 55)
                            : null,
                      ),

                      const SizedBox(height: 10),

                      ElevatedButton.icon(
                        onPressed: selectProfilePhoto,
                        icon: const Icon(Icons.upload),
                        label: const Text('Choose Photo'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  'Resume',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                OutlinedButton.icon(
                  onPressed: selectResume,
                  icon: const Icon(Icons.upload_file),
                  label: const Text('Choose Resume'),
                ),

                if (resume != null) Text('Selected file: ${resume!.name}'),

                const SizedBox(height: 30),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if (!validateProfile()) return;

                      try {
                        final details = await SharedPreference.getUserDetails();

                        await SharedPreference.saveUserDetails(
                          name: nameController.text.trim(),
                          email: emailController.text.trim(),
                          phone: phoneController.text.trim(),

                          profileImagePath:
                              profilePhoto?.path ??
                              details['profileImagePath'] ??
                              '',
                        );

                        await HiveService.savePhone(
                          phoneController.text.trim(),
                        );

                        if (!mounted) return;

                        SnackbarService.showMessage(
                          context,
                          'Profile Saved Successfully!',
                          isError: false,
                        );

                        Navigator.pop(context, true);
                      } catch (e) {
                        if (!mounted) return;

                        SnackbarService.showMessage(
                          context,
                          'Unable to save profile changes',
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Save Profile',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
