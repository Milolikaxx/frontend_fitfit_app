import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/pages/editprofile.dart';
import 'package:get/get.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
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
            const CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/images/runner.png')),
            const SizedBox(height: 10),
            const Text(
              "name name",
              style: TextStyle(
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // editDataSet("ชื่อผู้ใช้", "ชื่อผู้ใช้"),
                  // editDataSet("อีเมล", "อีเมล"),
                  // editDate("วันเกิด"),
                  // editDataSet("Password", "กรุณากรอกข้อมูล"),
                  // editDataSet("Confirm Password", "กรุณากรอกข้อมูล"),
                  oldPassword("รหัสผ่าน", "ใส่รหัสผ่าน"),
                  newPassword("รหัสผ่านใหม่", "ใส่รหัสผ่านใหม่"),
                  newPassword("ยืนยันรหัสผ่านใหม่",
                      "ใส่รหัสผ่านที่เหมือนกับรหัสผ่านใหม่"),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        // if (_formKey.currentState?.validate() ?? true) {
                        // Get.to(() => const Barbottom());
                        // }
                      },
                      style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all<Size>(
                            const Size(300, 50)),
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
                        'บันทึกรหัสผ่าน',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget oldPassword(title, detail) {
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ใส่รหัสผ่าน';
                }
                return null;
              },
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget newPassword(title, detail) {
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'ใส่รหัสผ่าน';
                }
                return null;
              },
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
