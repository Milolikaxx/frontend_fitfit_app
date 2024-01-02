import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/pages/home.dart';
import 'package:frontend_fitfit_app/pages/signup.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  List<String> scopes = <String>[
    'email',
  ];
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Padding(
              padding: EdgeInsets.only(top: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Log in ",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 20),
              child: TextFormField(
                controller: emailController,
                validator: (value) {
                  // add email validation
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }

                  bool emailValid = RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value);
                  if (!emailValid) {
                    return 'Please enter a valid email';
                  }

                  return null;
                },
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: const TextStyle(color: Colors.white),
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: Colors.white,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: TextFormField(
                controller: passwordController,
                validator: (value) {
                  if (value == null ||
                      value.isEmpty) {
                    return 'Please enter some text';
                  }

                  if (value.length < 8) {
                    return 'Password must be at least 8 characters';
                  }
                  return null;
                },
                obscureText: !_isPasswordVisible,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.lock_outline_rounded,
                        color: Colors.white),
                    enabledBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    suffixIcon: IconButton(
                      color: Colors.white,
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ElevatedButton(
                onPressed: () {
   
                },
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(330, 50)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFFF8721D)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                child: const Text(
                  'Log in',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 95),
              child: GestureDetector(
                onTap: () {},
                child: const Text(
                  'Forgot password?',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: OutlinedButton(
                onPressed: signIn,
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(300, 50)),
                  side: MaterialStateProperty.all<BorderSide>(const BorderSide(
                    color: Colors.white,
                    width: 2.0,
                  )),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: Image.asset(
                        'assets/images/google.png',
                        width: 25,
                      ),
                    ),
                    const Text(
                      'Log in with Google',
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const SignUpPage());
                },
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(330, 50)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFFF8721D)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                child: const Text(
                  'Create new account',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void signIn() async {
    GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: scopes,
    );
    var googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount != null) {
      log(googleSignInAccount.email);
      log(googleSignInAccount.id);
      log(googleSignInAccount.displayName ?? 'No Dispayname');
      log(googleSignInAccount.photoUrl ?? 'No url');
      Get.to(() => HomePage(user: googleSignInAccount));
    } else {
      log('error');
    }
  }
}
