import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_fitfit_app/model/response/playlsitl_in_workoutprofile_get_res.dart';
import 'package:frontend_fitfit_app/model/response/workoutProfile_get_res.dart';
import 'package:frontend_fitfit_app/pages/edit_playlsitpage.dart';
import 'package:frontend_fitfit_app/pages/music_playlsitpage.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/api/workout_profile.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ShowWorkoutProfilePage extends StatefulWidget {
  int idx = 0;
  ShowWorkoutProfilePage(this.idx, {super.key});

  @override
  State<ShowWorkoutProfilePage> createState() => _ShowWorkoutProfilePageState();
}

enum Menu { preview, share, remove, edit }

class _ShowWorkoutProfilePageState extends State<ShowWorkoutProfilePage> {
  // GoogleSignInAccount? user;
  late WorkoutProfileGetResponse profile;
  late var loadData;
  late WorkoutProfileService wpService;
  late PlaylistService playlsitService;
  List<PlaylsitlInWorkoutprofileGetResponse> playlistWp = [];
  @override
  void initState() {
    super.initState();
    wpService = context.read<AppData>().workoutProfileService;
    playlsitService = context.read<AppData>().playlistService;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    try {
      profile = await wpService.getProfileByWpid(widget.idx);
    } catch (e) {
      log(e.toString());
    } finally {
      log(profile.wpid.toString());
      playlistWp = await playlsitService.getPlaylistByWpid(profile.wpid);
      log(playlistWp.first.playlistName);
    }
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  cardDetailsWp(profile),
                  const SizedBox(
                    height: 10,
                  ),
                  (playlistWp.isNotEmpty)
                      ? const Text(
                          'เพลย์ลิสต์เพลงของฉัน',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )
                      : const Text(""),
                  (playlistWp.isNotEmpty)
                      ? list()
                      : const Text('ยังไม่มีเพลย์ลิสต์เพลง',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                ],
              );
            }));
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
          // color: const Color(0x66CCCCCC),
          color: Colors.white,
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
                  "${profile.duration} นาที ",
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
                    profile.exerciseType,
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
                  profile.levelExercise > 0
                      ? 'Lv.${profile.levelExercise} $levelDescription'
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
        // mainAxisAlignment: MainAxisAlignment.start,
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

  Widget list() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        itemCount: playlistWp.isEmpty ? 0 : playlistWp.length,
        itemBuilder: (context, index) => playlistAll(playlistWp[index]),
      ),
    );
  }

  Widget playlistAll(PlaylsitlInWorkoutprofileGetResponse pl) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: Container(
        width: 350,
        decoration: const BoxDecoration(
          color: Color(0xff2E2F33),
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        padding: const EdgeInsets.only(right: 20),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(pl.imagePlaylist),
                  fit: BoxFit.cover,
                ),
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4)),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(pl.playlistName,
                      style: const TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          overflow: TextOverflow.clip)),
                  PopupMenuButton<Menu>(
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.white,
                    ),
                    onSelected: (Menu item) {
                      switch (item) {
                        case Menu.preview:
                         Get.to(() => MusicPlaylistPage(pl.pid));
                          break;
                        case Menu.share:
                         
                          break;
                        case Menu.remove:
                          
                          break;
                        case Menu.edit:
                          Get.to(() => EditPlaylistPage(pl.pid));
                          break;
                      }
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<Menu>>[
                      const PopupMenuItem<Menu>(
                        value: Menu.preview,
                        child: ListTile(
                          leading: Icon(Icons.visibility_outlined),
                          title: Text('ดูเพลงในเพลย์ลิสต์'),
                        ),
                      ),
                      const PopupMenuItem<Menu>(
                        value: Menu.share,
                        child: ListTile(
                          leading: Icon(Icons.share_outlined),
                          title: Text('แชร์'),
                        ),
                      ),

                      // const PopupMenuDivider(),
                      const PopupMenuItem<Menu>(
                        value: Menu.remove,
                        child: ListTile(
                          leading: Icon(Icons.delete_outline),
                          title: Text('ลบ'),
                        ),
                      ),
                      const PopupMenuItem<Menu>(
                        value: Menu.edit,
                        child: ListTile(
                          leading: Icon(Icons.edit_outlined),
                          title: Text('แก้ไข'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
