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
        mainAxisAlignment:
            MainAxisAlignment.center, // จัด Column ให้อยู่ตรงกลาง
        children: [
          Container(
            margin: const EdgeInsets.only(top: 60),
            child: const Text(
              "เสร็จสิ้นการออกกำลังกาย",
              textAlign: TextAlign.center, // จัดข้อความให้อยู่ตรงกลาง
              style: TextStyle(
                color: Colors.white, // กำหนดสีข้อความเป็นสีขาว
                fontSize: 20.0, // ปรับขนาดฟอนต์ตามความเหมาะสม
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
        style: TextStyle(color: Colors.white), // กำหนดสีข้อความตามต้องการ
      ),
    );
  }

  Widget shareButton() {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.circular(20), // กำหนดขอบมน
      ),
      child: TextButton(
        onPressed: () {},
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.share, // ไอคอนแชร์
              color: Colors.white, // กำหนดสีไอคอน
            ),
            SizedBox(width: 8), // ระยะห่างระหว่างไอคอนและข้อความ
            Text(
              'แชร์', // ข้อความแชร์
              style: TextStyle(color: Colors.white), // กำหนดสีข้อความ
            ),
          ],
        ),
      ),
    );
  }
}
