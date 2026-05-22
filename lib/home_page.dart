import 'package:flutter/material.dart';
import 'categories_page.dart';
import 'profile_page.dart';
import 'order_history_page.dart';
import 'cart_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Status Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('9:41', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
                  Row(children: const [
                    Icon(Icons.signal_cellular_4_bar, size: 16, color: Colors.black),
                    SizedBox(width: 4),
                    Icon(Icons.wifi, size: 16, color: Colors.black),
                    SizedBox(width: 4),
                    Icon(Icons.battery_full, size: 16, color: Colors.black),
                  ]),
                ],
              ),
            ),

            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const SizedBox(width: 48),
                  const Expanded(
                    child: Text('MIFRA\nFASHION STORES',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: 'serif', color: Colors.black,
                          fontWeight: FontWeight.bold, fontSize: 18, height: 1.2)),
                  ),
                  // ✅ Cart icon — top right
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage())),
                    child: Container(
                      width: 48, height: 48,
                      decoration: const BoxDecoration(color: Color(0xFFDBDBDB), shape: BoxShape.circle),
                      child: const Icon(Icons.shopping_cart_outlined, color: Colors.black, size: 24),
                    ),
                  ),
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search Bar
                      TextField(
                        decoration: InputDecoration(
                          hintText: 'Search your style',
                          hintStyle: const TextStyle(color: Colors.black87, fontFamily: 'serif', fontSize: 16),
                          prefixIcon: const Icon(Icons.search, color: Colors.black87),
                          suffixIcon: const Icon(Icons.mic, color: Colors.black87),
                          filled: true,
                          fillColor: const Color(0xFFBD232B),
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(24),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // New Arrival
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('New Arrival', style: TextStyle(fontFamily: 'serif', fontSize: 20, fontWeight: FontWeight.bold)),
                          TextButton(
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesPage())),
                            child: const Text('see all', style: TextStyle(fontFamily: 'serif', color: Colors.black87)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Image Row 1
                      Row(
                        children: [
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 0.75,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset('assets/images/home/download_1.jpeg', fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 0.75,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset('assets/images/home/download_2.jpeg', fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // View All Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CategoriesPage())),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFBD232B),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('View All', style: TextStyle(color: Colors.black, fontFamily: 'serif', fontWeight: FontWeight.bold, fontSize: 16)),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward, color: Colors.black),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Image Row 2
                      Row(
                        children: [
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1.2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset('assets/images/home/download_3.jpeg', fit: BoxFit.cover),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AspectRatio(
                              aspectRatio: 1.2,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Image.asset('assets/images/home/download_4.jpeg', fit: BoxFit.cover),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // ✅ Bottom Navigation — Order History சேர்த்தோம்
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(context,
                MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
          } else if (index == 1) {
            // ✅ Order History
            Navigator.push(context, MaterialPageRoute(builder: (_) => const OrderHistoryPage()));
          } else if (index == 2) {
            // Cart
            Navigator.push(context, MaterialPageRoute(builder: (_) => const CartPage()));
          } else if (index == 3) {
            // Profile
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
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
              decoration: const BoxDecoration(color: Color(0xFFBD232B), shape: BoxShape.circle),
              child: const Icon(Icons.home_outlined, color: Colors.black, size: 28),
            ),
            label: 'Home',
          ),
          // ✅ Order History icon
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag_outlined, color: Colors.black, size: 28),
            label: 'Orders',
          ),
          // ✅ Cart icon
          const BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined, color: Colors.black, size: 28),
            label: 'Cart',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person_outline, color: Colors.black, size: 28),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}