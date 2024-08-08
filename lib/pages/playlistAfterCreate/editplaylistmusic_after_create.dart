import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_fitfit_app/pages/playlsitMusic/search_music.dart';
import 'package:frontend_fitfit_app/service/api/music.dart';
import 'package:frontend_fitfit_app/service/model/request/add_musiclist_req.dart';
import 'package:frontend_fitfit_app/service/model/request/rand_music1_post_req.dart';
import 'package:frontend_fitfit_app/service/model/response/muisc_get_res.dart';
import 'package:frontend_fitfit_app/pages/playlsit/save_playlist.dart';
import 'package:frontend_fitfit_app/service/api/playlist_detail.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class EditPlaylistMusicAfterCreatePage extends StatefulWidget {
  List<MusicGetResponse> music = [];
  int wpid = 0;
  int timeEx = 0;
  EditPlaylistMusicAfterCreatePage(this.music, this.wpid, this.timeEx,
      {super.key});

  @override
  State<EditPlaylistMusicAfterCreatePage> createState() =>
      _EditPlaylistMusicAfterCreatePageState();
}

class Musicdata {
  final double musictime;
  final int bpm;

  Musicdata(this.musictime, this.bpm);
}

class _EditPlaylistMusicAfterCreatePageState
    extends State<EditPlaylistMusicAfterCreatePage> {
  List<Musicdata> chartData = [];
  List<MusicGetResponse> musicRandNew = [];
  List<MusicGetResponse> musicList = [];
  late PlaylistDetailService playlistDetailServ;
  late Future<void> loadData;
  double totalTime = 0;
  int delIndex = -1;
  bool chDel = false;
  List<MusicGetResponse> musiclist = [];
  late MusicService musicService;
  @override
  void initState() {
    super.initState();
    playlistDetailServ = context.read<AppData>().playlistDetailService;
    musicService = context.read<AppData>().musicService;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    try {
      for (var m in widget.music) {
        log(m.name);
        chartData.add(Musicdata(m.duration, m.bpm));
        totalTime += m.duration;
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
          title: Center(
            child: Text(
              "เวลา ${widget.timeEx} นาที",
              style: const TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            IconButton(
                icon: const Icon(Icons.add_box_rounded, color: Colors.black),
                onPressed: showForAddSoong),
            IconButton(
              icon: const Icon(Icons.save_rounded, color: Colors.black),
              onPressed: savePlaylist,
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
                            Get.to(() => SearchMusicPage(widget.wpid));
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
                      musicGraph(),
                      const Padding(
                        padding: EdgeInsets.only(left: 100, right: 35),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Title"),
                            Icon(Icons.access_time_rounded,
                                color: Colors.black),
                          ],
                        ),
                      ),
                      listMusic(),
                    ],
                  ));
            }));
  }

  Widget listMusic() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 65),
        itemCount: widget.music.isEmpty ? 0 : widget.music.length,
        itemBuilder: (context, index) => musicInfo(widget.music[index], index),
      ),
    );
  }

  void savePlaylist() {
    Get.to(() => SavePlaylistPage(widget.music, widget.wpid, widget.timeEx));
  }

  Widget musicInfo(MusicGetResponse music, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image(
                image: NetworkImage(music.musicImage),
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
                      formatMusicName(music.name),
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      music.artist,
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
                music.duration.toString(),
                style: const TextStyle(
                    color: Color.fromARGB(161, 0, 0, 0), fontSize: 12),
              ),
              Text(
                "${music.bpm} bpm",
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

  String formatMusicName(String name) {
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
      musicRandNew = await playlistDetailServ.getMusicDetailGen(widget.wpid);

      setState(() {
        chartData.clear();
        widget.music = musicRandNew;
      });

      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (BuildContext context) => widget),
      );
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> randMusic1Song(int idx) async {
    log("1");
    try {
      RandMusic1PostRequest randMusic = RandMusic1PostRequest(
          musicList: widget.music, index: idx, wpid: widget.wpid);
      musicList = await playlistDetailServ.randomMusic(randMusic);
      log(musicList.length.toString());
      setState(() {
        chartData.clear();
        widget.music = musicList;
        totalTime = 0;
        for (var m in widget.music) {
          log(m.name);
          chartData.add(Musicdata(m.duration, m.bpm));
          totalTime += m.duration;
        }
      });

      log(widget.music.length.toString());
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> delSong(int idx) async {
    if (!chDel) {
      try {
        musiclist = widget.music;
        RandMusic1PostRequest delMusic =
            RandMusic1PostRequest(musicList: widget.music, index: idx);
        musicList = await playlistDetailServ.delMusicList(delMusic);
        log(musicList.length.toString());
        setState(() {
          chartData.clear();
          widget.music = musicList;
          totalTime = 0;
          for (var m in widget.music) {
            log(m.name);
            chartData.add(Musicdata(m.duration, m.bpm));
            totalTime += m.duration;
          }
          chDel = true;
          delIndex = idx;
          log("chDell $chDel ");
        });

        log(widget.music.length.toString());
      } catch (e) {
        log(e.toString());
      }
    } else {
      Get.snackbar(
        'กรุณาเพิ่มเพลงก่อนจึงจะสามารถลบเพลงอื่นได้', // Title
        'คุณต้องเพิ่มเพลงก่อนจึงจะสามารถลบเพลงอื่นได้', // Message
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
    }
  }

  void showForAddSoong() async {
    if (delIndex >= 0) {
      log("Index $delIndex Wpid ${widget.wpid}");
      try {
        RandMusic1PostRequest dataPost = RandMusic1PostRequest(
            musicList: musiclist, index: delIndex, wpid: widget.wpid);
        musicList = await musicService.getMusicForAddMusic(dataPost);
        if (musicList.isNotEmpty) {
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text(
                  'เลือกเพลงที่ต้องการเพิ่ม 1 เพลง',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                content: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      musicList.isNotEmpty
                          ? Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: musicList.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 2),
                                    child: ListTile(
                                      title: Text(formatMusicName(
                                          musicList[index].name)),
                                      leading: Image.network(
                                          musicList[index].musicImage),
                                      subtitle: Text(
                                          "${musicList[index].duration} นาที  (${musicList[index].bpm} bpm)"),
                                      onTap: () async {
                                        AddMusicRequest data = AddMusicRequest(
                                            musicList: musiclist,
                                            music: musicList,
                                            indexMl: delIndex,
                                            indexMusic: index);
                                        musicList = await playlistDetailServ
                                            .addMusic(data);

                                        setState(() {
                                          widget.music = musicList;
                                          chDel = false;
                                        });
                                        Get.back();
                                      },
                                    ),
                                  );
                                },
                              ),
                            )
                          : const Text("ไม่มีเพลง")
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                    child: const Text(
                      "ปิด",
                      style: TextStyle(fontSize: 16, color: Color(0xFFF8721D)),
                    ),
                  ),
                ],
              );
            },
          );
        } else {
          log("Null music for add song");
        }
      } catch (e) {
        log(e.toString());
      }
    } else {
      Get.snackbar(
        'ไม่มีการลบเพลงในเพลย์ลิสต์',
        'ลบเพลงในเพลงในเพลย์ลิสต์เพือเพิ่มเพลงใหม่',
        backgroundColor: Colors.black,
        colorText: Colors.white,
      );
    }
  }
}
