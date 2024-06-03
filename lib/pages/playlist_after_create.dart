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
  final double music;
  final double bpm;

  Musicdata(this.music, this.bpm);
}

class _PlaylistAfterCreatePageState extends State<PlaylistAfterCreatePage> {
  List<Musicdata> chartData = [
    Musicdata(3.48, 135),
    Musicdata(3.59, 172),
    Musicdata(4.03, 144),
    Musicdata(3.27, 160),
    Musicdata(4.51, 131),
    Musicdata(4.40, 141),
    Musicdata(3.35, 110),
  ];
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
                  onRefresh: () async {
                    
                  },
                  child: Column(
                    children: [
                      musicGraph(),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(width: 45,),
                          Text("Title"),
                          Padding(
                            padding: EdgeInsets.only(right: 35),
                            child: Icon(Icons.access_time_rounded,
                                color: Colors.black),
                          ),
                        ],
                      ),
                      listMusic(),
                    ],
                  ));
            }));
  }

  Widget listMusic() {
    return Expanded(
      child: ListView.builder(
                        itemCount: music.isEmpty ? 0 : music.length,
                        itemBuilder: (context, index) => 
                          musicInfo(music[index]),
                        ),
    );
  }

  void savePlaylist() {
    Get.to(() => const SavePlaylistPage());
  }

  Widget musicInfo(MusicGetResponse music) {
    return Container(
      decoration: const BoxDecoration(
          // color: Color.fromARGB(255, 162, 162, 162), // สีแดง
          ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image(
                  image: NetworkImage(music.musicImage),
                  width: 75,
                  height: 75,
                  fit: BoxFit.cover,
                ),
                const SizedBox(width: 10),
                Column(
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
                      style:
                          const TextStyle(color: Color.fromARGB(161, 0, 0, 0)),
                    ),
                  ],
                ),
                const SizedBox(width: 10),
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
                      music.bpm.toString(),
                      style: const TextStyle(
                          color: Color.fromARGB(161, 0, 0, 0), fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
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
                xValueMapper: (Musicdata m, _) => m.music,
                yValueMapper: (Musicdata m, _) => m.bpm,
                color: Colors.red,
                dataLabelSettings: const DataLabelSettings(isVisible: false))
          ]),
    );
  }
}
