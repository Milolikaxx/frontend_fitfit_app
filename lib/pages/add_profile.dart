import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/model/request/workoutMusicType_post_req.dart';
import 'package:frontend_fitfit_app/model/request/workoutProfile_post_req.dart';
import 'package:frontend_fitfit_app/model/response/musictype_get_res.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/pages/editplaylist_after_create.dart';
import 'package:frontend_fitfit_app/pages/playlist_after_create.dart';
import 'package:frontend_fitfit_app/service/api/musictype.dart';
import 'package:frontend_fitfit_app/service/api/workout_musictype.dart';
import 'package:frontend_fitfit_app/service/api/workout_profile.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';

class AddProfilePage extends StatefulWidget {
  const AddProfilePage({super.key});

  @override
  State<AddProfilePage> createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
  String dropdownValue = 'การเดิน';
  late List<MusictypeGetResponse> tagMusictype = [];
  List<MusictypeGetResponse> selectedTags = [];
  int duration = 10;
  int lv = 1;
  String lvText = 'เบามาก';
  late MusicTypeService musictypeService;
  late var loadData;
  late UserLoginPostResponse user;
  late WorkoutProfileService wpService;
  late WorkoutMusicTypeService wpMusictypeService;
  @override
  void initState() {
    super.initState();
    musictypeService = context.read<AppData>().musicTypeService;
    wpService = context.read<AppData>().workoutProfileService;
    wpMusictypeService = context.read<AppData>().workoutMusicType;
    user = context.read<AppData>().user;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    // String url = 'http://202.28.34.197/tripbooking/trip/${widget.idx}';
    // var value = await http.get(Uri.parse(url));
    // trip = tripGetResponseFromJson(value.body);
    // log(value.body);
    tagMusictype = await musictypeService.getMusictype();
    // setState(() {
    //   trip = tripGetResponseFromJson(value.body);
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 0, 0, 0),
          automaticallyImplyLeading: false,
        ),
        body: FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const CircularProgressIndicator();
              }
              return SingleChildScrollView(
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
                                dropdownColor:
                                    const Color.fromARGB(255, 0, 0, 0),
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
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Center(
                          child: Row(
                            children: [
                              const Icon(Icons.music_note_rounded,
                                  color: Colors.white, size: 35),
                              MultiSelectDialogField(
                                title: const Text('เลือกแนวเพลงที่คุณชอบ'),
                                dialogHeight: 350,
                                items: tagMusictype
                                    .map((e) =>
                                        MultiSelectItem<MusictypeGetResponse>(
                                            e, e.name))
                                    .toList(),
                                // initialValue: selectedTags,
                                onConfirm: (values) {
                                  selectedTags = values;
                                  log(values.toString());
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

                                checkColor: Colors
                                    .white, // เปลี่ยนสีของ checkbox เมื่อถูกเลือก
                                selectedColor: const Color(
                                    0xFFF8721D), // เปลี่ยนสีของรายการที่ถูกเลือก
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: ElevatedButton(
                          onPressed: addProfile,
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(200, 50)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFF8721D)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
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
                      Padding(
                        padding: const EdgeInsets.only(bottom: 50),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(200, 50)),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                const Color(0xFFF8721D)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          child: const Text(
                            'เทสสร้างหน้า',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }));
  }

  Future<void> addProfile() async {
    log("เวลาออกกำลังกาย $duration");
    log("ประเภทออกกำลงักาย  $dropdownValue");
    log("เลเวลออกกำลังกาย $lv");
    for (var element in selectedTags) {
      log(element.mtid.toString());
    }

    if (selectedTags == []) {
      Get.snackbar('กรุณาเลือกแนวเพลง', '');
    } else {
      WorkoutProfilePostRequest wpObj = WorkoutProfilePostRequest(
          uid: user.uid!,
          levelExercise: lv,
          duration: duration,
          exerciseType: dropdownValue);
      try {
        int res = await wpService.saveWP(wpObj);
        if (res != 0) {
          log(res.toString());
          for (var element in selectedTags) {
            log(element.mtid.toString());
            WorkoutMusicTypePostRequest wpMtObj =
                WorkoutMusicTypePostRequest(wpid: res, mtid: element.mtid);
            try {
              int response = await wpMusictypeService.saveWPMT(wpMtObj);
              if (response > 0) {
                log('เพิ่มแนวเพลงโปรไฟล์ออกกำลังกายสำเร็จ');
              }
            } catch (e) {
              log(e.toString());
            }
          }
          log('เพิ่มโปรไฟล์ออกกำลังกายสำเร็จ');
          var profile = await wpService.getProfileByWpid(res);
          if (profile.uid > 0 ){
            Get.to(() => PlaylistAfterCreatePage(res,profile.duration));
          }
          
        }
      } catch (e) {
        log(e.toString());
      }
    }
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
