import 'package:demo/custom_player/ytmusic_home.dart';
import 'package:flutter/material.dart';
import 'package:demo/custom_player/account.dart';
import 'package:demo/custom_player/custom_player.dart';
import 'package:demo/custom_player/library.dart';

class Navbar extends StatefulWidget {
  const Navbar({super.key});

  @override
  _NavbarState createState() => _NavbarState();
}

class _NavbarState extends State<Navbar> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const YtmusicHome(),
    const CustomPlayer(),
    const Library(),
    const Account(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Stack(
        children: [
          _pages[_currentIndex],
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Colors.black, Colors.black38, Colors.transparent],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter), // Semi-transparent background
              ),
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 1,
                currentIndex: _currentIndex,
                onTap: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey,
                type: BottomNavigationBarType.fixed,
                selectedFontSize: 12,
                unselectedFontSize: 12,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.library_music),
                    label: 'Your Library',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.lock),
                    label: 'Premium',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      // body: Stack(
      //   children: [
      //     _pages[_currentIndex],
      //     Align(
      //       alignment: Alignment.bottomCenter,
      //       child: Container(
      //         decoration: const BoxDecoration(
      //           gradient: LinearGradient(
      //               colors: [Colors.black, Colors.black38, Colors.transparent],
      //               begin: Alignment.bottomCenter,
      //               end: Alignment.topCenter), // Semi-transparent background
      //         ),
      //         child: BottomNavigationBar(
      //           backgroundColor: Colors.transparent,
      //           elevation: 0,
      //           currentIndex: _currentIndex,
      //           onTap: (int index) {
      //             setState(() {
      //               _currentIndex = index;
      //             });
      //           },
      //           selectedItemColor: Colors.white,
      //           unselectedItemColor: Colors.grey,
      //           type: BottomNavigationBarType.fixed,
      //           selectedFontSize: 12,
      //           unselectedFontSize: 12,
      //           items: const [
      //             BottomNavigationBarItem(
      //               icon: Icon(Icons.home),
      //               label: 'Home',
      //             ),
      //             BottomNavigationBarItem(
      //               icon: Icon(Icons.search),
      //               label: 'Search',
      //             ),
      //             BottomNavigationBarItem(
      //               icon: Icon(Icons.library_music),
      //               label: 'Your Library',
      //             ),
      //             BottomNavigationBarItem(
      //               icon: Icon(Icons.lock),
      //               label: 'Premium',
      //             ),
      //           ],
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
      body: _pages[_currentIndex],
      resizeToAvoidBottomInset: false,
    );
  }
}
