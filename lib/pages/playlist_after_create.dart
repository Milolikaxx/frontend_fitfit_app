import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/pages/save_playlist.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
// import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class PlaylistAfterCreatePage extends StatefulWidget {
  const PlaylistAfterCreatePage({super.key});

  @override
  State<PlaylistAfterCreatePage> createState() =>
      _PlaylistAfterCreatePageState();
}

class _PlaylistAfterCreatePageState extends State<PlaylistAfterCreatePage> {
  List<SalesData> data = [
    SalesData('3:55', 110),
    SalesData('2:25', 125),
    SalesData('4:34', 130),
    SalesData('2:09', 120),
    SalesData('3:11', 99)
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
            child: Column(
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
                musicChilds(),
                musicChilds(),
              ],
            ),
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
        // legend: const Legend(isVisible: true),
        tooltipBehavior: TooltipBehavior(enable: true),
        series: <CartesianSeries<SalesData, String>>[
          LineSeries<SalesData, String>(
            dataSource: data,
            xValueMapper: (SalesData sales, _) => sales.year,
            yValueMapper: (SalesData sales, _) => sales.sales,
            // name: 'Sales',
            // dataLabelSettings: const DataLabelSettings(isVisible: true),
          ),
        ],
      ),
    );
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}
