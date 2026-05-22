import 'package:flutter/material.dart';
import 'product_page.dart';
import 'profile_page.dart';
import 'home_page.dart';

class ClothesPage extends StatelessWidget {
  const ClothesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Container(
                    width: 48, height: 48,
                    decoration: const BoxDecoration(color: Color(0xFFBD232B), shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Padding(padding: EdgeInsets.only(left: 6.0), child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Spacer(),
                  IconButton(icon: const Icon(Icons.search, color: Colors.black, size: 28), onPressed: () {}),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Clothes', style: TextStyle(fontFamily: 'serif', fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)),
            ),
            Expanded(
              child: GridView.count(
                padding: const EdgeInsets.all(16.0),
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.65,
                children: [
                  _buildClothCard(context, imagePath: 'assets/images/clothes/download_1.jpeg', title: 'Short Frock', price: '200',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductPage(name: 'Short Frock', price: '200', imagePath: 'assets/images/clothes/download_1.jpeg')))),
                  _buildClothCard(context, imagePath: 'assets/images/clothes/download_2.jpeg', title: 'Shirt', price: '180',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductPage(name: 'Shirt', price: '180', imagePath: 'assets/images/clothes/download_2.jpeg')))),
                  _buildClothCard(context, imagePath: 'assets/images/clothes/download_3.jpeg', title: 'Kids choice', price: '89',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductPage(name: 'Kids Choice', price: '89', imagePath: 'assets/images/clothes/download_3.jpeg')))),
                  _buildClothCard(context, imagePath: 'assets/images/clothes/download_4.jpeg', title: 'Summer wear', price: '130',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductPage(name: 'Summer Wear', price: '130', imagePath: 'assets/images/clothes/download_4.jpeg')))),
                  _buildClothCard(context, imagePath: 'assets/images/clothes/download_5.jpeg', title: 'Mens Casual', price: '110',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductPage(name: 'Mens Casual', price: '110', imagePath: 'assets/images/clothes/download_5.jpeg')))),
                  _buildClothCard(context, imagePath: 'assets/images/clothes/download_6.jpeg', title: 'Formal Suit', price: '250',
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductPage(name: 'Formal Suit', price: '250', imagePath: 'assets/images/clothes/download_6.jpeg')))),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildClothCard(BuildContext context, {required String imagePath, required String title, required String price, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ClipRRect(
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200, child: const Icon(Icons.image, color: Colors.grey, size: 48)),
                  ),
                ),
                const Positioned(top: 8, right: 8, child: Icon(Icons.favorite_border, color: Colors.black, size: 32)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontFamily: 'serif', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
          Text('\$$price.00', style: const TextStyle(fontFamily: 'serif', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        ],
      ),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return BottomNavigationBar(
      onTap: (index) {
        if (index == 0) Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const HomePage()), (route) => false);
        else if (index == 3) Navigator.push(context, MaterialPageRoute(builder: (_) => const ProfilePage()));
      },
      showSelectedLabels: false,
      showUnselectedLabels: false,
      type: BottomNavigationBarType.fixed,
      backgroundColor: const Color(0xFFDBDBDB),
      items: [
        BottomNavigationBarItem(
          icon: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFFBD232B), shape: BoxShape.circle),
            child: const Icon(Icons.home_outlined, color: Colors.black, size: 28)),
          label: 'Home',
        ),
        const BottomNavigationBarItem(icon: Icon(Icons.notifications_none, color: Colors.black, size: 28), label: 'Alerts'),
        const BottomNavigationBarItem(icon: Icon(Icons.favorite_border, color: Colors.black, size: 28), label: 'Favorites'),
        const BottomNavigationBarItem(icon: Icon(Icons.person_outline, color: Colors.black, size: 28), label: 'Profile'),
      ],
    );
  }
}