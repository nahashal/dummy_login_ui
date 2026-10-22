import 'package:dummy_login_ui/screens/home_page.dart';
import 'package:dummy_login_ui/widgets/gradient_button.dart';
import 'package:flutter/material.dart';

import '../service/snackbar_service.dart';
import '../service/validation_service.dart';
import '../widgets/otp_field.dart';

import 'dart:async';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final FocusNode focus1 = FocusNode();
  final FocusNode focus2 = FocusNode();
  final FocusNode focus3 = FocusNode();
  final FocusNode focus4 = FocusNode();

  final TextEditingController otpController1 = TextEditingController();
  final TextEditingController otpController2 = TextEditingController();
  final TextEditingController otpController3 = TextEditingController();
  final TextEditingController otpController4 = TextEditingController();

  void verifyOtp() {
    final otp =
        otpController1.text +
        otpController2.text +
        otpController3.text +
        otpController4.text;

    final error = ValidationService.validateOtp(otp);

    if (error != null) {
      SnackbarService.showMessage(context, error);
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  int secondsRemaining = 30;
  Timer? countdownTimer;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    countdownTimer?.cancel();

    focus1.dispose();
    focus2.dispose();
    focus3.dispose();
    focus4.dispose();

    otpController1.dispose();
    otpController2.dispose();
    otpController3.dispose();
    otpController4.dispose();

    super.dispose();
  }

  void startTimer() {
    countdownTimer?.cancel();

    setState(() {
      secondsRemaining = 30;
    });

    countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
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
            Positioned(
              top: 50,
              left: 20,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            ),

            const Positioned(
              top: 150,
              left: 60,
              child: Text(
                "OTP Verification",
                style: TextStyle(fontSize: 38, color: Colors.black),
              ),
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

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "OTP",
                      style: TextStyle(fontSize: 22, color: Colors.black),
                    ),

                    const SizedBox(height: 18),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        OtpBox(
                          controller: otpController1,
                          focusNode: focus1,
                          nextFocusNode: focus2,
                        ),

                        OtpBox(
                          controller: otpController2,
                          focusNode: focus2,
                          nextFocusNode: focus3,
                          previousFocusNode: focus1,
                        ),

                        OtpBox(
                          controller: otpController3,
                          focusNode: focus3,
                          nextFocusNode: focus4,
                          previousFocusNode: focus2,
                        ),

                        OtpBox(
                          controller: otpController4,
                          focusNode: focus4,
                          previousFocusNode: focus3,
                        ),
                      ],
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            secondsRemaining == 0
                                ? 'OTP expired'
                                : 'OTP expires in $secondsRemaining seconds',
                            style: TextStyle(
                              fontSize: 18,
                              color: secondsRemaining == 0
                                  ? Colors.red
                                  : Colors.indigo,
                            ),
                          ),

                          TextButton(
                            onPressed: () {
                              otpController1.clear();
                              otpController2.clear();
                              otpController3.clear();
                              otpController4.clear();

                              focus1.requestFocus();
                              startTimer();
                            },
                            child: const Text(
                              'Resend OTP',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.indigo,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    GradientButton(text: "Verify OTP", onPressed: verifyOtp),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
