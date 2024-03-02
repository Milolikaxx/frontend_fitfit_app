import 'package:flutter/material.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
            backgroundColor: Colors.black,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                icon: const Icon(Icons.exit_to_app_rounded,
                    color: Color.fromARGB(255, 255, 255, 255)),
                onPressed: () {},
              ),
            ]),
        body: Column(
          children: [
            const CircleAvatar(
                radius: 50.0,
                backgroundImage: AssetImage('assets/images/runner.png')),
            const SizedBox(height: 10),
            const Text(
              "name name",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(
              height: 10,
            ),
            OutlinedButton(
                onPressed: () {},
                style: ButtonStyle(
                  minimumSize:
                      MaterialStateProperty.all<Size>(const Size(100, 50)),
                  side: MaterialStateProperty.all<BorderSide>(const BorderSide(
                    color: Color.fromARGB(255, 75, 75, 75),
                    width: 2.0,
                  )),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                child: const Text('แก้ไขโปรไฟล์',
                    style: TextStyle(
                        fontSize: 18,
                        color: Color.fromARGB(255, 255, 255, 255)))),
            const SizedBox(
              height: 10,
            ),
            postMe(height, width)
          ],
        ));
  }

  Widget postMe(height, width) {
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
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'รายการเพลงที่แชร์',
                    style: TextStyle(
                        color: Color(0xFFF8721D),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    thickness: 2.5,
                  ),
                  // ignore: prefer_const_constructors
                  SizedBox(
                    height: 10,
                  ),
               
                  post(),
                   const SizedBox(
                    height: 10,
                  ),
                  post(),
                    const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Container post() {
    return Container(
      width: 335,
      height: 256,
      decoration: ShapeDecoration(
        color: const Color(0x66CCCCCC),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46.55,
                  decoration: const ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage("https://via.placeholder.com/46x47"),
                      fit: BoxFit.cover,
                    ),
                    shape: OvalBorder(),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gojo Satoru',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '1 h',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 292,
              height: 43.51,
              decoration: ShapeDecoration(
                color: const Color(0xFFE56020),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  SizedBox(
                    width: 203,
                    height: 18,
                    child: Text(
                      'เพลงเกาหลีเกาใจออกกำลังกายชิลๆ อิอิ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
