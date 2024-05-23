import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/pages/accountpage.dart';
import 'package:frontend_fitfit_app/pages/editpasswordpage.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:frontend_fitfit_app/model/request/user_edit_put_req.dart';
import 'package:frontend_fitfit_app/service/api/user.dart';
import 'package:provider/provider.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late var loadData;
  var imgPick = "";
  late UserLoginPostResponse user;
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  DateTime? _selectedDate;

  void editUser() async {
    UserEditPutRequest editObj = UserEditPutRequest(
        name: nameController.text,
        birthday: "1990-12-23T00:00:00Z",
        email: emailController.text,
        imageProfile: imgPick,
        googleId: "Null");
    try {
      // ส่ง request ไปยังเซิร์ฟเวอร์และรอการตอบกลับ
      var res = await userService.edit(1, editObj);

      // ตรวจสอบ response ที่ได้รับจากเซิร์ฟเวอร์
      if (res == 1) {
        log((_selectedDate).toString());
        log(imgPick);
        log("Pass");
      } else if (res == 0) {
        log("Not Pass");
      } else {
        log("Other");
      }
    } catch (e) {
      log("Error: $e");
    }
  }

  late UserService userService;
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
                  Get.to(() => const AccountPage());
                },
              ),
            ]),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: (imgPick != "") ? profileImg() : profileNoImg(),
            ),
            const SizedBox(height: 10),
            Text(
              '${user.name}',
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
            child: SingleChildScrollView(
              child: Column(
                children: [
                  editDataSet("ชื่อผู้ใช้", "${user.name}", nameController),
                  editDataSet("อีเมล", "${user.email}", emailController),
                  editDate("วันเกิด"),
                  // editDataSet("Password", "กรุณากรอกข้อมูล"),
                  // editDataSet("Confirm Password", "กรุณากรอกข้อมูล"),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 15),
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.end, // จัดวางปุ่มชิดขวา
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Get.to(() => const EditPasswordPage());
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                              const Size(150, 50),
                            ),
                            backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(0, 255, 255, 255),
                            ),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                          child: const Text(
                            "แก้ไขรหัสผ่าน",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, top: 20),
                    child: ElevatedButton(
                      onPressed: editUser,
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
                        'แก้ไขข้อมูล',
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

  Widget editDataSet(title, detail, textController) {
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
              controller: textController,
              validator: (value) {
                log("Press on");
                if (value == null || value.isEmpty) {
                  return 'กรุณากรอกข้อความ';
                }
                return null;
              },
              style: const TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: detail,
                hintStyle: const TextStyle(color: Color.fromARGB(159, 0, 0, 0)),
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

  Widget editDate(title) {
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
            padding: const EdgeInsets.only(top: 8.0),
            child: ElevatedButton(
              onPressed: () async {
                final DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _selectedDate ?? DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  builder: (BuildContext context, Widget? child) {
                    return Theme(
                      data: ThemeData.light().copyWith(
                        colorScheme: const ColorScheme.light().copyWith(
                          primary: Colors.orange, // choose your preferred color
                        ),
                      ),
                      child: child!,
                    );
                  },
                );
                if (selectedDate != null) {
                  setState(() {
                    _selectedDate = selectedDate;
                  });
                }
              },
              style: ButtonStyle(
                minimumSize:
                    MaterialStateProperty.all<Size>(const Size(300, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
              ),
              child: Text(
                _selectedDate != null
                    ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                    : 'วัน / เดือน / ปี',
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
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
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                '${user.imageProfile}',
              ),
            ),
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
