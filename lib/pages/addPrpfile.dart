import 'package:flutter/material.dart';

class AddProfilePage extends StatefulWidget {
  const AddProfilePage({super.key});

  @override
  State<AddProfilePage> createState() => _AddProfilePageState();
}

class _AddProfilePageState extends State<AddProfilePage> {
 String dropdownValue = 'การเดิน';
 String dropdownMusicValue  = 'เพลงไทย';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded,
              color: Color.fromARGB(255, 255, 255, 255)),
          onPressed: () {},
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "เป้าหมายการออกกำลังกาย",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 42,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "40 นาที",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 10,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 42,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ระยะเวลา",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(
             height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.directions_run_rounded,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 35,
                ),
                const SizedBox(
                  width: 15,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    dropdownColor: Colors.black,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded,color: Colors.white,size: 32,
                    ),
                    
                    items: <String>['การเดิน', 'การวิ่งแบบเหยาะๆ', 'การวิ่งปกติ', 'การวิ่งบนลู่วิ่ง',' ปั่นจักรยาน']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 42,
                  ),
                  onPressed: () {},
                ),
                const SizedBox(
                  width: 18,
                ),
                const Text(
                  "LV. 3",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.w600),
                ),
                const SizedBox(
                  width: 18,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.add_circle,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 42,
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "ระดับการออกกำลังกาย",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
             Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.music_note_rounded,
                  color: Color.fromARGB(255, 255, 255, 255),
                  size: 35,
                ),
                const SizedBox(
                  width: 15,
                ),
                DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: dropdownMusicValue,
                    dropdownColor: Colors.black,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Colors.white,
                      size: 35,
                    ),
                    items: <String>['เพลงไทย', 'เพลงสากล', 'เพลงเกาหลี', 'เพลงลูกทุ่ง' , 'เพลงญี่ปุ่น','เพลงจีน']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          style: const TextStyle(
                              fontSize:25, color: Colors.white),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownMusicValue = newValue!;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}
