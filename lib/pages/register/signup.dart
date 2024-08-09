import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:frontend_fitfit_app/service/model/request/user_login%20google_req.dart';
import 'package:frontend_fitfit_app/service/model/request/user_register_post_req.dart';
import 'package:frontend_fitfit_app/service/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/pages/barbottom.dart';
import 'package:frontend_fitfit_app/service/api/user.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/pages/auth/login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:firebase_storage/firebase_storage.dart';
import 'package:image/image.dart' as img;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  // final FirebaseStorage _storage = FirebaseStorage.instance;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var dateController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _isconPasswordVisible = false;
  final confirmPasswordController = TextEditingController();
  var passwordController = TextEditingController();
  String imgPick = "";
  Uint8List? imageBytes;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  DateTime selectedBirthDate = DateTime.now();
  late UserService userService;
  File? imageFile;
  List<String> scopes = <String>[
    'email',
  ];
  @override
  void initState() {
    super.initState();
    imgPick = "";
    userService = context.read<AppData>().userService;
    // var formatter = DateFormat.yMMMd();
    // var dateInBuddhistCalendarFormat =
    //     formatter.formatInBuddhistCalendarThai(DateTime.now());
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
                      child:
                          (imageFile != null) ? profileImg() : profileNoImg(),
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
                        decoration: const InputDecoration(
                          hintText: 'ชื่อในระบบ',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                        controller: dateController,
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณาเลือกวันเกิด';
                          }
                          return null;
                        },
                        decoration: const InputDecoration(
                            // label: const Text('วันเกิด'),
                            hintText: 'วันเกิด',
                            hintStyle: TextStyle(color: Colors.white),
                            suffixIcon: Padding(
                              padding: EdgeInsets.all(15),
                              child: FaIcon(
                                FontAwesomeIcons.calendar,
                                color: Colors.white,
                                size: 20,
                              ),
                            )),
                        readOnly:
                            true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          calendar();
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
                        decoration: const InputDecoration(
                          hintText: 'อีเมล',
                          hintStyle: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 10),
                      child: TextFormField(
                        controller: passwordController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกรหัสผ่านของคุณ';
                          }

                          if (value.length < 6) {
                            return 'รหัสผ่านต้องมีความยาวเกิน 6 ตัวอักษร';
                          }
                          return null;
                        },
                        obscureText: !_isPasswordVisible,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'รหัสผ่าน',
                            hintStyle: const TextStyle(color: Colors.white),
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
                            return 'กรุณากรอกรหัสผ่านของคุณ';
                          }

                          if (value.length < 6) {
                            return 'รหัสผ่านต้องมีความยาวเกิน 6 ตัวอักษร';
                          }
                          return null;
                        },
                        obscureText: !_isconPasswordVisible,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: 'ยืนยันรหัสผ่าน',
                            hintStyle: const TextStyle(color: Colors.white),
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
                        onPressed: () {
                          signIn();
                        },
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

  void showLoading() {
    SmartDialog.showLoading(msg: "กำลังประมวลผล...");
  }

  void hideLoading() {
    SmartDialog.dismiss();
  }

  void signUp() async {
    String birthdayStr = selectedBirthDate.toIso8601String();
    log(birthdayStr);
    String bStr = "${birthdayStr.split(".")[0]}z";
    DateTime birthdayDateTime = DateTime.parse(bStr);
    log(birthdayDateTime.toIso8601String());

    if (_formKey.currentState?.validate() ?? true) {
      if (passwordController.text == confirmPasswordController.text) {
        showLoading();
        if (imageFile != null) {
          await uploadImg();
          log("img : $imgPick");
          UserRegisterPostRequest registerObj = UserRegisterPostRequest(
            name: nameController.text,
            birthday: birthdayDateTime,
            email: emailController.text,
            password: passwordController.text,
            imageProfile: imgPick,
          );

          try {
            int res = await userService.register(registerObj);
            if (res == 1) {
              hideLoading();
              // ignore: use_build_context_synchronously
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text("สำเร็จ!"),
                        titleTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20),
                        actionsOverflowButtonSpacing: 20,
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Get.offAll(() => const LoginPage());
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
                              "ตกลง",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                        content: const Text("สมัครสมาชิกสำเร็จ"),
                      ));
            } else if (res == 2) {
              Get.snackbar('อีเมลนี้มีอยู่แล้ว', 'กรุณากรอกอีเมลใหม่');
            } else if (res == 3) {
              Get.snackbar('ชื่อนี้มีอยู่แล้ว', 'กรุณากรอกชื่อๆใหม่');
            } else {
              log('สมัครสมาชิกไม่สำเร็จ ');
              Get.snackbar('ข้อมูลไม่ถูกต้อง', 'กรุณากรอกข้อมูลให้ถูกต้อง');
            }
          } catch (e) {
            log(e.toString());
          }
        } else {
          UserRegisterPostRequest registerObj = UserRegisterPostRequest(
            name: nameController.text,
            birthday: birthdayDateTime,
            email: emailController.text,
            password: passwordController.text,
            imageProfile:
                "http://202.28.34.197:8888/contents/ac11379f-1be1-46fe-ae0d-0c41ff876e24.png",
          );
          try {
            int res = await userService.register(registerObj);
            if (res == 1) {
               hideLoading();
              // ignore: use_build_context_synchronously
              showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text("สำเร็จ!"),
                        titleTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20),
                        actionsOverflowButtonSpacing: 20,
                        actions: [
                          ElevatedButton(
                            onPressed: () {
                              Get.offAll(() => const LoginPage());
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
                              "ตกลง",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ],
                        content: const Text("สมัครสมาชิกสำเร็จ"),
                      ));
            } else if (res == 2) {
              Get.snackbar('อีเมลนี้มีอยู่แล้ว', 'กรุณากรอกอีเมลใหม่');
            } else if (res == 3) {
              Get.snackbar('ชื่อนี้มีอยู่แล้ว', 'กรุณากรอกชื่อๆใหม่');
            } else {
              log('สมัครสมาชิกไม่สำเร็จ ');
              Get.snackbar('ข้อมูลไม่ถูกต้อง', 'กรุณากรอกข้อมูลให้ถูกต้อง');
            }
          } catch (e) {
            log(e.toString());
          }
        }
      }
    } else if (_formKey.currentState?.validate() ?? false) {
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
                image: AssetImage('assets/images/runner.png')),
          ),
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
                fit: BoxFit.cover,
                image: FileImage(imageFile!),
              )),
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

  // firebase
  void pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
    }
  }

