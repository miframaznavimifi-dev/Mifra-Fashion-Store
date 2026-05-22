import 'package:flutter/material.dart';
import 'clothes_page.dart';
import 'profile_page.dart';
import 'home_page.dart';
import 'product_page.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

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
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 8),
                      const Text('Categories', style: TextStyle(fontFamily: 'serif', fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(height: 24),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ClothesPage())),
                        child: _buildCategoryCard('Clothes', 'assets/images/categories/download_1.jpeg'),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BagsPage())),
                        child: _buildCategoryCard('Bags', 'assets/images/categories/download_2.jpeg'),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const JewelleriesPage())),
                        child: _buildCategoryCard('Jewelleries', 'assets/images/categories/download_3.jpeg'),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ShoesPage())),
                        child: _buildCategoryCard('Shoes', 'assets/images/categories/download_4.jpeg'),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
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
      ),
    );
  }

  Widget _buildCategoryCard(String title, String imagePath) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.3), BlendMode.darken),
        ),
      ),
      alignment: Alignment.center,
      child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 28, fontFamily: 'serif', fontWeight: FontWeight.bold, letterSpacing: 1.0)),
    );
  }
}

// ============ BAGS PAGE ============
class BagsPage extends StatelessWidget {
  const BagsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _buildProductListPage(
      context: context,
      title: 'Bags',
      products: [
        {'name': 'Hand Bag', 'price': '\$150.00', 'image': 'assets/images/product/bag1.jpg'},
        {'name': 'Shoulder Bag', 'price': '\$120.00', 'image': 'assets/images/product/bag2.jpg'},
        {'name': 'Hand Bag', 'price': '\$90.00', 'image': 'assets/images/product/bag3.jpg'},
        {'name': 'Tote Bag', 'price': '\$75.00', 'image': 'assets/images/product/bag4.jpg'},
      ],
    );
  }
}

// ============ JEWELLERIES PAGE ============
class JewelleriesPage extends StatelessWidget {
  const JewelleriesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _buildProductListPage(
      context: context,
      title: 'Jewelleries',
      products: [
        {'name': 'Gold Necklace', 'price': '\$300.00', 'image': 'assets/images/product/jewel1.jpg'},
        {'name': 'Earrings', 'price': '\$60.00', 'image': 'assets/images/product/jewel2.jpg'},
        {'name': 'Bracelet', 'price': '\$120.00', 'image': 'assets/images/product/jewel3.jpg'},
        {'name': 'Silver Ring', 'price': '\$80.00', 'image': 'assets/images/product/jewel4.jpg'},
      ],
    );
  }
}

// ============ SHOES PAGE ============
class ShoesPage extends StatelessWidget {
  const ShoesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return _buildProductListPage(
      context: context,
      title: 'Shoes',
      products: [
        {'name': 'Sandals', 'price': '\$90.00', 'image': 'assets/images/product/shoe1.jpg'},
        {'name': 'Sneakers', 'price': '\$180.00', 'image': 'assets/images/product/shoe2.jpg'},
        {'name': 'Boots', 'price': '\$220.00', 'image': 'assets/images/product/shoe3.jpg'},
        {'name': 'Heels', 'price': '\$150.00', 'image': 'assets/images/product/shoe4.jpg'},
      ],
    );
  }
}

// ============ SHARED PRODUCT LIST PAGE ============
Widget _buildProductListPage({
  required BuildContext context,
  required String title,
  required List<Map<String, String>> products,
}) {
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(title, style: const TextStyle(fontFamily: 'serif', fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black)),
          ),
          Expanded(
            child: GridView.count(
              padding: const EdgeInsets.all(16.0),
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 0.75,
              children: products.map((product) {
                return GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductPage(imagePath: product['image'], name: product['name'], price: product['price']))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                product['image']!,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.image, color: Colors.grey, size: 48),
                                ),
                              ),
                            ),
                            const Positioned(top: 8, right: 8, child: Icon(Icons.favorite_border, color: Colors.black, size: 32)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(product['name']!, style: const TextStyle(fontFamily: 'serif', fontSize: 16, fontWeight: FontWeight.bold)),
                      Text(product['price']!, style: const TextStyle(fontFamily: 'serif', fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}