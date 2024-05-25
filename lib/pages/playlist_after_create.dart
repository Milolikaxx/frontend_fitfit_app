import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/pages/save_playlist.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class PlaylistAfterCreatePage extends StatefulWidget {
  const PlaylistAfterCreatePage({super.key});

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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
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
        
        child: const Icon(Icons.edit,color: Colors.white,),
        onPressed: () {
          // Action when button is pressed
          setState(() {});
        },
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(30), 
        ),
        backgroundColor: const Color(0xFFF8721D), // สีพื้นหลังของปุ่ม
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.endFloat, // ตำแหน่งของปุ่ม
      body: Column(
        children: [
          musicGraph(),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(""),
              Padding(
                padding: EdgeInsets.only(left: 45),
                child: Text("Title"),
              ),
              Padding(
                padding: EdgeInsets.only(right: 35),
                child: Icon(Icons.access_time_rounded, color: Colors.black),
              ),
            ],
          ),
          musicHeader(height, width),
        ],
      ),
    );
  }

  void savePlaylist() {
    Get.to(() => const SavePlaylistPage());
  }

  Widget musicHeader(double height, double width) {
    return Expanded(
      child: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: SingleChildScrollView(
            child: Stack(children: [
              Column(
                children: [
                  musicChilds(),
                  musicChilds(),
                  musicChilds(),
                  musicChilds(),
                  musicChilds(),
                  musicChilds(),
                  musicChilds(),
                  musicChilds(),
                  musicChilds(),
                  musicChilds(),
                  musicChilds(),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }

  Widget musicChilds() {
    return Padding(
      padding: const EdgeInsets.all(1),
      child: Container(
        decoration: const BoxDecoration(
            // color: Color.fromARGB(255, 162, 162, 162), // สีแดง
            ),
        child: const Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image(
                    image: NetworkImage(
                        'https://people.com/thmb/NDasPbZOWfpi2vryTpDta_MJwIY=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc():focal(602x285:604x287)/newjeans-111023-1-c7ed1acdd72e4f2eb527cc38144aa2d4.jpg'),
                    width: 75,
                    height: 75,
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "OMG",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "NewJeans",
                        style: TextStyle(color: Color.fromARGB(161, 0, 0, 0)),
                      ),
                    ],
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment
                        .start, // เปลี่ยนจาก CrossAxisAlignment.end เป็น CrossAxisAlignment.start
                    children: [
                      Text(
                        "3:55",
                        style: TextStyle(
                            color: Color.fromARGB(161, 0, 0, 0), fontSize: 12),
                      ),
                      Text(
                        "110 BPM",
                        style: TextStyle(
                            color: Color.fromARGB(161, 0, 0, 0), fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
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
