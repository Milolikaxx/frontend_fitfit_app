import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/service/model/request/exercise_searchbyday_get_req.dart';
import 'package:frontend_fitfit_app/service/model/request/exercise_searchbymonth_get_req.dart';
import 'package:frontend_fitfit_app/service/model/response/exercise_searchbydat_get_res.dart';
import 'package:frontend_fitfit_app/service/model/response/exercise_searchbymonth_get_res.dart';
import 'package:frontend_fitfit_app/service/model/response/exercise_showbyday_get_res.dart';
import 'package:frontend_fitfit_app/service/model/response/exercise_showbymonth_get_res.dart';
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
  late List<ExerciseLast12MonthGetResponse> last12month = [];
  late List<ExerciseSearchbydayGetResponse> searchDay = [];
  late List<ExerciseSearchByMonthGetResponse> searchMonth = [];
  late String day;
  late String month12;
  // late String day;
  // late int dayAmount;

  List<bool> isSelected = [true, false];
  List<MonthData> month = [];
  List<WeekData> week = [];

  String selectedData = '';

  @override
  void initState() {
    super.initState();
    user = context.read<AppData>().user;
    hisExercise = context.read<AppData>().historyExerciseService;
    loadData = loadDataAsync();
  }

  loadDataAsync() async {
    try {
      // historys = await hisExercise.getHisExByUid(user.uid!);
      last7day = await hisExercise.getLast7Day();
      last12month = await hisExercise.getlast12month();
      // log(last7day.length.toString());
      for (var item in last7day) {
        // Parse the date string to a DateTime object
        DateTime parsedDate = DateTime.parse(item.date.toString());
        // Format the date to the desired format
        day =
            "${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}";
        int dayAmount = item.count;
        log(day);
        log(dayAmount.toString());

        // เพิ่มข้อมูลใน List<WeekData> week
        week.add(WeekData(day, dayAmount));
      }
      for (var item in last12month) {
        month12 = item.monthNumber.toString();
        int monthAmount = item.exerciseCount;
        log(month12);
        log(monthAmount.toString());
        month.add(MonthData(month12, monthAmount));
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
        // Conditionally display either bodyDay() or bodyMonth()
        isSelected[0] ? bodyDay() : bodyMonth(),
      ],
    );
  }

  Widget bodyDay() {
    return Expanded(
      child: RefreshIndicator(
        color: const Color(0xFFF8721D), // เปลี่ยนสีของ RefreshIndicator
        onRefresh: () async {
          setState(() {
            loadData = loadDataAsync();
          });
        },
        child: searchDay.isNotEmpty
            ? ListView.builder(
                itemCount: searchDay.length,
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: historyCardDay(searchDay[index]),
                ),
              )
            : const Center(
                child: Text(
                  'ยังไม่มีประวัติการออกกำลังกาย',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
      ),
    );
  }

  Widget bodyMonth() {
    return Expanded(
      child: RefreshIndicator(
        color: const Color(0xFFF8721D), // เปลี่ยนสีของ RefreshIndicator
        onRefresh: () async {
          setState(() {
            loadData = loadDataAsync();
          });
        },
        child: searchMonth.isNotEmpty
            ? ListView.builder(
                itemCount: searchMonth.length,
                itemBuilder: (context, index) => Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  child: historyCardMonth(searchMonth[index]),
                ),
              )
            : const Center(
                child: Text(
                  'ยังไม่มีประวัติการออกกำลังกาย',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                ),
              ),
      ),
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
                        // log("selectedData ===> $selectedData");
                        searchByDay(selectedData);
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
                        searchByMonth(selectedData);
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
      padding: const EdgeInsets.all(10.0),
      child: Text(
        selectedData.isEmpty ? 'ยังไม่มีการเลือก' : selectedData,
        style: const TextStyle(fontSize: 20, color: Colors.white),
      ),
    );
  }

  Widget historyCardDay(ExerciseSearchbydayGetResponse day) {
    return InkWell(
      onTap: () {
        log(day.playlistName.toString());
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: SizedBox(
              height: 100.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ชื่อ : ${day.playlistName}", // แสดงชื่อ playlist
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      "ระยะเวลา : ${day.durationEx}", // แสดงชื่อ playlist
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      day.exerciseType, // แสดงชื่อ playlist
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget historyCardMonth(ExerciseSearchByMonthGetResponse month) {
    return InkWell(
      onTap: () {
        log(month.playlistName.toString());
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: SizedBox(
              height: 100.0,
              child: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ชื่อ : ${month.playlistName}", // แสดงชื่อ playlist
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      "ระยะเวลา : ${month.durationEx}", // แสดงชื่อ playlist
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    Text(
                      month.exerciseType, // แสดงชื่อ playlist
                      style: const TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  searchByDay(String day) async {
    try {
      DateTime dateTime = DateTime.parse(day);
      ExerciseSearchbydayGetRequest objDay = ExerciseSearchbydayGetRequest(
        keyword: dateTime,
      );

      List<ExerciseSearchbydayGetResponse> results =
          await hisExercise.searchByday(objDay);
      setState(() {
        searchDay = results;
      });
    } catch (e) {
      log("Error ===> [ $e ]");
    }
  }

  searchByMonth(String month) async {
    log("Month ==================> [ $month ]");
    try {
      // DateTime dateTime = DateTime.parse(day);
      ExerciseSearchByMonthGetRequest objMonth =
          ExerciseSearchByMonthGetRequest(
        numMonth: month,
      );

      List<ExerciseSearchByMonthGetResponse> results =
          await hisExercise.searchByMonth(objMonth);
      setState(() {
        searchMonth = results;
      });
    } catch (e) {
      log("Error ===> [ $e ]");
    }
  }
}
