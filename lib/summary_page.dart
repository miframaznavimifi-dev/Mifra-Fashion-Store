import 'package:flutter/material.dart';
import 'profile_page.dart';
import 'home_page.dart';

class SummaryPage extends StatelessWidget {
  const SummaryPage({super.key});

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
                  const Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(right: 48.0),
                      child: Text(
                        'Order Summary',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'serif', fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Location info
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Image.asset('assets/images/summary/download_1.png', width: 24, height: 24, fit: BoxFit.contain),
                           const SizedBox(width: 8),
                           const Expanded(
                             child: Text(
                               'M.M.F.Mifra 0734564320\nB/13/C,Main Street,Galle',
                               style: TextStyle(fontFamily: 'serif', fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600, height: 1.3),
                             ),
                           ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Items Section (Grey Box)
                    Container(
                      width: double.infinity,
                      color: const Color(0xFFDBDBDB),
                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
                      child: Column(
                        children: [
                          _buildOrderItem('assets/images/summary/download_2.png', 'Short Frock', '\$200.00', '1'),
                          const SizedBox(height: 16),
                          _buildOrderItem('assets/images/summary/download_3.png', 'Mens Watch', '\$100.00', '1'),
                          const SizedBox(height: 16),
                          _buildOrderItem('assets/images/summary/download_4.png', 'Mens Wallet', '\$90.00', '1'),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Summary Details
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: [
                          _buildSummaryRow('Sub Total (3 items)', '\$390.00'),
                          const SizedBox(height: 8),
                          _buildSummaryRow('Delivery Fee', '\$5.00'),
                          const SizedBox(height: 8),
                          _buildSummaryRow('Total', '\$395.00'),
                          const SizedBox(height: 8),
                          _buildSummaryRow('Debit Card', '\$200.00'),
                          const SizedBox(height: 8),
                          _buildSummaryRow('Order No', '465643598059'),
                          const SizedBox(height: 8),
                          _buildSummaryRow('Placed On', '10 April 2026 10:32:02'),
                          const SizedBox(height: 8),
                          _buildSummaryRow('Paid by', 'Debit Card'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24), // Bottom padding
                  ],
                ),
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

  Widget _buildOrderItem(String imagePath, String title, String price, String qty) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(imagePath, width: 80, height: 80, fit: BoxFit.contain),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Text(title, style: const TextStyle(fontFamily: 'serif', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 4),
              Text(price, style: const TextStyle(fontFamily: 'serif', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
            ],
          ),
        ),
        Column(
          children: [
             const SizedBox(height: 36),
             Text('Qty      $qty', style: const TextStyle(fontFamily: 'serif', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'serif', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
        Text(value, style: const TextStyle(fontFamily: 'serif', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }
}
