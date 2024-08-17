import 'dart:developer';
import 'package:flutter/material.dart';
import 'home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});
  static const routeName = '/otp-screen';

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final otpController = TextEditingController();

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final verificationId = ModalRoute.of(context)!.settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Enter OTP',
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
              'Enter the OTP sent to your number',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            TextField(
              controller: otpController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                  hintText: 'Enter OTP...',
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

                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(
                                verificationId: verificationId.toString(),
                                smsCode: otpController.text.toString());
                        await FirebaseAuth.instance
                            .signInWithCredential(credential)
                            .then((value) {
                          Navigator.of(context).pushReplacementNamed(
                            HomePage.routeName,
                          );
                        });
                      } on Exception catch (e) {
                        log(e.toString());
                      }
                      setState(() {
                        isLoading = false;
                      });
                    },
                    child: Text('Verify OTP'),
                  )
          ],
        ),
      ),
    );
  }
}
