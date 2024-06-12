// ignore_for_file: sort_child_properties_last

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/model/response/muisc_get_res.dart';
import 'package:frontend_fitfit_app/model/response/playlsit_music_get_res.dart';
import 'package:frontend_fitfit_app/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/service/api/playlist.dart';
import 'package:frontend_fitfit_app/service/api/playlist_detail.dart';
import 'package:frontend_fitfit_app/service/api/workout_profile.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MusicPlaylistPage extends StatefulWidget {
  int idx = 0;

  MusicPlaylistPage(this.idx, {super.key});

  @override
  State<MusicPlaylistPage> createState() => _PlaylistAfterCreatePageState();
}

class Musicdata {
  final double musictime;
  final int bpm;

  Musicdata(this.musictime, this.bpm);
}

class _PlaylistAfterCreatePageState extends State<MusicPlaylistPage> {
  List<Musicdata> chartData = [];
  late PlaylsitMusicGetResponse music_pl;
  late PlaylistService playlistService;
  // ignore: prefer_typing_uninitialized_variables
  late var loadData;
  late UserLoginPostResponse user;
  @override
  void initState() {
    super.initState();
    playlistService = context.read<AppData>().playlistService;
    user = context.read<AppData>().user;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    music_pl = await playlistService.getPlaylistMusicByPid(widget.idx);
    for (var m in music_pl.playlistDetail) {
      chartData.add(Musicdata(m.music.duration, m.music.bpm));
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

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
        ),
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.edit,
            color: Colors.white,
          ),
          onPressed: () {
            // Get.to(() =>
            //     EditPlaylistAfterCreatePage(music, widget.idx, widget.timeEx));
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
                return const Center(child: CircularProgressIndicator());
              }
              return RefreshIndicator(
                  onRefresh: () async {
                    loadData = loadDataAsync();
                  },
                  child: Column(
                    children: [
                      Container(
                        width: width,
                        height: 250,
                        color: Colors.black,
                        child: Column(
                          children: [
                            Image.network(
                              music_pl.imagePlaylist,
                              width: 200,
                            ),
                            Text(
                              "${music_pl.playlistName} ",
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 20),
                            ),
                            Text(
                              "playlsit by ${user.name} ",
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
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
        padding: const EdgeInsets.only(bottom: 60),
        itemCount: music_pl.playlistDetail.isEmpty
            ? 0
            : music_pl.playlistDetail.length,
        itemBuilder: (context, index) =>
            musicInfo(music_pl.playlistDetail[index]),
      ),
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
    return SfCartesianChart(
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
        ]);
  }
}
