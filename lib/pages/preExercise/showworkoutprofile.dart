// ignore_for_file: library_prefixes

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_fitfit_app/model/response/playlsit_with_wp_workoutprofile_get_res.dart';
import 'package:frontend_fitfit_app/model/response/workoutProfile_get_res.dart'
    as GetWP;
import 'package:frontend_fitfit_app/pages/barbottom.dart';
import 'package:frontend_fitfit_app/pages/playlistAfterCreate/playlist_after_create.dart';
import 'package:frontend_fitfit_app/pages/playlsit/edit_playlsitpage.dart';
import 'package:frontend_fitfit_app/pages/playlsit/playlist_wp_page.dart';
import 'package:frontend_fitfit_app/pages/playlsitMusic/playlsit_music_page.dart';
import 'package:frontend_fitfit_app/pages/preExercise/preExercise.dart';
import 'package:frontend_fitfit_app/pages/share/post.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/api/workout_profile.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ShowWorkoutProfilePage extends StatefulWidget {
  int idx = 0;
  ShowWorkoutProfilePage(this.idx, {super.key});

  @override
  State<ShowWorkoutProfilePage> createState() => _ShowWorkoutProfilePageState();
}

enum Menu { preview, share, remove, edit }

class _ShowWorkoutProfilePageState extends State<ShowWorkoutProfilePage> {
  // GoogleSignInAccount? user;
  late GetWP.WorkoutProfileGetResponse profile;
  late var loadData;
  late WorkoutProfileService wpService;
  late PlaylistService playlsitService;
  List<PlaylistWithWorkoutGetResponse> playlistWp = [];
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
      log(profile.wpid.toString());
      playlistWp = await playlsitService.getPlaylistByWpid(profile.wpid);
      if (playlistWp.isNotEmpty) {
        log(playlistWp.first.playlistName);
      } else {
        log("Playlist is null or empty");
      }
    } catch (e) {
      log(e.toString());
    } finally {}
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
              Get.back();
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_box_rounded,
                  color: Color.fromARGB(255, 255, 255, 255)),
              onPressed: () async {
                Get.to(
                    () => CreatePlaylsitPage(profile.wpid, profile.duration));
              },
            ),
          ],
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

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
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
                  ),
                );
              }),
        ));
  }

  Widget cardDetailsWp(GetWP.WorkoutProfileGetResponse profile) {
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
          padding: const EdgeInsets.all(30),
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

  Widget getTextMusicName(List<GetWP.WorkoutMusictype> musicTypes) {
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
        padding: const EdgeInsets.symmetric(vertical: 10),
        itemCount: playlistWp.isEmpty ? 0 : playlistWp.length,
        itemBuilder: (context, index) => playlistAll(playlistWp[index]),
      ),
    );
  }

  Widget playlistAll(PlaylistWithWorkoutGetResponse pl) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5),
      child: InkWell(
        onTap: () {
          Get.to(() => PreExercisePage(pl.wpid, pl.pid));
        },
        child: Card(
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
                      Text(
                        pl.playlistName.length > 10
                            ? '${pl.playlistName.substring(0, 10)}...'
                            : pl.playlistName,
                        style: const TextStyle(
                          color: Color(0xffffffff),
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          fontStyle: FontStyle.normal,
                          overflow: TextOverflow.clip,
                        ),
                      ),
                      PopupMenuButton<Menu>(
                        icon: const Icon(
                          Icons.more_vert,
                          color: Colors.white,
                        ),
                        onSelected: (Menu item) {
                          switch (item) {
                            case Menu.preview:
                              log(pl.pid.toString());
                              Get.to(() => MusicPlaylistPage(pl.pid));
                              break;
                            case Menu.share:
                              Get.to(() => PostPage(pl.pid));
                              break;
                            case Menu.remove:
                              delPlaylist(pl.pid);
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
        ),
      ),
    );
  }

  Future<void> delPlaylist(pid) async {
    // ignore: use_build_context_synchronously
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: const Text("ยืนยันเพลย์ลิสต์!"),
              titleTextStyle: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 20),
              actionsOverflowButtonSpacing: 20,
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFF8721D)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  child: const Text(
                    "ยกเลิก",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      log(pid.toString());
                      int res = await playlsitService.deletePlaylsit(pid);
                      log(res.toString());
                      if (res == 1) {
                        log("deleted successfully. Response code: $res");
                        Get.to(() => const Barbottom());
                        setState(() {
                          loadData = loadDataAsync();
                        });
                      } else {
                        log("Failed . Response code: $res");
                      }
                    } catch (e) {
                      log("Error: $e");
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color(0xFFF8721D)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                  child: const Text(
                    "ยืนยัน",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
              content: const Text("กรุณายืนยันการลบ"),
            ));
  }
}
