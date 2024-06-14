import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/model/request/user_login_post_req.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/pages/barbottom.dart';

import 'package:frontend_fitfit_app/pages/signup.dart';
import 'package:frontend_fitfit_app/service/api/user.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  List<String> scopes = <String>[
    'email',
  ];
  late UserService userService;
  @override
  void initState() {
    super.initState();
    userService = context.read<AppData>().userService;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bglogin.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Stack(children: [
            Padding(
              padding: const EdgeInsets.all(50),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Center(
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(top: 100),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "เข้าสู่ระบบ",
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
                                  return 'กรุณากรอกข้อความ';
                                }

                                bool emailValid = RegExp(
                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                    .hasMatch(value);
                                if (!emailValid) {
                                  log("Please enter a valid email");
                                  return 'กรุณากรอกอีเมลให้ถูกต้อง';
                                }

                                return null;
                              },
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'อีเมล',
                                hintStyle: TextStyle(color: Colors.white),
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: Colors.white,
                                ),
                                
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: TextFormField(
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'กรุณากรอกข้อความ';
                                }

                                // if (value.length < 8) {
                                //   return 'Password must be at least 8 characters';
                                // }
                                return null;
                              },
                              obscureText: !_isPasswordVisible,
                              style: const TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  hintText: 'รหัสผ่าน',
                                  hintStyle:
                                      const TextStyle(color: Colors.white),
                                  prefixIcon: const Icon(
                                      Icons.lock_outline_rounded,
                                      color: Colors.white),
                                 
                                  suffixIcon: IconButton(
                                    color: Colors.white,
                                    icon: Icon(_isPasswordVisible
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: ElevatedButton(
                              onPressed: login,
                              style: ButtonStyle(
                                minimumSize: MaterialStateProperty.all<Size>(
                                    const Size(330, 50)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        const Color(0xFFF8721D)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'เข้าสู่ระบบ',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 95),
                            child: GestureDetector(
                              onTap: () {},
                              child: const Text(
                                'ลืมรหัสผ่าน?',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: OutlinedButton(
                            onPressed: signIn,
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(330, 50)),
                              side: MaterialStateProperty.all<BorderSide>(
                                  const BorderSide(
                                color: Colors.white,
                                width: 2.0,
                              )),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
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
                                  'เข้าสู่ระบบด้วย Google',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(() => const SignUpPage());
                            },
                            style: ButtonStyle(
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(330, 50)),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFFF8721D)),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                            child: const Text(
                              'สร้างบัญชีใหม่',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void login() async {
    if (_formKey.currentState?.validate() ?? true) {
      UserLoginPostRequest loginObj = UserLoginPostRequest(
          email: emailController.text, password: passwordController.text);
          // startLoading(context);
      try {
        UserLoginPostResponse res = await userService.login(loginObj);
        if (res.uid != 0) {
          if (context.mounted) {
            context.read<AppData>().user = res;
          }
          log('เข้าสู่ระบบ');
          Get.to(() => const Barbottom());
        } else {
          Get.snackbar('เข้าสู่ระบบไม่สำเร็จ', 'กรุณากรอกข้อมูลให้ถูกต้อง');
        }
      } catch (e) {
        log(e.toString());
      }
    } else {
      Get.snackbar('ข้อมูลไม่ครบหรือไม่ถูกต้อง',
          'กรุณากรอกข้อมูลให้ครบและกรอกข้อมูลให้ถูกต้อง');
    }
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
      // Get.to(() => HomePage(user: googleSignInAccount));
    } else {
      log('error');
    }
  }
}
