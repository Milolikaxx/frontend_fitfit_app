import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/service/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/service/model/request/user_editpassword_post_req.dart';
import 'package:frontend_fitfit_app/pages/user/editprofile.dart';
import 'package:get/get.dart';
import 'package:frontend_fitfit_app/service/api/user.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:provider/provider.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  late var loadData;
  late UserLoginPostResponse user;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final oldpasswordController = TextEditingController();
  final newpasswordController = TextEditingController();
  final confirmpasswordController = TextEditingController();
  late UserService userService;
  bool _isOldPasswordVisible = false;
  bool _isNewPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
    userService = context.read<AppData>().userService;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    // liseWorkoutPdrofile = await wpService.getMorkoutProfile(user.uid!);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.exit_to_app_rounded,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {
                  Get.to(() => const EditProfilePage());
                },
              ),
            ]),
        body: Column(
          children: [
            CircleAvatar(
              radius: 50.0,
              backgroundImage: NetworkImage(
                '${user.imageProfile}',
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "${user.name}",
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            editYourself(height, width)
          ],
        ));
  }

  Widget editYourself(height, width) {
    return Expanded(
      child: Container(
          height: height,
          width: width,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      // editDataSet("ชื่อผู้ใช้", "ชื่อผู้ใช้"),
                      // editDataSet("อีเมล", "อีเมล"),
                      // editDate("วันเกิด"),
                      // editDataSet("Password", "กรุณากรอกข้อมูล"),
                      // editDataSet("Confirm Password", "กรุณากรอกข้อมูล"),
                      oldPassword(
                          "รหัสผ่าน", "ใส่รหัสผ่าน", oldpasswordController),
                      newPassword("รหัสผ่านใหม่", "ใส่รหัสผ่านใหม่",
                          newpasswordController),
                      confirmPassword(
                          "ยืนยันรหัสผ่านใหม่",
                          "ใส่รหัสผ่านที่เหมือนกับรหัสผ่านใหม่",
                          confirmpasswordController),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10, top: 20),
                        child: ElevatedButton(
                          onPressed: editPassword,
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(300, 50)),
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
                            'บันทึกรหัสผ่าน',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ))),
    );
  }

  Widget oldPassword(title, detail, textController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child: TextFormField(
              controller: oldpasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ใส่รหัสผ่าน';
                }
                return null;
              },
              obscureText: !_isOldPasswordVisible,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: detail,
                  hintStyle: const TextStyle(color: Colors.black),
                  contentPadding: const EdgeInsets.only(left: 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  suffixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(_isOldPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isOldPasswordVisible = !_isOldPasswordVisible;
                      });
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget newPassword(title, detail, textController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child: TextFormField(
              controller: newpasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ใส่รหัสผ่าน';
                }
                return null;
              },
              obscureText: !_isNewPasswordVisible,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: detail,
                  hintStyle: const TextStyle(color: Colors.black),
                  contentPadding: const EdgeInsets.only(left: 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  suffixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(_isNewPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isNewPasswordVisible = !_isNewPasswordVisible;
                      });
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }

  Widget confirmPassword(title, detail, textController) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 0, bottom: 0),
            child: TextFormField(
              controller: confirmpasswordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ใส่รหัสผ่าน';
                }
                return null;
              },
              obscureText: !_isConfirmPasswordVisible,
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                  hintText: detail,
                  hintStyle: const TextStyle(color: Colors.black),
                  contentPadding: const EdgeInsets.only(left: 10.0),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black, width: 2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  suffixIcon: IconButton(
                    color: Colors.black,
                    icon: Icon(_isConfirmPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                      });
                    },
                  )),
            ),
          ),
        ],
      ),
    );
  }

  void editPassword() async {
    if (newpasswordController.text == confirmpasswordController.text) {
      UserEditPasswordPostRequest editPasswordObj = UserEditPasswordPostRequest(
          password: oldpasswordController.text,
          passwordNew: newpasswordController.text);
      var res = await userService.editPassword(1, editPasswordObj);
      if (res == 1) {
        log("Pass");
        Get.snackbar('สำเร็จ', 'แก้ไขรหัสผ่านสำเร็จ');
        loadData = loadDataAsync();
      } else if (res == 0) {
        log("Not Pass");
      } else {
        Get.snackbar('รหัสผ่านไม่ถูกต้อง', 'กรุณาใส่รหัสผ่านให้ถูกต้อง');
        log("Other");
      }
    } else {
      Get.snackbar('ยืนยันรหัสผ่านไม่ถูกต้อง', 'กรุณายืนยันรหัสผ่านให้ถูกต้อง');
      log("รหัสไม่ตรงกัน");
    }
  }
}
