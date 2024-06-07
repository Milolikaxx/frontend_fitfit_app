import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontend_fitfit_app/model/response/muisc_get_res.dart';
import 'package:frontend_fitfit_app/pages/save_playlist.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

// ignore: must_be_immutable
class EditPlaylistAfterCreatePage extends StatefulWidget {
  List<MusicGetResponse> music = [];
  int idx = 0;
  int timeEx = 0;
  EditPlaylistAfterCreatePage(this.music, this.idx,this.timeEx ,{super.key});

  @override
  State<EditPlaylistAfterCreatePage> createState() =>
      _EditPlaylistAfterCreatePageState();
}

class Musicdata {
  final double musictime;
  final int bpm;

  Musicdata(this.musictime, this.bpm);
}

class _EditPlaylistAfterCreatePageState
    extends State<EditPlaylistAfterCreatePage> {
  List<Musicdata> chartData = [];

  // ignore: prefer_typing_uninitialized_variables
  late var loadData;
  @override
  void initState() {
    super.initState();
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    for (var m in widget.music) {
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
          child: FaIcon(
            FontAwesomeIcons.shuffle,
            color: Colors.white,
          ),
          onPressed: () {
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
        itemCount: widget.music.isEmpty ? 0 : widget.music.length,
        itemBuilder: (context, index) => musicInfo(widget.music[index]),
      ),
    );
  }

  void savePlaylist() {
    Get.to(() => SavePlaylistPage(widget.music, widget.idx,widget.timeEx));
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
