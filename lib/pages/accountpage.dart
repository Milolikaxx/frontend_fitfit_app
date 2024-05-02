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
              height: 20,
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
                    'เพลย์ลิสต์เพลงของคุณที่แชร์',
                    style: TextStyle(
                        color: Color(0xFFF8721D),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const Divider(
                    thickness: 2.5,
                  ),
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

  Widget post() {
    return Container(
      width: 350,
      padding: const EdgeInsets.only(top: 5),
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
                  width: 47,
                  height: 47,
                  decoration: const ShapeDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                          "https://i.pinimg.com/736x/af/2d/bc/af2dbc00320f21026d87f3820d13429e.jpg"),
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
                ),
                Row(
                 
                  children: [
                    IconButton(
                      icon: const Icon(Icons.delete,
                          color: Colors.red),
                      onPressed: () {},
                    ),
                    ],
                )
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 300,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
              decoration: ShapeDecoration(
                color: const Color(0x66CCCCCC),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'เพลงเกาหลีเกาใจออกกำลังกายชิลๆ อิอิ ',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: 300,
              padding: const EdgeInsets.only(top: 10 , bottom: 10),
              decoration: ShapeDecoration(
                color: const Color.fromARGB(255, 255, 255, 255),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Row(
                children: [
                  Image(
                    image: NetworkImage(
                        "https://i.pinimg.com/564x/06/f9/6f/06f96f2944fcfabe3a291a1060441511.jpg"),
                    width: 150,
                    height: 130,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("ปั่นจักยาน ตามมูมู",
                          style: TextStyle(fontSize: 16, color: Colors.black)),
                      Text("playlist by Gojo",
                          style: TextStyle(fontSize: 12, color: Colors.grey)),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
