import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_fitfit_app/model/response/playlsit_with_wp_workoutprofile_get_res.dart';
import 'package:frontend_fitfit_app/pages/playMusic/play_musicpage.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:get/get.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
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
  late var loadData;
  late PlaylistService playlsitService;
  late PlaylistWithWorkoutGetResponse dePlaylist;
  @override
  void initState() {
    super.initState();
    playlsitService = context.read<AppData>().playlistService;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    try {
      dePlaylist =
          await playlsitService.getPlaylistWithOutMusicByPid(widget.pid);
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
            ),
            onPressed: () {
               Get.back();
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
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        cardDetailsWp(dePlaylist),
                        const SizedBox(
                          height: 10,
                        ),
                        playlsitWork(dePlaylist)
                      ],
                    ),
                  ),
                );
              }),
        ));
  }

  Widget cardDetailsWp(PlaylistWithWorkoutGetResponse playlsit) {
    String levelDescription;
    switch (playlsit.workoutProfile.levelExercise) {
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
          color: Colors.white,
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
                  color: Colors.black),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.clock,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(
                  width: 9,
                ),
                Text(
                  "${playlsit.workoutProfile.duration} นาที ",
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.personRunning,
                  color: Colors.black,
                  size: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    playlsit.workoutProfile.exerciseType,
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ],
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.chartColumn,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  playlsit.workoutProfile.levelExercise > 0
                      ? 'Lv.${playlsit.workoutProfile.levelExercise} $levelDescription'
                      : '',
                  style: const TextStyle(fontSize: 16, color: Colors.black),
                ),
              ],
            ),
            Row(
              // crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.music,
                  color: Colors.black,
                  size: 20,
                ),
                const SizedBox(
                  width: 10,
                ),
                getTextMusicName(playlsit.workoutProfile.workoutMusictype)
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
                    color: Colors.black,
                  ),
                ),
              );
            })
            .values
            .toList());
  }

  Widget playlsitWork(PlaylistWithWorkoutGetResponse dePlaylist) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "เพลย์ลิสต์เพลงที่ใช้ออกกำลังกาย",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        GestureDetector(
            // onTap: () => _openDestinationPage(context),
            child: _buildFeaturedItem(
          image: dePlaylist.imagePlaylist,
          title: dePlaylist.playlistName,
        )),
        Padding(
          padding: const EdgeInsets.only(
            top: 20,
          ),
          child: ElevatedButton(
            onPressed: () {
              Get.to(() => PlayMusicPage(dePlaylist.pid));
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

  Container _buildFeaturedItem({required String image, required String title}) {
    return Container(
      padding: const EdgeInsets.only(top: 5),
      width: 350,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: NetworkImage(image),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            right: 10.0,
            top: 10.0,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.playlist_play_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          Positioned(
            bottom: 20.0,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              color: Colors.black.withOpacity(0.7),
              child: Row(
                children: [
                  Text(
                      title.length > 10
                          ? '${title.substring(0, 10)}...'
                          : title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
