import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: const Text(
            "แชร์รายการเพลง",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(const Color(0xFFF8721D)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                child: const Text(
                  "แชร์",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Image.asset(
                    'assets/images/runner.png'),
                title: const Text(
                  "Username",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(
                // border: InputBorder.none,
                hintText: 'เขียนอะไรสักอย่างสิ',
                hintStyle: TextStyle(
                    fontSize: 16, color: Colors.white), // สีของข้อความ hint
                counterStyle: TextStyle(
                  color: Colors.white, // สีของ maxLength counter
                ),
              ),
              style: const TextStyle(color: Colors.white), // สีของข้อความที่พิมพ์
            ),
            
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                width: 400,
                height: 300,
                decoration: const BoxDecoration(
                    // border: Border.all(width: 3, color: Colors.white),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                        image: AssetImage('assets/images/1.jpg'))),
              ),
            ),
          Padding(
              padding: const EdgeInsets.only(top: 20),
              child: TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                 
                  hintText: 'ชื่อรายการเพลง',
                  hintStyle: TextStyle(
                      fontSize: 16, color: Colors.white), // สีของข้อความ hint
                  counterStyle: TextStyle(
                    color: Colors.white, // สีของ maxLength counter
                  ),
                ),
                style: const TextStyle(color: Colors.white), // สีของข้อความที่พิมพ์
              ),
            ),
          ],
        ),
      ),
    );
  }
}
