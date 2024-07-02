import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/model/request/workoutMusicType_post_req.dart';
import 'package:frontend_fitfit_app/model/request/workoutProfile_post_req.dart';
import 'package:frontend_fitfit_app/model/response/musictype_get_res.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/model/response/workoutProfile_get_res.dart';
import 'package:frontend_fitfit_app/service/api/musictype.dart';
import 'package:frontend_fitfit_app/service/api/workout_musictype.dart';
import 'package:frontend_fitfit_app/service/api/workout_profile.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:multi_select_flutter/dialog/multi_select_dialog_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class SaveProfilePage extends StatefulWidget {
  WorkoutProfileGetResponse profile;
  SaveProfilePage(this.profile, {super.key});

  @override
  State<SaveProfilePage> createState() => _SaveProfilePageState();
}

class _SaveProfilePageState extends State<SaveProfilePage> {
  late MusicTypeService musictypeService;
  // ignore: prefer_typing_uninitialized_variables
  late var loadData;
  late UserLoginPostResponse user;
  late WorkoutProfileService wpService;
  late WorkoutMusicTypeService wpMusictypeService;
  String levelDescription = '';
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
    switch (widget.profile.levelExercise) {
      case 5:
        levelDescription = 'หนักมาก';
        break;
      case 4:
        levelDescription = 'หนัก';
        break;
      case 3:
        levelDescription = 'ปานกลาง';
        break;
      case 2:
        levelDescription = 'เบา';
        break;
      case 1:
        levelDescription = 'เบามาก';
        break;
      default:
        levelDescription = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: LoadingAnimationWidget.beat(
                    color: Colors.white,
                    size: 50,
                  ),
                );
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
                            onPressed: () {},
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            "${widget.profile.duration} นาที",
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
                            onPressed: () {},
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
                                value: widget.profile.exerciseType,
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
                                onChanged: null,
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
                            onPressed: () {},
                          ),
                          const SizedBox(
                            width: 18,
                          ),
                          Text(
                            "LV. ${widget.profile.levelExercise} $levelDescription",
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
                            onPressed: () {},
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
                            getTextMusicName(widget.profile.workoutMusictype)
                            ],
                          ),
                        ),
                      ),
                      //  (selectedTags.isEmpty) ? const Text("***กรุณาเลือกแนวเพลง",style: TextStyle(fontSize: 16, color: Colors.white)) : Container(),
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
                    ],
                  ),
                ),
              );
            }));
  }
  Widget getTextMusicName(List<WorkoutMusictype> musicTypes) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: musicTypes
              .asMap()
              .map((index, musicType) {
                String text = musicType.musicType.name;
                if (index != musicTypes.length-1) {
                  text="$text : ";
                }
                return MapEntry(
                  index,
                  Text(
                    text,
                    style: const TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                    ),
                  ),
                );
              })
              .values
              .toList()),
    );
  }
  Future<void> addProfile() async {
    log("เวลาออกกำลังกาย ${widget.profile.duration}");
    log("ประเภทออกกำลงักาย  ${widget.profile.exerciseType}");
    log("เลเวลออกกำลังกาย ${widget.profile.levelExercise}");

      WorkoutProfilePostRequest wpObj = WorkoutProfilePostRequest(
          uid: user.uid!,
          levelExercise: widget.profile.levelExercise,
          duration: widget.profile.duration,
          exerciseType: widget.profile.exerciseType);
      try {
        int res = await wpService.saveWP(wpObj);
        if (res != 0) {
          log(res.toString());
          for (var element in widget.profile.workoutMusictype) {
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
          
        }
      } catch (e) {
        log(e.toString());
      }

  }
}
