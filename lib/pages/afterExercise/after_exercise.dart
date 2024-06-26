import 'package:flutter/material.dart';

class AfterExercisePage extends StatefulWidget {
  const AfterExercisePage({super.key});

  @override
  State<AfterExercisePage> createState() => _AfterExercisePageState();
}

class _AfterExercisePageState extends State<AfterExercisePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(

        children: [
          Container(
            margin: const EdgeInsets.only(top: 60),
            child: const Text(
              "เสร็จสิ้นการออกกำลังกาย",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
          Expanded(
            child: detailBox(),
          ),
          Container(
            margin: const EdgeInsets.only(
              bottom: 40,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                homeButton(),
                const SizedBox(
                  width: 40,
                ),
                shareButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget detailBox() {
    return Container(
      margin: const EdgeInsets.only(
        left: 20,
        right: 20,
        bottom: 10,
        top: 5,
      ),
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(20), // กำหนดขอบมน
      ),
      child: const Center(
        child: Text(
          'Orange Box',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget homeButton() {
    return TextButton(
      onPressed: () {},
      child: const Text(
        "กลับหน้าหลัก",
        style: TextStyle(color: Colors.white), 
      ),
    );
  }

  Widget shareButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(20), 
      ),
      child: TextButton(
        onPressed: () {},
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.share, 
              color: Colors.white, 
            ),
            SizedBox(width: 8), 
            Text(
              'แชร์', 
              style: TextStyle(color: Colors.white), 
            ),
          ],
        ),
      ),
    );
  }
}
