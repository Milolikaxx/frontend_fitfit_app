import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_fitfit_app/model/response/playlsit_music_get_res.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/model/response/workoutProfile_get_res.dart';
import 'package:frontend_fitfit_app/pages/afterExercise/after_exercise.dart';
import 'package:frontend_fitfit_app/pages/savePlaylist_UOther/save_wp_page.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/api/workout_profile.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PlaylistUserOtherPage extends StatefulWidget {
  int idx = 0;

  String username;

  String playlistname;

  String imageProfile;

  PlaylistUserOtherPage(
      this.idx, this.username, this.playlistname, this.imageProfile,
      {super.key});

  @override
  State<PlaylistUserOtherPage> createState() => _PlaylistUserOtherPageState();
}

class Musicdata {
  final double musictime;
  final int bpm;

  Musicdata(this.musictime, this.bpm);
}

class _PlaylistUserOtherPageState extends State<PlaylistUserOtherPage> {
  List<Musicdata> chartData = [];
  late PlaylsitMusicGetResponse music_pl;

  late PlaylistService playlistService;
  // ignore: prefer_typing_uninitialized_variables
  late WorkoutProfileGetResponse profile;
  late var loadData;
  late WorkoutProfileService wpService;
  late UserLoginPostResponse user;
  // double totalDuration = 0;

  @override
  void initState() {
    super.initState();
    playlistService = context.read<AppData>().playlistService;
    wpService = context.read<AppData>().workoutProfileService;
    user = context.read<AppData>().user;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    try {
      music_pl = await playlistService.getPlaylistMusicByPid(widget.idx);
      profile = await wpService.getProfileByWpid(music_pl.wpid);
      log(profile.exerciseType);
      chartData.clear();
      // totalDuration = 0;
      // for (var m in music_pl.playlistDetail) {
      //   chartData.add(Musicdata(m.music.duration, m.music.bpm));
      //   totalDuration += m.music.duration;
      // }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.info,
                  size: 30, color: Color.fromARGB(255, 255, 255, 255)),
              onPressed: () async {
                showDialog<String>(
                    context: context,
                    builder: (BuildContext context) => Dialog(
                          child: Container(
                            constraints: BoxConstraints(
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.8),
                            child: SingleChildScrollView(
                              child: cardDetailsWp(profile),
                            ),
                          ),
                        ));
              },
            ),
            IconButton(
              icon: const Icon(Icons.save,
                  size: 30, color: Color.fromARGB(255, 255, 255, 255)),
              onPressed: () async {
                log(profile.duration.toString());
                Get.to(() => SaveProfilePage(profile, music_pl.playlistDetail));
              },
            ),
          ],
        ),
        body: FutureBuilder(
            future: loadData,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: LoadingAnimationWidget.beat(
                    color: Colors.black,
                    size: 50,
                  ),
                );
              }
              return RefreshIndicator(
                  color: const Color(0xFFF8721D),
                  onRefresh: () async {
                    setState(() {
                      loadData = loadDataAsync();
                    });
                  },
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        color: Colors.black,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                            children: [
                              Image.network(
                                music_pl.imagePlaylist,
                                width: 200,
                                height: 200,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        widget.imageProfile,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.playlistname} (${music_pl.totalDuration} นาที)",
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 16),
                                        ),
                                        Text(
                                          "playlsit by ${widget.username} ",
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 16),
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
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const ScrollPhysics(),
                          child: Column(
                            children: [
                              musicGraph(),
                              const Padding(
                                padding: EdgeInsets.only(
                                    left: 85, right: 35, top: 5),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Title",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                    Icon(Icons.access_time_rounded,
                                        color: Colors.black),
                                  ],
                                ),
                              ),
                              listMusic(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ));
            }));
  }

  Widget listMusic() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(bottom: 60),
      shrinkWrap: true,
      itemCount:
          music_pl.playlistDetail.isEmpty ? 0 : music_pl.playlistDetail.length,
      itemBuilder: (context, index) =>
          musicInfo(music_pl.playlistDetail[index]),
    );
  }

  Widget musicInfo(PlaylistDetail playlistDetail) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: NetworkImage(playlistDetail.music.musicImage),
                width: 65,
                height: 65,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      formatMusicName(playlistDetail.music.name),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      playlistDetail.music.artist,
                      style:
                          const TextStyle(color: Color.fromARGB(161, 0, 0, 0)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                playlistDetail.music.duration.toString(),
                style: const TextStyle(
                    color: Color.fromARGB(161, 0, 0, 0), fontSize: 12),
              ),
              Text(
                "${playlistDetail.music.bpm} bpm",
                style: const TextStyle(
                    color: Color.fromARGB(161, 0, 0, 0), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String formatMusicName(String name) {
    // Remove .mp extension
    if (name.endsWith('.mp')) {
      name = name.substring(0, name.length - 3);
    }
    // Truncate to 10 characters and add ellipsis if necessary
    if (name.length > 25) {
      return '${name.substring(0, 25)}..';
    }
    return name;
  }

  Widget musicGraph() {
    return Container(
      color: Colors.white,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.2,
        child: SfCartesianChart(
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(
            isVisible: false,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <CartesianSeries<Musicdata, double>>[
            LineSeries<Musicdata, double>(
              dataSource: chartData,
              xValueMapper: (Musicdata m, _) => m.musictime,
              yValueMapper: (Musicdata m, _) => m.bpm,
              color: Colors.red,
              dataLabelSettings: const DataLabelSettings(isVisible: false),
            ),
          ],
        ),
      ),
    );
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
          padding: const EdgeInsets.all(30),
          child: Column(children: [
            const Text(
              'ข้อมูลโปรไฟล์ออกกำลังกาย',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
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
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
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
              .toList()),
    );
  }
}
