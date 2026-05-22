import 'package:flutter/material.dart';
import 'summary_page.dart';
import 'profile_page.dart';
import 'home_page.dart';

class CompletePage extends StatelessWidget {
  const CompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Faux Status Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('9:41', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                  Row(
                    children: const [
                      Icon(Icons.signal_cellular_4_bar, size: 16, color: Colors.black),
                      SizedBox(width: 4),
                      Icon(Icons.wifi, size: 16, color: Colors.black),
                      SizedBox(width: 4),
                      Icon(Icons.battery_full, size: 16, color: Colors.black),
                    ],
                  ),
                ],
              ),
            ),
            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: const BoxDecoration(
                      color: Color(0xFFBD232B),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 6.0),
                        child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Image.asset('assets/images/completed/download_1.png', width: 140, height: 140, fit: BoxFit.contain),
                   const SizedBox(height: 32),
                   const Text(
                     'Order Completed!',
                     style: TextStyle(fontFamily: 'serif', fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black),
                   ),
                   const SizedBox(height: 48),
                   ElevatedButton(
                     onPressed: () {
                       Navigator.push(
                         context,
                         MaterialPageRoute(builder: (context) => const SummaryPage()),
                       );
                     },
                     style: ElevatedButton.styleFrom(
                       backgroundColor: const Color(0xFFBD232B),
                       padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                     ),
                     child: const Text(
                       'View Order',
                       style: TextStyle(fontFamily: 'serif', fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
                     ),
                   ),
                   // Optional: push content slightly up to center nicely above bottom nav
                   const SizedBox(height: 48),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
             Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomePage()), (route) => false);
          } else if (index == 2) {
             Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
          }
        },
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color(0xFFDBDBDB),
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFBD232B),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.home_outlined, color: Colors.black, size: 28),
            ),
            label: 'Home',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.notifications_none, color: Colors.black, size: 28), label: 'Alerts'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline, color: Colors.black, size: 28), label: 'Profile'),
        ],
      ),
    );
  }
}
