import 'package:flutter/material.dart';

class SocailPage extends StatefulWidget {
  const SocailPage({super.key});

  @override
  State<SocailPage> createState() => _SocailPageState();
}

class _SocailPageState extends State<SocailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 0, 0),
        title: const Text(
          "Feeds",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
           padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            children: [
            post(),
            postLongg(),
            post(),
        
          ]),
        ),
      ),
    );
  }

  Widget post() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
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
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '1 h',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                 
                   
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: ShapeDecoration(
                    color: const  Color(0xFFF8721D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'เพลงเกาหลีเกาใจออกกำลังกายชิลๆ อิอิ ',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 300,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
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
        ),
      ),
    );
  }
  Widget postLongg() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Container(
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
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '1 h',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                 
                   
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  decoration: ShapeDecoration(
                    color: const  Color(0xFFF8721D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'เพลงเกาหลีเกาใจออกกำลังกายชิลๆ อิอิ otttttttttttttttttttttasssssd sssssssssss',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: 300,
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
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
        ),
      ),
    );
  }
}
