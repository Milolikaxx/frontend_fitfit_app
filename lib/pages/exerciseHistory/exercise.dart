import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/service/model/response/exercise_showbyday_get_res.dart';
import 'package:frontend_fitfit_app/service/model/response/user_login_post_res.dart';
import 'package:frontend_fitfit_app/service/api/history_exercise.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:frontend_fitfit_app/service/model/response/historyexercise_get_res.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class MonthData {
  final String month;
  final int count;

  MonthData(this.month, this.count);
}

class WeekData {
  final String day;
  final int count;

  WeekData(this.day, this.count);
}

class _ExercisePageState extends State<ExercisePage> {
  // ignore: prefer_typing_uninitialized_variables
  late var loadData;
  late HistoryExerciseService hisExercise;
  late UserLoginPostResponse user;
  late List<HistoryExerciseGetResponse> historys = [];
  late List<ExerciseShowbydayGetResponse> last7day = [];
  // late String day;
  // late int dayAmount;

  List<bool> isSelected = [true, false];
  List<MonthData> month = [
    MonthData('Jan', 30),
    MonthData('Feb', 20),
    MonthData('Mar', 35),
    MonthData('Apr', 50),
    MonthData('May', 20),
    MonthData('Jun', 45),
    MonthData('Jul', 55),
    MonthData('Aug', 60),
    MonthData('Sep', 30),
    MonthData('Oct', 40),
    MonthData('Nov', 35),
    MonthData('Dec', 50),
  ];
  List<WeekData> week = [];

  String selectedData = '';

  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
    hisExercise = context.read<AppData>().historyExerciseService;
    loadData = loadDataAsync();
    for (var i in week) {
      log("Week ================> ${i.day}");
    }
  }

  loadDataAsync() async {
    try {
      // historys = await hisExercise.getHisExByUid(user.uid!);
      last7day = await hisExercise.getLast7Day();
      log(last7day.length.toString());
      for (var item in last7day) {
        String day = item.date.toString();
        int dayAmount = item.count;
        log(day);
        log(dayAmount.toString());

        // เพิ่มข้อมูลใน List<WeekData> week
        week.add(WeekData(day, dayAmount));
      }
      setState(() {});
    } catch (e) {
      log("[Error] ==========> [ $e ]");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: FutureBuilder(
        future: loadData,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(
              child: LoadingAnimationWidget.beat(
                color: Colors.white,
                size: 50,
              ),
            );
          }
          return mainBody();
        },
      ),
    );
  }

  Widget mainBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ToggleButtons(
                isSelected: isSelected,
                onPressed: (int index) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < isSelected.length;
                        buttonIndex++) {
                      if (buttonIndex == index) {
                        isSelected[buttonIndex] = true;
                      } else {
                        isSelected[buttonIndex] = false;
                      }
                    }
                    log('Selected mode: ${isSelected[0] ? 'Week' : 'Month'}');
                  });
                },
                color: Colors.grey,
                selectedColor: Colors.white,
                fillColor: const Color(0xFFF8721D),
                borderRadius: BorderRadius.circular(10.0),
                borderColor: Colors.white,
                children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Week',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Month',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    isSelected[0] ? 'สัปดาห์' : 'เดือน',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: musicGraph(),
        ),
        showDateMonth(),
        Expanded(
          child: RefreshIndicator(
            color: const Color(0xFFF8721D), // เปลี่ยนสีของ RefreshIndicator
            onRefresh: () async {
              setState(() {
                loadData = loadDataAsync();
              });
            },
            child: historys.isNotEmpty
                ? ListView.builder(
                    itemCount: historys.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: historyCard(historys[index]),
                    ),
                  )
                : const Center(
                    child: Text(
                      'ยังไม่มีประวัติการออกกำลังกาย',
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
          ),
        )
      ],
    );
  }

  Widget musicGraph() {
    log('Displaying ${isSelected[0] ? 'week' : 'month'} data');
    return Container(
      color: Colors.black,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.3,
        child: SfCartesianChart(
          backgroundColor: Colors.black, // ตั้งค่าสีพื้นหลังของกราฟเป็นสีดำ
          primaryXAxis: const CategoryAxis(
            labelStyle: TextStyle(
                color: Colors.white), // เปลี่ยนสีตัวหนังสือแกน X เป็นสีขาว
            majorGridLines: MajorGridLines(width: 0), // ลบเส้นกริดแกน X
          ),
          primaryYAxis: const NumericAxis(
            labelStyle: TextStyle(
                color: Colors.white), // เปลี่ยนสีตัวหนังสือแกน Y เป็นสีขาว
            majorGridLines: MajorGridLines(width: 0), // ลบเส้นกริดแกน Y
          ),
          legend: const Legend(
            isVisible: false,
          ),
          tooltipBehavior: TooltipBehavior(enable: true),
          series: isSelected[0]
              ? <CartesianSeries<WeekData, String>>[
                  ColumnSeries<WeekData, String>(
                    dataSource: week,
                    xValueMapper: (WeekData w, _) => w.day,
                    yValueMapper: (WeekData w, _) => w.count,
                    color: const Color(0xFFF8721D),
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: false),
                    onPointTap: (ChartPointDetails details) {
                      setState(() {
                        selectedData = week[details.pointIndex!].day;
                      });
                    },
                  ),
                ]
              : <CartesianSeries<MonthData, String>>[
                  ColumnSeries<MonthData, String>(
                    dataSource: month,
                    xValueMapper: (MonthData m, _) => m.month,
                    yValueMapper: (MonthData m, _) => m.count,
                    color: const Color(0xFFF8721D),
                    dataLabelSettings:
                        const DataLabelSettings(isVisible: false),
                    onPointTap: (ChartPointDetails details) {
                      setState(() {
                        selectedData = month[details.pointIndex!].month;
                      });
                    },
                  ),
                ],
        ),
      ),
    );
  }

  Widget showDateMonth() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Text(
        selectedData.isEmpty ? 'ยังไม่มีการเลือก' : 'Selected: $selectedData',
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget historyCard(HistoryExerciseGetResponse history) {
    return InkWell(
      onTap: () {
        log(history.playlistName.toString());
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: SizedBox(
              height: 100.0,
              child: Center(
                child: Text(
                  'รายการเพลง : ${history.playlistName}', // You can replace this with history-specific data
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
