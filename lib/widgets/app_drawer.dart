import 'package:dummy_login_ui/screens/form_profile.dart';
import 'package:dummy_login_ui/screens/login_screen.dart';
import 'package:flutter/material.dart';

import 'dart:io';

import '../service/shared_preference.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String userName = '';
  String userEmail = '';
  String profileImagePath = '';

  void initState() {
    super.initState();
    loadUserDetails();
  }

  Future<void> loadUserDetails() async {
    final details = await SharedPreference.getUserDetails();

    if (!mounted) return;

    setState(() {
      userName = details['name'] ?? '';
      userEmail = details['email'] ?? '';
      profileImagePath = details['profileImagePath'] ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 310,

      child: Column(
        children: [
          Container(
            width: double.infinity,
            height: 270,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo, Colors.blue],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),

            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 42,
                      backgroundImage:
                          profileImagePath.isNotEmpty &&
                              File(profileImagePath).existsSync()
                          ? FileImage(File(profileImagePath))
                          : null,
                    ),

                    const SizedBox(height: 15),

                    Text(
                      userName.isNotEmpty ? userName : 'Guest',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      userEmail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _drawerItem(
                  icon: 'assets/icons/home.png',
                  title: "HOME",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                _drawerItem(
                  icon: 'assets/icons/profile.png',
                  title: "YOUR PROFILE",
                  onTap: () {
                    Navigator.pop(context);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FormPage()),
                    );
                  },
                ),

                _drawerItem(
                  icon: 'assets/icons/settings.png',
                  title: "SETTINGS",
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),

                _drawerItem(
                  icon: 'assets/icons/logout.png',
                  title: "SIGN OUT",
                  onTap: () async {
                    final shouldSignOut = await showDialog<bool>(
                      context: context,
                      builder: (dialogContext) {
                        return AlertDialog(
                          title: const Text("Sign Out"),
                          content: const Text(
                            "Are you sure you want to sign out?",
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext, false);
                              },
                              child: const Text("No"),
                            ),

                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext, true);
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );

                    if (shouldSignOut == true && context.mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _drawerItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),

      leading: Image.asset(icon, width: 35, height: 35),

      title: Text(
        title,
        style: const TextStyle(fontSize: 20, color: Colors.black),
      ),

      onTap: onTap,
    );
  }
}
