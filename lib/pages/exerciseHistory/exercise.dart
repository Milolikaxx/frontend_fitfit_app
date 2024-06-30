import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/service/api/history_exercise.dart';
import 'package:frontend_fitfit_app/service/provider/appdata.dart';
// import 'package:get_storage/get_storage.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:frontend_fitfit_app/model/response/historyexercise_get_res.dart';
import 'package:provider/provider.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  late var loadData;
  late HistoryExerciseService hisExercise;
  late List<HistoryExerciseGetResponse> historys = [];

  @override
  void initState() {
    super.initState();
    hisExercise = context.read<AppData>().historyExerciseService;
    loadData = loadDataAsync();
  }

  Future<void> loadDataAsync() async {
    historys = await hisExercise.getAllHistoryExercise();
    setState(() {}); // Trigger a rebuild after data is loaded
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
        const Padding(
          padding: EdgeInsets.only(top: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Week/Month",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
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
