import 'package:flutter/material.dart';
import 'package:frontend_fitfit_app/pages/accountpage.dart';
import 'package:frontend_fitfit_app/pages/addPrpfile.dart';
import 'package:frontend_fitfit_app/pages/exercise.dart';
import 'package:frontend_fitfit_app/pages/home.dart';
import 'package:frontend_fitfit_app/pages/social.dart';

class Barbottom extends StatefulWidget {
  const Barbottom({super.key});

  @override
  State<Barbottom> createState() => _BarbottomState();
}

class _BarbottomState extends State<Barbottom> {
 int currentInx = 0;

  final tabs = [
    const HomePage(),
    const SocailPage(),
    const AddProfilePage(),
    const ExercisePage(),
    const AccountPage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: tabs[currentInx],
      
      bottomNavigationBar: BottomNavigationBar(
        
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        unselectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        currentIndex: currentInx,
        type: BottomNavigationBarType.shifting,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_sharp),
            label: 'หน้าแรก',
            backgroundColor:  Color(0xFFF8721D),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.public),
            label: 'หน้าสังคม',
            backgroundColor: Color(0xFFF8721D),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline,size: 40,) ,
            label: 'เพิ่ม',
            backgroundColor: Color(0xFFF8721D),
          ),
          BottomNavigationBarItem( 
            icon: Icon(Icons.history),
            label: 'ประวัติออกกำลังกาย',
            backgroundColor: Color(0xFFF8721D),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'บัญชี',
            backgroundColor: Color(0xFFF8721D),
          ),
        ],
        onTap: (index) {
          setState(() {
            currentInx = index;
          });
        },
      ),
    );
  }
}