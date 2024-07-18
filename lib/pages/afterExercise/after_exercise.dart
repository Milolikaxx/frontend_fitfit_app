import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/pages/barbottom.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../service/model/response/playlsit_with_wp_workoutprofile_get_res.dart';
import '../../service/model/response/workoutProfile_get_res.dart' as pro;
import '../../service/model/response/workout_profile_musictype_get_res.dart';
import '../../service/api/playlist.dart';
import '../../service/api/workout_musictype.dart';
import '../../service/api/workout_profile.dart';
import '../../service/provider/appdata.dart';

class AfterExercisePage extends StatefulWidget {
  final int pid;
  final int wpid;
  const AfterExercisePage(this.pid, this.wpid, {super.key});

  @override
  State<AfterExercisePage> createState() => _AfterExercisePageState();
}

class _AfterExercisePageState extends State<AfterExercisePage> {
  late Future<void> loadData;
  late PlaylistWithWorkoutGetResponse? dePlaylist;
  late WorkoutProfileService wpService;
  late PlaylistService playlsitService;
  late pro.WorkoutProfileGetResponse profile;
  late WorkoutMusicTypeService mtypeService;
  late List<WorkoutProfileMusictypeGetResponse> mtype = [];

  @override
  void initState() {
    super.initState();
    wpService = context.read<AppData>().workoutProfileService;
    playlsitService = context.read<AppData>().playlistService;
    mtypeService = context.read<AppData>().workoutMusicType;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    try {
      profile = await wpService.getProfileByWpid(widget.wpid);
      dePlaylist =
          await playlsitService.getPlaylistWithOutMusicByPid(widget.pid);
    } catch (e) {
      log(e.toString());
    }
    log(widget.wpid.toString());
    log("Length : ${mtype.length}");
    log(profile.duration.toString() ?? 'No duration');
    // log(widget.time.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder<void>(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (profile == null) {
            return const Center(child: Text('Failed to load profile'));
          } else {
            return Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 60),
                  child: const Text(
                    "เสร็จสิ้นการออกกำลังกาย",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ),
                detailBox(profile, mtype),
                Container(
                  margin: const EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      homeButton(),
                      const SizedBox(width: 40),
                      shareButton(),
                    ],
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget detailBox(pro.WorkoutProfileGetResponse profile,
      List<WorkoutProfileMusictypeGetResponse> mtype) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 5),
        decoration: BoxDecoration(
          color: Colors.orange,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  children: [
                    const Text(
                      'ทำเวลาทั้งหมดไป',
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                    Text(
                      "${profile.duration} นาที",
                      style:
                          const TextStyle(color: Colors.white, fontSize: 36.0),
                    ),
                    const Text(
                      'ระยะเวลา',
                      style: TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(
                  child: Text(
                    profile.exerciseType,
                    style: const TextStyle(color: Colors.white, fontSize: 32.0),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: Column(
                  children: [
                    Text(
                      'Lv. ${profile.levelExercise}',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 32.0),
                    ),
                    const Text(
                      'ระดับการออกกำลังกาย',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    const Text(
                      'แนวเพลง',
                      style: TextStyle(color: Colors.white, fontSize: 32.0),
                    ),
                    getTextMusicName()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTextMusicName() {
    return Column(
      children: profile.workoutMusictype
          .map((musicType) => musicTypeWidget(musicType))
          .toList(),
    );
  }

  Widget musicTypeWidget(pro.WorkoutMusictype musicType) {
    return Text(
      musicType.musicType.name,
      style: const TextStyle(color: Colors.white, fontSize: 18),
    );
  }

  Widget homeButton() {
    return TextButton(
      onPressed: () {
        Get.to(() => const Barbottom(initialIndex: 0));
      },
      child: const Text(
        "กลับหน้าหลัก",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget shareButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(20),
      ),
      child: TextButton(
        onPressed: () {},
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.share,
              color: Colors.white,
            ),
            SizedBox(width: 8),
            Text(
              'แชร์',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
