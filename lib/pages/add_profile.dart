import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/pages/playlist_after_create.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class AddProfilePage extends StatefulWidget {
  const AddProfilePage({super.key});

  @override
  State<AddProfilePage> createState() => _AddProfilePageState();
}

class Musictype {
  final int id;
  final String name;

  Musictype({
    required this.id,
    required this.name,
  });
}

class _AddProfilePageState extends State<AddProfilePage> {
  String dropdownValue = 'การเดิน';
  late List<Musictype> tagMusictype = [
    Musictype(id: 1, name: "เพลงไทย"),
    Musictype(id: 2, name: "เพลงลูกทุ่ง"),
    Musictype(id: 3, name: "เพลงสากล"),
    Musictype(id: 4, name: "เพลงเกาหลี"),
    Musictype(id: 5, name: "เพลงญี่ปุ่น"),
    Musictype(id: 6, name: "เพลงจีน"),
  ];
  // final _multiSelectKey = GlobalKey<FormFieldState>();
  List<Musictype> selectedTags = [];
  int duration = 10;
  int lv = 1;
  String lvText = 'เบามาก';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "เป้าหมายการออกกำลังกาย",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Color.fromARGB(255, 255, 255, 255),
                      size: 42,
                    ),
                    onPressed: decreaseDuration,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    "$duration นาที",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: Color.fromARGB(255, 255, 255, 255),
                      size: 42,
                    ),
                    onPressed: addDuration,
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ระยะเวลา",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.directions_run_rounded,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 35,
                  ),
                  // const SizedBox(
                  //   width: 15,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 2, right: 2),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: dropdownValue,
                        alignment: Alignment.center,
                        dropdownColor: Color.fromARGB(255, 0, 0, 0),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        items: <String>[
                          'การเดิน',
                          'การวิ่งแบบเหยาะๆ',
                          'การวิ่งปกติ',
                          'การวิ่งบนลู่วิ่ง',
                          'ปั่นจักรยาน'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(
                                  fontSize: 25,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.remove_circle,
                      color: Color.fromARGB(255, 255, 255, 255),
                      size: 42,
                    ),
                    onPressed: decreaseLv,
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  Text(
                    "LV. $lv $lvText",
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(
                    width: 18,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle,
                      color: Color.fromARGB(255, 255, 255, 255),
                      size: 42,
                    ),
                    onPressed: addLv,
                  ),
                ],
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "ระดับการออกกำลังกาย",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.music_note_rounded,
                      color: Colors.white, size: 35),
                  MultiSelectDialogField(
                    title: const Text('เลือกแนวเพลงที่คุณชอบ'),
                    dialogHeight: 350,
                    items: tagMusictype
                        .map((e) => MultiSelectItem<Musictype>(e, e.name))
                        .toList(),
                    // initialValue: selectedTags,
                    onConfirm: (values) {
                      selectedTags = values;
                      // log(values.toString());
                    },
                    selectedItemsTextStyle:
                        const TextStyle(color: Colors.black),
                    buttonIcon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: 32,
                    ),
                    buttonText: const Text(
                      "เลือกแนวเพลงที่คุณชอบ",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 50),
                child: ElevatedButton(
                  onPressed: addProfile,
                  style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all<Size>(const Size(200, 50)),
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFF8721D)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'สร้างโปรไฟล์ออกกำลังกาย',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void addProfile() {
    log("เวลาออกกำลังกาย $duration");
    log("ประเภทออกกำลงักาย  $dropdownValue");
    log("เลเวลออกกำลังกาย $lv");
    for (var element in selectedTags) {
      log(element.id.toString());
    }
    // Get.to(() => const PlaylistAfterCreatePage());
  }

  void decreaseLv() {
    if (lv > 1) {
      setState(() {
        lv -= 1;
        if (lv == 5) {
          lvText = 'หนักมาก';
        } else if (lv == 4) {
          lvText = 'หนัก';
        } else if (lv == 3) {
          lvText = 'ปานกลาง';
        } else if (lv == 2) {
          lvText = 'เบา';
        } else if (lv == 1) {
          lvText = 'เบามาก';
        }
        lvText;
      });
    }
  }

  void addLv() {
    if (lv < 5) {
      if (lv == 4) {
        lvText = 'หนักมาก';
      } else if (lv == 3) {
        lvText = 'หนัก';
      } else if (lv == 2) {
        lvText = 'ปานกลาง';
      } else if (lv == 1) {
        lvText = 'เบา';
      } else if (lv == 0) {
        lvText = 'เบามาก';
      }
      setState(() {
        lv += 1;
        lvText;
      });
    }
  }

  void decreaseDuration() {
    if (duration > 10) {
      setState(() {
        duration -= 10;
      });
    }
  }

  void addDuration() {
    if (duration < 180) {
      setState(() {
        duration += 10;
      });
    }
  }
}