//upload
  Future<void> uploadImg() async {
    if (imageFile != null) {
      // Read the file as bytes
      Uint8List imageBytes = await imageFile!.readAsBytes();

      // Decode
      img.Image? decodedImage = img.decodeImage(imageBytes);

      if (decodedImage != null) {
        // Encode
        Uint8List base64ImgDecode =
            Uint8List.fromList(img.encodeJpg(decodedImage));
        // String base64Image = base64Encode(base64ImgDecode);
        // log("$base64Image base64");

        try {
          FirebaseStorage storage = FirebaseStorage.instance;

          String fileName = path.basename(imageFile!.path);
          Reference ref = storage.ref().child('uploadsImg/$fileName');

          // Upload the image bytes to Firebase
          UploadTask uploadTask = ref.putData(base64ImgDecode);
          await uploadTask.whenComplete(() async {
            String downloadURL = await ref.getDownloadURL();
            log('File uploaded at $downloadURL');
            if (mounted) {
              setState(() {
                imgPick = downloadURL;
              });
              log("url $imgPick");
            }
          });
        } catch (e) {
          log(e.toString());
        }
      } else {
        log('Failed to decode image');
      }
    } else {
      log('No image selected');
    }
  }

  Future<void> calendar() async {
    DateTime? newDateTime = await showRoundedDatePicker(
        era: EraMode.BUDDHIST_YEAR,
        context: context,
        initialDate: selectedBirthDate,
        firstDate: DateTime(DateTime.now().year - 100),
        borderRadius: 10,
        height: 300,
        styleDatePicker: MaterialRoundedDatePickerStyle(
          textStyleButtonPositive:
              Get.textTheme.bodyLarge!.copyWith(color: const Color(0xFFF8721D)),
          textStyleButtonNegative:
              Get.textTheme.bodyLarge!.copyWith(color: const Color(0xFFF8721D)),
          textStyleDayOnCalendarSelected:
              Get.textTheme.bodyMedium!.copyWith(color: Colors.white),
          textStyleDayButton:
              Get.textTheme.titleLarge!.copyWith(color: Colors.white),
          textStyleYearButton:
              Get.textTheme.titleLarge!.copyWith(color: Colors.white),
          decorationDateSelected: const BoxDecoration(
            color: Color(0xFFF8721D), // This is the orange color
            shape: BoxShape.circle,
          ),
        ),
        theme: ThemeData(
          primaryColor: const Color(0xFFF8721D),
        ));

    if (newDateTime != null) {
      selectedBirthDate = newDateTime;
      var formatter = DateFormat.yMMMd();
      var dateInBuddhistCalendarFormat =
          formatter.formatInBuddhistCalendarThai(selectedBirthDate);
      dateController.text = "วันเกิด $dateInBuddhistCalendarFormat";
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
      UserLoginGooglePostRequest user = UserLoginGooglePostRequest(
          name: googleSignInAccount.displayName.toString(),
          email: googleSignInAccount.email,
          imageProfile: googleSignInAccount.photoUrl ??
              'http://202.28.34.197:8888/contents/ac11379f-1be1-46fe-ae0d-0c41ff876e24.png',
          googleId: googleSignInAccount.id);
      try {
        UserLoginPostResponse res = await userService.loginGoogle(user);
        if (res.uid != 0) {
          log("have uid");
          if (context.mounted) {
            context.read<AppData>().user = res;
          }
          log('เข้าสู่ระบบ');
          Get.to(() => const Barbottom());
        } else {
          log("not have uid");
          Get.snackbar('เข้าสู่ระบบไม่สำเร็จ', '');
        }
      } catch (e) {
        log(e.toString());
      }
    } else {
      log('error');
    }
  }

  // void pickImageAndUp() async {
  //   final ImagePicker picker = ImagePicker();
  //   final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  //   if (image != null) {
  //     var filePath = image.path;
  //     var fileName = image.name;
  //     if (filePath.isNotEmpty && fileName.isNotEmpty) {
  //       var formData = FormData.fromMap({
  //         'file': await MultipartFile.fromFile(
  //           filePath,
  //           filename: fileName,
  //         )
  //       });

  //       var result = await Dio()
  //           .post('http://202.28.34.197:8888/cdn/fileupload', data: formData);
  //       if (result.statusCode == 201) {
  //         log(result.data['fileUrl']);
  //         setState(() {
  //           imgPick = result.data['fileUrl'];
  //         });
  //       }
  //     }
  //   }
  // }
}
