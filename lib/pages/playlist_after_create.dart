// ignore_for_file: sort_child_properties_last

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/model/response/muisc_get_res.dart';
import 'package:frontend_fitfit_app/pages/save_playlist.dart';
import 'package:frontend_fitfit_app/service/api/playlist_detail.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PlaylistAfterCreatePage extends StatefulWidget {
  int idx = 0;
  PlaylistAfterCreatePage(this.idx, {super.key});

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
  @override
  void initState() {
    super.initState();
    playlistDetailServ = context.read<AppData>().playlistDetail;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    music = await playlistDetailServ.getMusicDetailGen(widget.idx);
    log(music.length.toString());
    for (var m in music) {
      log(m.name);
      chartData.add(Musicdata(m.duration, m.bpm));
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
              Navigator.pop(context);
            },
          ),
          title: const Center(
            child: Text(
              "เวลา 40 นาที",
              style: TextStyle(color: Colors.black),
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
            // Action when button is pressed
            setState(() {});
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
                  onRefresh: () async {},
                  child: Column(
                    children: [
                      musicGraph(),
                      const Padding(
                        padding: EdgeInsets.only(left: 100,right: 35),
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
                      const SizedBox(
                        height: 50,
                      )
                    ],
                  ));
            }));
  }

  Widget listMusic() {
    return Expanded(
      child: ListView.builder(
        itemCount: music.isEmpty ? 0 : music.length,
        itemBuilder: (context, index) => musicInfo(music[index]),
      ),
    );
  }

  void savePlaylist() {
    Get.to(() => const SavePlaylistPage());
  }

  Widget musicInfo(MusicGetResponse music) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image(
                image: NetworkImage(music.musicImage),
                width: 75,
                height: 75,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      music.name,
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w800),
                    ),
                    Text(
                      music.artist,
                      style: const TextStyle(color: Color.fromARGB(161, 0, 0, 0)),
                    ),
                  ],
                ),
              ),
              
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment
                .start, // เปลี่ยนจาก CrossAxisAlignment.end เป็น CrossAxisAlignment.start
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
