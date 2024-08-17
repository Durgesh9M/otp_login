import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const routeName = '/home-page';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getToast();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Welcome',
          style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Lottie.asset('assets/animations/human.json'),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: 'Enter your email...',
                    fillColor: Colors.grey.withOpacity(0.25),
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    )),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                var prefs = await SharedPreferences.getInstance();
                prefs.setString('email', emailController.text.toString());
              },
              child: Text(
                'Save!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<Future<bool?>> getToast() async {
  var prefs = await SharedPreferences.getInstance();
  String getEmail = prefs.getString('email') ?? 'Enjoy Lottie Animations';
  return Fluttertoast.showToast(
    msg: "Welcome $getEmail",
    toastLength: Toast.LENGTH_LONG,
    backgroundColor: Colors.blueGrey.shade400,
  );
}
