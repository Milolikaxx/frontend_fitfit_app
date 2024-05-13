import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:frontend_fitfit_app/model/request/user_register_post_req.dart';
import 'package:frontend_fitfit_app/service/api/user.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/pages/login.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var dateController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isconPasswordVisible = false;
  final confirmPasswordController = TextEditingController();
  var passwordController = TextEditingController();
  var imgPick = "";
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime? pickedDate;
  late UserService userService;
  @override
  void initState() {
    super.initState();
    imgPick = "";
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
            image: AssetImage('assets/images/bgsignup.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      'สมัครสมาชิก',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: (imgPick != "") ? profileImg() : profileNoImg(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15, bottom: 10),
                      child: TextFormField(
                        controller: nameController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกชื่อในระบบของคุณ';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'ชื่อในระบบ',
                          hintStyle: const TextStyle(color: Colors.white),
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
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                        controller: dateController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกวันเกิดของคุณ';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          // label: const Text('วันเกิด'),
                          hintText: 'วันเกิด',
                          hintStyle: const TextStyle(color: Colors.white),
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
                        ),
                        readOnly:
                            true, //set it true, so that user will not able to edit text
                        // onTap: () async {
                        //   // DateTime? newDateTime = await showRoundedDatePicker(
                        //   //   context: context,
                        //   //   locale: const Locale("th", "TH"),
                        //   //   era: EraMode.BUDDHIST_YEAR,
                        //   // );
                        // },
                        onTap: () async {
                          pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2101));
                          if (pickedDate != null) {
                            log(pickedDate
                                .toString()); //pickedDate output format => 2021-03-10 00:00:00.000
                            // final formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate!);
                            // log(formattedDate);
                            setState(() {
                              dateController.text =
                                  '${pickedDate!.day}/${pickedDate!.month}/${pickedDate!.year}';
                            });
                          } else {
                            log("Date is not selected");
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                        controller: emailController,
                        validator: (value) {
                          // add email validation
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกอีเมลของคุณ';
                          }
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value);
                          if (!emailValid) {
                            log('กรุณาใส่อีเมลให้ถูกต้อง');
                            return 'กรุณาใส่อีเมลให้ถูกต้อง';
                          }
                          return null;
                        },
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'อีเมล',
                          hintStyle: const TextStyle(color: Colors.white),
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
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
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
                            hintText: 'รหัสผ่าน',
                            hintStyle: const TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2),
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
                      padding: const EdgeInsets.only(top: 10, bottom: 20),
                      child: TextFormField(
                        controller: confirmPasswordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }

                          if (value.length < 8) {
                            return 'Password must be at least 8 characters';
                          }
                          return null;
                        },
                        obscureText: !_isconPasswordVisible,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'ยืนยันรหัสผ่าน',
                            hintStyle: const TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            suffixIcon: IconButton(
                              color: Colors.white,
                              icon: Icon(_isconPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility),
                              onPressed: () {
                                setState(() {
                                  _isconPasswordVisible =
                                      !_isconPasswordVisible;
                                });
                              },
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: ElevatedButton(
                        onPressed: signUp,
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(330, 50)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFF8721D)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                        child: const Text(
                          'สมัครสมาชิก',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: OutlinedButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(300, 50)),
                          side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(
                            color: Colors.white,
                            width: 2.0,
                          )),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
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
                              'สมัครด้วยบัญชี Google',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: ElevatedButton(
                        onPressed: () {
                          Get.to(() => const LoginPage());
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(330, 50)),
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color(0xFFF8721D)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                          ),
                        ),
                        child: const Text(
                          'มีบัญชีอยู่แล้ว',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void signUp() async {
    String birthdayStr = pickedDate!.toIso8601String();
    log(birthdayStr);
    String bStr = "${birthdayStr.split(".")[0]}z";
    DateTime birthdayDateTime = DateTime.parse(bStr);
    log(birthdayDateTime.toIso8601String());
    if (_formKey.currentState?.validate() ?? true) {
      if (passwordController.text != confirmPasswordController.text) {
        if (imgPick != "") {
          UserRegisterPostRequest registerObj = UserRegisterPostRequest(
              name: nameController.text,
              birthday: birthdayDateTime,
              email: emailController.text,
              password: passwordController.text,
              imageProfile: imgPick,
              googleId: null);
          try {
            int res = await userService.register(registerObj);
            if (res == 0) {
              log('สมัครสมาชิกไม่สำเร็จ ');
              Get.snackbar('ข้อมูลไม่ถูกต้อง', 'กรุณากรอกข้อมูลให้ถูกต้อง');
            } else {
              Get.snackbar('สมัครสมาชิกสำเร็จ', '');
            }
          } catch (e) {
            log(e.toString());
          }
        }
      } else {
        UserRegisterPostRequest registerObj = UserRegisterPostRequest(
            name: nameController.text,
            birthday: birthdayDateTime,
            email: emailController.text,
            password: passwordController.text,
            imageProfile:
                "http://202.28.34.197:8888/contents/ac11379f-1be1-46fe-ae0d-0c41ff876e24.png",
            googleId: null);
        try {
          int res = await userService.register(registerObj);
          if (res == 1) {
            log('สมัครสมาชิกสำเร็จ ');
            Get.snackbar('สมัครสมาชิกสำเร็จ', '');
          }else if (res == 2){
            Get.snackbar('อีเมลนี้มีอยู่แล้ว', 'กรุณากรอกอีเมลใหม่');
          } else if (res == 3){
            Get.snackbar('ชื่อนี้มีอยู่แล้ว', 'กรุณากรอกชื่อๆใหม่');
          }else  {
            log('สมัครสมาชิกไม่สำเร็จ ');
            Get.snackbar('ข้อมูลไม่ถูกต้อง', 'กรุณากรอกข้อมูลให้ถูกต้อง');
          }
        } catch (e) {
          log(e.toString());
        }
      }
    } else {
      Get.snackbar('ข้อมูลไม่ครบ', 'กรุณากรอกข้อมูลให้ครบ');
    }
  }

  Widget profileNoImg() {
    return Stack(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
              border: Border.all(width: 4, color: Colors.white),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1))
              ],
              shape: BoxShape.circle,
              image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage('assets/images/runner.png'))),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 4, color: Colors.white),
                  color: Colors.orange),
              child: IconButton(
                padding: EdgeInsets.zero,
                color: Colors.white,
                onPressed: pickImage,
                icon: const Icon(Icons.add),
              ),
            ))
      ],
    );
  }

  Widget profileImg() {
    return Stack(
      children: [
        Container(
          width: 130,
          height: 130,
          decoration: BoxDecoration(
              border: Border.all(width: 4, color: Colors.white),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1))
              ],
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.cover, image: NetworkImage(imgPick))),
        ),
        Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(width: 4, color: Colors.white),
                  color: Colors.orange),
              child: IconButton(
                padding: EdgeInsets.zero,
                color: Colors.white,
                onPressed: () {
                  pickImage();
                },
                icon: const Icon(Icons.edit),
              ),
            ))
      ],
    );
  }

  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var filePath = image.path;
      var fileName = image.name;
      if (filePath.isNotEmpty && fileName.isNotEmpty) {
        var formData = FormData.fromMap({
          'file': await MultipartFile.fromFile(
            filePath,
            filename: fileName,
          )
        });

        var result = await Dio()
            .post('http://202.28.34.197:8888/cdn/fileupload', data: formData);
        if (result.statusCode == 201) {
          log(result.data['fileUrl']);
          setState(() {
            imgPick = result.data['fileUrl'];
          });
        }
      }
    }
  }
}
