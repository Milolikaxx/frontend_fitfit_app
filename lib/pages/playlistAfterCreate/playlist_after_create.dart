// ignore_for_file: sort_child_properties_last

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/model/response/muisc_get_res.dart';
import 'package:frontend_fitfit_app/model/response/workoutProfile_get_res.dart';
import 'package:frontend_fitfit_app/pages/playlistAfterCreate/editplaylistmusic_after_create.dart';
import 'package:frontend_fitfit_app/pages/playlsit/save_playlist.dart';
import 'package:frontend_fitfit_app/service/api/playlist_detail.dart';
import 'package:frontend_fitfit_app/service/api/workout_profile.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PlaylistAfterCreatePage extends StatefulWidget {
  int idx = 0;
  int timeEx = 0;
  PlaylistAfterCreatePage(this.idx, this.timeEx, {super.key});

  @override
  State<PlaylistAfterCreatePage> createState() =>
      _PlaylistAfterCreatePageState();
}

class Musicdata {
  final double musictime;
  final int bpm;

  Musicdata(this.musictime, this.bpm);
}

class _PlaylistAfterCreatePageState extends State<PlaylistAfterCreatePage> {
  List<Musicdata> chartData = [];
  List<MusicGetResponse> music = [];
  late PlaylistDetailService playlistDetailServ;
  // ignore: prefer_typing_uninitialized_variables
  late var loadData;
  late WorkoutProfileService wpService;
  @override
  void initState() {
    super.initState();
    playlistDetailServ = context.read<AppData>().playlistDetailService;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    music = await playlistDetailServ.getMusicDetailGen(widget.idx);
    log(music.length.toString());
  
  for (var m in music) {
      log(m.name);
      chartData.add(Musicdata(m.duration, m.bpm));
    }  }

  @override
  Widget build(BuildContext context) {
    // double width = MediaQuery.of(context).size.width;
    // double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Center(
            child: Text(
              "${widget.timeEx} นาที",
              style: const TextStyle(color: Colors.black),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.save_rounded, color: Colors.black),
              onPressed: savePlaylist,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onPressed: () {
            Get.to(() =>
                EditPlaylistMusicAfterCreatePage(music, widget.idx, widget.timeEx));
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
                onRefresh: () async {
                  setState(() {
                    loadData = loadDataAsync();
                  });
                },
                child: Column(
                  children: [
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
                ),
              );
            }));
  }

  Widget listMusic() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: music.isEmpty ? 0 : music.length,
        itemBuilder: (context, index) => musicInfo(music[index]),
      ),
    );
  }

  void savePlaylist() {
    Get.to(() => SavePlaylistPage(music, widget.idx, widget.timeEx));
  }

  Widget musicInfo(MusicGetResponse music) {
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
            ],
          ),
        ],
      ),
    );
  }

  String formatMusicName(String name) {
    // Remove .mp extension
    if (name.endsWith('.mp')) {
      name = name.substring(0,name.length - 3);
    }
    // Truncate to 10 characters and add ellipsis if necessary
    if (name.length > 25) {
      return '${name.substring(0, 25)}..';
    }
    return name;
  }

  Widget musicGraph() {
    return SizedBox(
      height: 250,
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
                dataLabelSettings: const DataLabelSettings(isVisible: false))
          ]),
    );
  }
}
