import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_fitfit_app/model/response/playlsitl_in_workoutprofile_get_res.dart';
import 'package:frontend_fitfit_app/model/response/workoutProfile_get_res.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/api/workout_profile.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PreExercisePage extends StatefulWidget {
  int wpid = 0;
  int pid = 0;
  PreExercisePage(this.wpid, this.pid, {super.key});

  @override
  State<PreExercisePage> createState() => _PreExercisePageState();
}

class _PreExercisePageState extends State<PreExercisePage> {
  late WorkoutProfileGetResponse profile;
  late var loadData;
  late WorkoutProfileService wpService;
  late PlaylistService playlsitService;
  late PlaylistInWorkoutprofileGetResponse dePlaylist;
  @override
  void initState() {
    super.initState();
    wpService = context.read<AppData>().workoutProfileService;
    playlsitService = context.read<AppData>().playlistService;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    try {
      profile = await wpService.getProfileByWpid(widget.wpid);
    } catch (e) {
      log(e.toString());
    } finally {
      dePlaylist =
          await playlsitService.getPlaylistWithOutMusicByPid(widget.pid);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFFF8721D),
              
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: RefreshIndicator(
          color: const Color(0xFFF8721D),
          onRefresh: () async {
            setState(() {
              loadData = loadDataAsync();
            });
          },
          child: FutureBuilder(
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

                return Expanded(
                  child: Column(
                    children: [
                      cardDetailsWp(profile),
                      const SizedBox(
                        height: 10,
                      ),
                      playlsitWork(dePlaylist)
                    ],
                  ),
                );
              }),
        ));
  }

  Widget cardDetailsWp(WorkoutProfileGetResponse profile) {
    String levelDescription;
    switch (profile.levelExercise) {
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
    // Color cardColor = Colors.w
    return Center(
      child: Container(
        width: 350,
        padding: const EdgeInsets.only(top: 5),
        decoration: ShapeDecoration(
          color: const Color(0xFFF8721D),
          // color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(children: [
            const Text(
              'ข้อมูลโปรไฟล์ออกกำลังกาย',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.clock,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(
                  width: 9,
                ),
                Text(
                  "${profile.duration} นาที ",
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.personRunning,
                  color: Colors.white,
                  size: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    profile.exerciseType,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.chartColumn,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  profile.levelExercise > 0
                      ? 'Lv.${profile.levelExercise} $levelDescription'
                      : '',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ],
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.music,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                getTextMusicName(profile.workoutMusictype)
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Widget getTextMusicName(List<WorkoutMusictype> musicTypes) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: musicTypes
            .asMap()
            .map((index, musicType) {
              String text = musicType.musicType.name;
              if (index != musicTypes.length - 1) {
                text;
              }
              return MapEntry(
                index,
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              );
            })
            .values
            .toList());
  }

  Widget playlsitWork(PlaylistInWorkoutprofileGetResponse dePlaylist) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "เพลย์ลิสต์เพลงที่ใช้ออกกำลังกาย",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          width: 350,
          height: 250,
          decoration: BoxDecoration(
              // border: Border.all(width: 3, color: Colors.white),
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              shape: BoxShape.rectangle,
              image: DecorationImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  image: NetworkImage(dePlaylist.imagePlaylist))),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  dePlaylist.playlistName,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                const Icon(
                  Icons.playlist_play_rounded,
                  size: 30,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top:20 ,),
          child: ElevatedButton(
            onPressed: () {
              // Get.to(() => const SignUpPage());
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(const Size(330, 50)),
              backgroundColor:
                  MaterialStateProperty.all<Color>(const Color(0xFFF8721D)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
            child: const Text(
              'เริ่มออกกำลังกาย',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
