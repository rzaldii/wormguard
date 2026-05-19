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
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        child: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(255, 68, 130, 79),
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.white,
          unselectedItemColor: const Color.fromARGB(255, 207, 207, 207),

          // ❗ sembunyikan label bawaan
          showSelectedLabels: false,
          showUnselectedLabels: false,

          items: [
            BottomNavigationBarItem(
              label: '',
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 6), // jarak atas
                  const Icon(Icons.water_drop),
                  const SizedBox(height: 4),
                  Text(
                    'Monitoring',
                    style: TextStyle(
                      fontSize: 12,
                      color: _currentIndex == 0
                          ? Colors.white
                          : const Color.fromARGB(255, 207, 207, 207),
                    ),
                  ),
                  const SizedBox(height: 0), // jarak bawah (biar naik semua)
                ],
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 6),
                  const Icon(Icons.build),
                  const SizedBox(height: 4),
                  Text(
                    'Kontrol',
                    style: TextStyle(
                      fontSize: 12,
                      color: _currentIndex == 1
                          ? Colors.white
                          : const Color.fromARGB(255, 207, 207, 207),
                    ),
                  ),
                  const SizedBox(height: 0),
                ],
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 6),
                  const Icon(Icons.history),
                  const SizedBox(height: 4),
                  Text(
                    'Riwayat',
                    style: TextStyle(
                      fontSize: 12,
                      color: _currentIndex == 2
                          ? Colors.white
                          : const Color.fromARGB(255, 207, 207, 207),
                    ),
                  ),
                  const SizedBox(height: 0),
                ],
              ),
            ),
            BottomNavigationBarItem(
              label: '',
              icon: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 6),
                  const Icon(Icons.person),
                  const SizedBox(height: 4),
                  Text(
                    'Profil',
                    style: TextStyle(
                      fontSize: 12,
                      color: _currentIndex == 3
                          ? Colors.white
                          : const Color.fromARGB(255, 207, 207, 207),
                    ),
                  ),
                  const SizedBox(height: 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}