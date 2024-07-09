import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:frontend_fitfit_app/pages/barbottom.dart';
import 'package:frontend_fitfit_app/pages/user/accountpage.dart';
import 'package:frontend_fitfit_app/pages/user/editpasswordpage.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'dart:developer';
import 'package:frontend_fitfit_app/model/request/user_edit_put_req.dart';
import 'package:frontend_fitfit_app/service/api/user.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  var dateController = TextEditingController();
  DateTime selectedBirthDate = DateTime.now();
  String birthdayDateMe = "";

  void editUser() async {
    String birthdayStr = selectedBirthDate.toIso8601String();
    log(birthdayStr);
    String bStr = "${birthdayStr.split(".")[0]}z";
    DateTime birthdayDateTime = DateTime.parse(bStr);
    if (nameController.text == "" &&
        emailController.text == "" &&
        dateController.text == "") {
     Get.snackbar(
        'ไม่มีการแก้ไขของข้อมูล', 'หากต้องการแก้ไขกรอกข้อมูล',
        backgroundColor: Colors.white, // Background color
        colorText: Colors.black,
      ); 
    } else {
       UserEditPutRequest editObj = UserEditPutRequest(
        name: nameController.text,
        birthday: birthdayDateTime,
        email: emailController.text,
        imageProfile: imgPick,
      );
      try {
        // ส่ง request ไปยังเซิร์ฟเวอร์และรอการตอบกลับ
        UserLoginPostResponse res = await userService.edit(user.uid!, editObj);

        // ตรวจสอบ response ที่ได้รับจากเซิร์ฟเวอร์
        if (res.uid! > 0) {
          log((_selectedDate).toString());
          log(imgPick);
          if (context.mounted) {
            context.read<AppData>().user = res;
          }
          log('เข้าสู่ระบบ');
          Get.to(() => const Barbottom(
                initialIndex: 4,
              ));
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
  }

  late UserService userService;
  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
    userService = context.read<AppData>().userService;
    loadData = loadDataAsync();
     // "1990-12-23T00:00:00Z"
   
  }

  loadDataAsync() async {
 
    var formatter = DateFormat.yMMMd();
    var dateInBuddhistCalendarFormat =
        formatter.formatInBuddhistCalendarThai(user.birthday!);
   birthdayDateMe= dateInBuddhistCalendarFormat;
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
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: TextFormField(
                      controller: dateController,
                      style: const TextStyle(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'กรุณาเลือกวันเกิด';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(18),
                          ),

                          // label: const Text('วันเกิด'),
                          hintText: 'วันเกิด $birthdayDateMe',
                          hintStyle: const TextStyle(color: Colors.black),
                          suffixIcon: const Padding(
                            padding: EdgeInsets.all(15),
                            child: FaIcon(
                              FontAwesomeIcons.calendar,
                              color: Colors.black,
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

  Widget editDataSet(title, detail, textController) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const SizedBox(height: 10),
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
                hintStyle: const TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(18),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.black, width: 2),
                  borderRadius: BorderRadius.circular(18),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Colors.red, width: 2), // สีเส้นขอบเมื่อมี error
                  borderRadius: BorderRadius.circular(18),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                      color: Colors.red,
                      width: 2), // สีเส้นขอบเมื่อโฟกัสและมี error
                  borderRadius: BorderRadius.circular(18),
                ),
                errorStyle: const TextStyle(color: Colors.black),
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
