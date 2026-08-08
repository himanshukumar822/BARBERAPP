import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import 'package:barberapp/pages/home.dart';
import 'package:barberapp/pages/profile.dart';
import 'package:barberapp/pages/booking_tab.dart';

class Bottomdev extends StatefulWidget {
  const Bottomdev({super.key});

  @override
  State<Bottomdev> createState() => _BottomdevState();
}

class _BottomdevState extends State<Bottomdev> {
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfffdece7),

      body: IndexedStack(
        index: currentTabIndex,
        children: const [Home(), BookingsTab(), Profile()],
      ),

      bottomNavigationBar: CurvedNavigationBar(
        index: currentTabIndex,
        height: 65,
        backgroundColor: const Color(0xfffdece7),
        color: const Color(0xff2c3925),
        animationDuration: const Duration(milliseconds: 400),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
          });
        },
        items: const [
          Icon(Icons.home, color: Colors.white),
          Icon(Icons.book, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
    );
  }
}
