import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_fitfit_app/pages/barbottom.dart';
import 'package:frontend_fitfit_app/pages/playlsitMusic/search_music.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/api/playlist_detail.dart';
import 'package:frontend_fitfit_app/service/model/request/playlsit_detail_postUp_req.dart';
import 'package:frontend_fitfit_app/service/model/request/rand_one_song_of_playlist_req.dart';
import 'package:frontend_fitfit_app/service/model/response/muisc_get_res.dart';
import 'package:frontend_fitfit_app/service/model/response/playlsit_music_get_res.dart'
    as modelGetPlaylist;
import 'package:frontend_fitfit_app/service/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class EditPlaylistMusicPage extends StatefulWidget {
  late modelGetPlaylist.PlaylsitMusicGetResponse? musicPL;
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
  late modelGetPlaylist.PlaylsitMusicGetResponse musicPL;
  late PlaylistService playlistService;
  late Future<void> loadData;
  List<MusicGetResponse> newMusicList = [];
  late UserLoginPostResponse user;
  double totalDuration = 0;
  late PlaylistDetailService playlistDetailServ;
  List<modelGetPlaylist.Music> musiclist = [];
  List<modelGetPlaylist.PlaylistDetail> musicListofPlaylist = [];
  double totalTime = 0;
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
        musicPL = await playlistService.getPlaylistMusicByPid(widget.pid);
        log(musicPL.playlistName);
        chartData.clear();
        for (var m in musicPL.playlistDetail) {
          chartData.add(Musicdata(m.music.duration, m.music.bpm));
        }
        totalTime = musicPL.totalDuration;
        setState(() {});
      } else {
        musicPL = widget.musicPL!;
        chartData.clear();
        for (var m in musicPL.playlistDetail) {
          chartData.add(Musicdata(m.music.duration, m.music.bpm));
          totalTime += m.music.duration;
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
          actions: [
            IconButton(
              icon: const Icon(Icons.save_rounded, color: Colors.black),
              onPressed: () {
                upPlaylistDe();
              },
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
                          onPressed: () {
                            Get.to(() => SearchMusicPage(musicPL.wpid));
                          },
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
          musicPL.playlistDetail.isEmpty ? 0 : musicPL.playlistDetail.length,
      itemBuilder: (context, index) =>
          musicInfo(musicPL.playlistDetail[index], index),
    );
  }

  Widget musicInfo(modelGetPlaylist.PlaylistDetail playlistDetail, int index) {
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
                        log(index.toString());
                        randMusic1Song(index);
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
                        log(index.toString());
                        delSong(index);
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

  Future<void> delSong(int idx) async {
    RandOneSongOfPlaylistRequest delMusic = RandOneSongOfPlaylistRequest(
        playlistDetail: musicPL.playlistDetail, index: idx);
    musicListofPlaylist =
        await playlistDetailServ.delMusicPlaylistDetail(delMusic);

    setState(() {
      chartData.clear();
      musicPL.playlistDetail = musicListofPlaylist;
    });
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) =>
              EditPlaylistMusicPage(widget.wpid, widget.pid, musicPL: musicPL)),
    );
  }

  String formatMusicName(String name) {
    if (name.length > 20) {
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
          primaryXAxis: const CategoryAxis(),
          legend: const Legend(
            isVisible: false,
          ),
          title: ChartTitle(
              text: 'เวลาเพลย์ลิสต์ : ${totalTime.toStringAsFixed(2)} นาที'),
          tooltipBehavior: TooltipBehavior(
            enable: true, tooltipPosition: TooltipPosition.pointer,
            format:
                'เวลาเพลง point.x นาที : point.y BPM', // Default tooltip format
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
      //เปลี่ยน MusicGetResponse ===> music ของ playlist_get  ใช้ แทนที่ใน  musicPL.playlistDetail.music
      musiclist = newMusicList
          .map((musicGetResponse) => musicGetResponse.toMusicPl())
          .toList();

      chartData.clear();
      //re-data
      var fetchedMusicPL =
          await playlistService.getPlaylistMusicByPid(widget.pid);

      setState(() {
        musicPL = fetchedMusicPL;
        log(musicPL.playlistDetail.length.toString());
        for (int i = 0; i < musicPL.playlistDetail.length; i++) {
          if (i < newMusicList.length) {
            musicPL.playlistDetail[i].music = musiclist[i];
          }
        }
      });
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => EditPlaylistMusicPage(
                widget.wpid, widget.pid,
                musicPL: musicPL)),
      );
    } catch (e) {
      log(e.toString());
    }
  }


  Future<void> randMusic1Song(int idx) async {
    log("1");

    RandOneSongOfPlaylistRequest randMusic = RandOneSongOfPlaylistRequest(
        playlistDetail: musicPL.playlistDetail, index: idx, wpid: widget.wpid);
    musicListofPlaylist = await playlistDetailServ.random1song(randMusic);

    setState(() {
      chartData.clear();
      for (int i = 0; i < musicPL.playlistDetail.length; i++) {
        musicPL.playlistDetail[i] = musicListofPlaylist[i];
        widget.musicPL = musicPL;
      }
    });
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) =>
              EditPlaylistMusicPage(widget.wpid, widget.pid, musicPL: musicPL)),
    );
  }

  Future<void> upPlaylistDe() async {
    if (widget.musicPL == null) {
      Get.snackbar(
        'ไม่มีการแก้ไขเพลงในเพลย์ลิสต์', // Title
        'หากต้องการแก้ไขข้อมูลในเพลงในเพลย์ลิสต์', // Message
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
      setState(() {});
    } else {
      try {
        for (var m in musicPL.playlistDetail) {
          log(m.music.name);
          log(m.mid.toString());
          PlaylsitDetailPostUpdateRequest addMusic =
              PlaylsitDetailPostUpdateRequest(id: m.id, pid: m.pid, mid: m.mid);
          try {
            int resAddmusic = await playlistDetailServ.update(addMusic);
            if (resAddmusic != 0) {
              log('สำเร็จ');
            } else {
              log('ไม่สำเร็จ');
            }
          } catch (e) {
            log(e.toString());
          }
        }
      } catch (e) {
        log(e.toString());
      } finally {
        // ignore: use_build_context_synchronously
        showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text("สำเร็จ!"),
                  titleTextStyle: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: 20),
                  actionsOverflowButtonSpacing: 20,
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        Get.back();
                        Get.back();
                      },
                      style: ButtonStyle(
                        // minimumSize: MaterialStateProperty.all<Size>(
                        //     const Size(330, 50)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color(0xFFF8721D)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                      child: const Text(
                        "ตกลง",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ],
                  content: const Text("แก้ไขเพลงในเพลย์ลิสต์สำเร็จ"),
                ));
      }
    }
  }
}
