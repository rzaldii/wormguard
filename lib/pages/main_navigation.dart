import 'package:flutter/material.dart';
import 'monitoring/monitoring_page.dart';
import 'control/control_page.dart';
import 'history/history_page.dart';
import 'profile/profile_page.dart';
import 'notification/notification_page.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;
  final List<Widget> _pages = const [
    MonitoringPage(),
    ControlPage(),
    HistoryPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30)
          )
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 68, 130, 79),
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
          unselectedItemColor: const Color.fromARGB(255, 207, 207, 207),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.water_drop), label: 'Monitoring'),
            BottomNavigationBarItem(icon: Icon(Icons.build), label: 'Kontrol'),
            BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Riwayat'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          ],
        ),
      ),
    );
  }
}