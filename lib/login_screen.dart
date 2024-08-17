import 'dart:developer';
import 'package:flutter/material.dart';
import 'otp_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const routeName = '/login-screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Sign-in with phone',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Write correct 10 digit phone number',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'start with +91',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  hintText: 'Enter your number with +91',
                  fillColor: Colors.grey.withOpacity(0.25),
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none)),
            ),
            SizedBox(
              height: 30.0,
            ),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        isLoading = true;
                      });
                      await FirebaseAuth.instance.verifyPhoneNumber(
                        phoneNumber: phoneController.text.toString(),
                        verificationCompleted:
                            (PhoneAuthCredential credential) {},
                        verificationFailed: (FirebaseAuthException e) {
                          if (e.code == 'invalid-phone-number') {
                            print('The provided phone number is not valid.');
                          }
                          // Handle other errors
                        },
                        codeSent:
                            (String verificationId, int? resendToken) async {
                          setState(() {
                            isLoading = false;
                          });

                          // Updating the UI - wait for the user to enter the SMS code
                          Navigator.of(context).pushNamed(
                            OtpScreen.routeName,
                            arguments: verificationId,
                          );
                        },
                        codeAutoRetrievalTimeout: (String verificationId) {
                          log('Auto Retrieval timeout....');
                        },
                      );
                    },
                    child: Text('Send OTP'),
                  )
          ],
        ),
      ),
    );
  }
}
