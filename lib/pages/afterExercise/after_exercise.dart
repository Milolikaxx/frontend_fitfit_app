import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/pages/home/home.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../model/response/playlsit_with_wp_workoutprofile_get_res.dart';
import '../../model/response/workoutProfile_get_res.dart';
import '../../service/api/playlist.dart';
import '../../service/api/workout_profile.dart';
import '../../service/provider/appdata.dart';

// ignore: must_be_immutable
class AfterExercisePage extends StatefulWidget {
  final int pid;
  final int wpid;
  const AfterExercisePage(this.pid, this.wpid, {super.key});

  @override
  State<AfterExercisePage> createState() => _AfterExercisePageState();
}

class _AfterExercisePageState extends State<AfterExercisePage> {
  late Future<void> loadData;
  PlaylistWithWorkoutGetResponse? dePlaylist;
  WorkoutProfileService? wpService;
  PlaylistService? playlsitService;
  WorkoutProfileGetResponse? profile;

  @override
  void initState() {
    super.initState();
    wpService = context.read<AppData>().workoutProfileService;
    playlsitService = context.read<AppData>().playlistService;
    loadData = loadDataAsync();
  }

  Future<void> loadDataAsync() async {
    try {
      profile = await wpService!.getProfileByWpid(widget.wpid);
      dePlaylist =
          await playlsitService!.getPlaylistWithOutMusicByPid(widget.pid);
    } catch (e) {
      log(e.toString());
    }
    log(profile?.duration.toString() ?? 'No duration');
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
                Expanded(
                  child: detailBox(profile!),
                ),
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

  Widget detailBox(WorkoutProfileGetResponse profile) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 10, top: 5),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(20),
      ),
      child: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 60.0),
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
              const Padding(
                padding: EdgeInsets.only(top: 60),
                child: Text(
                  'การวิ่ง',
                  style: TextStyle(color: Colors.white, fontSize: 32.0),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 60.0),
                child: Column(
                  children: [
                    Text(
                      'Lv. 3',
                      style: TextStyle(color: Colors.white, fontSize: 32.0),
                    ),
                    Text(
                      'ระดับการออกกำลังกาย',
                      style: TextStyle(color: Colors.white, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 60),
                child: Text(
                  'เพลงสากล',
                  style: TextStyle(color: Colors.white, fontSize: 24.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget homeButton() {
    return TextButton(
      onPressed: () {
        Get.to(() => const HomePage());
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
