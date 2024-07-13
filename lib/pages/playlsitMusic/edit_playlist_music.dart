import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_fitfit_app/model/response/muisc_get_res.dart';
import 'package:frontend_fitfit_app/model/response/playlsit_music_get_res.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/api/playlist_detail.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class EditPlaylistMusicPage extends StatefulWidget {
  late PlaylsitMusicGetResponse? musicPL;
  int wpid = 0;
  int pid = 0;
  // int timeEx = 0;
  EditPlaylistMusicPage(this.wpid, this.pid, {this.musicPL, super.key});

  @override
  State<EditPlaylistMusicPage> createState() => _EditPlaylistMusicPageState();
}

class Musicdata {
  final double musictime;
  final int bpm;

  Musicdata(this.musictime, this.bpm);
}

class _EditPlaylistMusicPageState extends State<EditPlaylistMusicPage> {
  List<Musicdata> chartData = [];
  // ignore: non_constant_identifier_names
  late PlaylsitMusicGetResponse music_pl;
  late PlaylistService playlistService;
  // ignore: prefer_typing_uninitialized_variables
  late var loadData;
  List<MusicGetResponse> newMusicList = [];
  late UserLoginPostResponse user;
  double totalDuration = 0;
  late PlaylistDetailService playlistDetailServ;
  List<Music> musiclist = [];
  @override
  void initState() {
    super.initState();
    playlistService = context.read<AppData>().playlistService;
    playlistDetailServ = context.read<AppData>().playlistDetailService;
    user = context.read<AppData>().user;
    log("pid :${widget.pid}");
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    try {
      if (widget.musicPL == null) {
        music_pl = await playlistService.getPlaylistMusicByPid(widget.pid);
        log(music_pl.playlistName);
        chartData.clear();
        for (var m in music_pl.playlistDetail) {
          chartData.add(Musicdata(m.music.duration, m.music.bpm));
        }
        setState(() {});
      } else {
        music_pl = widget.musicPL!;

        chartData.clear();
        for (var m in music_pl.playlistDetail) {
          chartData.add(Musicdata(m.music.duration, m.music.bpm));
        }
        setState(() {});
      }
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Get.back();
            },
          ),
          // title: const Center(
          //   child: Text(
          //     "เวลา 40 นาที",
          //     style: TextStyle(color: Colors.black),
          //   ),
          // ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save_rounded, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          // ignore: sort_child_properties_last
          child: const FaIcon(
            FontAwesomeIcons.shuffle,
            color: Colors.white,
          ),
          onPressed: () {
            randAll();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: const Color(0xFFF8721D), // สีพื้นหลังของปุ่ม
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.endFloat, // ตำแหน่งของปุ่ม
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
                  onRefresh: () async {},
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 5),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                                const Size(330, 50)),
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.grey),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, color: Colors.white, size: 30),
                              SizedBox(
                                  width: 10), // ระยะห่างระหว่างไอคอนกับข้อความ
                              Text(
                                'ค้นหาเพลง',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
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
      padding: const EdgeInsets.only(bottom: 70),
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
              Row(
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // log(index.toString());
                        // randMusic1Song(index);
                      },
                      iconSize: 16,
                      icon: const FaIcon(
                        FontAwesomeIcons.shuffle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Container(
                    width: 30,
                    height: 30,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        // Add your onPressed logic here
                      },
                      iconSize: 16,
                      icon: const FaIcon(
                        FontAwesomeIcons.trash,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              )
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
      return '${name.substring(0, 20)}..';
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
          primaryXAxis: const CategoryAxis(
             ),
          legend: const Legend(
            isVisible: false,
          ),
          title: ChartTitle(
              text: 'เวลาเพลย์ลิสต์ : ${music_pl.durationPlaylist} นาที'),
          tooltipBehavior: TooltipBehavior(
            enable: true, tooltipPosition: TooltipPosition.pointer,
            format: 'เวลาเพลง point.x นาที : point.y BPM', // Default tooltip format
            header: '',
          ),
          series: <CartesianSeries<Musicdata, double>>[
            LineSeries<Musicdata, double>(
              dataSource: chartData,
              xValueMapper: (Musicdata m, _) => m.musictime,
              yValueMapper: (Musicdata m, _) => m.bpm,
              color: Colors.red,
              // dataLabelSettings: const DataLabelSettings(isVisible: true),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> randAll() async {
    try {
      log("start");
      newMusicList = await playlistDetailServ.getMusicDetailGen(widget.wpid);
      log(newMusicList.length.toString());
      //เปลี่ยน MusicGetResponse ===> music ของ playlist_get  ใช้ แทนที่ใน  music_pl.playlistDetail.music
      musiclist = newMusicList
          .map((musicGetResponse) => musicGetResponse.toMusicPl())
          .toList();

      setState(() {
        chartData.clear();
        for (int i = 0; i < music_pl.playlistDetail.length; i++) {
          if (i < newMusicList.length) {
            music_pl.playlistDetail[i].music = musiclist[i];
          }
        }
      });

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditPlaylistMusicPage(
                widget.wpid, widget.pid,
                musicPL: music_pl)),
      );
    } catch (e) {
      log(e.toString());
    }
  }
  // Future<void> randMusic1Song(int idx) async {
  //   log("1");
  //   RandMusic1PostRequest randMusic = RandMusic1PostRequest(
  //       musicList: musiclist, index: idx, wpid: widget.idx);
  //   musicList = await playlistDetailServ.randomMusic(randMusic);
  //   log(musicList.length.toString());
  //   setState(() {
  //     chartData.clear();
  //     widget.music = musicList;
  //   });

  //   log(widget.music.length.toString());

  //   // ignore: use_build_context_synchronously
  //   Navigator.pushReplacement(
  //     context,
  //     MaterialPageRoute(builder: (BuildContext context) => widget),
  //   );
  // }
}
