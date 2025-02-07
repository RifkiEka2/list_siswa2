import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:siswa_app/view/history_view.dart';
import 'package:siswa_app/view/home_view.dart';
import 'package:siswa_app/view/profile_view.dart';

void main() => runApp(const Home());

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PPLG Apps',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  int get tabIndex => _currentIndex;
  set tabIndex(int v) {
    tabIndex = v;
    setState(() {});
  }
  final tabs = [
    const HomeView(),
    const HistoryView(),
    const ProfileView(),
  ];
  late PageController pageController;


  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _currentIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PPLG Apps', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blueAccent,
        
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          tabIndex = v;
        },
        children: [
          Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: const HomeView(),
        ),
          Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: const HistoryView(),
        ),

          Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(255, 255, 255, 255),
          child: const ProfileView(),
        ),
        ],
        
      ),

      bottomNavigationBar: CircleNavBar(
        activeIcons: const [
          Icon(Icons.home, color: Color.fromARGB(255, 255, 255, 255)),
          Icon(Icons.history, color: Color.fromARGB(255, 255, 255, 255)),
          Icon(Icons.person, color: Color.fromARGB(255, 255, 255, 255))
        ],
        inactiveIcons: const [
          Text("Home", style: TextStyle(color: Colors.white)),
          Text("History", style: TextStyle(color: Colors.white)),
          Text("Profile", style: TextStyle(color: Colors.white)),
        ],
        color: Colors.blueAccent,
        height: 60,
        circleWidth: 60,
        activeIndex: _currentIndex, 
        onTap: (index) {
  setState(() {
    _currentIndex = index;
  });

    pageController.jumpToPage(
      index
    );
},
        // padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
        cornerRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(0),
          bottomRight: Radius.circular(0),
          bottomLeft: Radius.circular(0),
        ),
        shadowColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 10,
      ),
      // BottomNavigationBar(
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     setState(() => _currentIndex = index);
      //   },
      //   items: const [
      //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      //     BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
      //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Person'),
      //   ],
      //   selectedItemColor: Colors.blueAccent,
      // ),
    );
  }
}