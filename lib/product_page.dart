import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'delivery_page.dart';

class ProductPage extends StatefulWidget {
  final String? imagePath;
  final String? name;
  final String? price;

  const ProductPage({
    super.key,
    this.imagePath,
    this.name,
    this.price,
  });

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  String _selectedSize = 'L';

  @override
  Widget build(BuildContext context) {
    final String displayImage = widget.imagePath ?? 'assets/images/product/download_1.png';
    final String displayName = widget.name ?? 'Short Frock';
    final String displayPrice = widget.price ?? '200';
    final double priceValue = double.tryParse(displayPrice) ?? 200.0;

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
                      icon: const Padding(padding: EdgeInsets.only(left: 6.0),
                          child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20)),
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
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(40)),
                            child: Column(
                              children: ['S', 'M', 'L', 'XL'].map((size) {
                                final isSelected = _selectedSize == size;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedSize = size),
                                  child: Container(
                                    width: 48, height: 48,
                                    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                                    decoration: BoxDecoration(
                                      color: isSelected ? const Color(0xFFBD232B) : Colors.transparent,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(size, style: TextStyle(
                                        fontFamily: 'serif', fontWeight: FontWeight.bold,
                                        fontSize: 18, color: isSelected ? Colors.white : Colors.black)),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const Spacer(),
                          SizedBox(
                            height: 350,
                            child: Image.asset(displayImage, fit: BoxFit.contain,
                              errorBuilder: (_, __, ___) => Container(width: 200,
                                  color: Colors.grey.shade100,
                                  child: const Icon(Icons.image, size: 80, color: Colors.grey))),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildThumbnail(displayImage),
                          _buildThumbnail(displayImage),
                          _buildThumbnail(displayImage),
                          _buildThumbnail(displayImage),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(displayName, style: const TextStyle(fontFamily: 'serif', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                      Text('Price : Rs.$displayPrice', style: const TextStyle(fontFamily: 'serif', fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                      RichText(
                        text: const TextSpan(
                          style: TextStyle(fontFamily: 'serif', color: Colors.black, fontSize: 16),
                          children: [
                            TextSpan(text: 'Description: ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            TextSpan(text: 'Fashion and Modern Style'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(20)),
                            child: const Text('4 Pair left', style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold, color: Colors.black)),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                            decoration: BoxDecoration(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(20)),
                            child: const Text('Sold 60', style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold, color: Colors.black)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          _buildColorSwatch(const Color(0xFFD97B46)),
                          const SizedBox(width: 16),
                          _buildColorSwatch(const Color(0xFF212121)),
                          const SizedBox(width: 16),
                          _buildColorSwatch(const Color(0xFF339D43)),
                          const SizedBox(width: 16),
                          _buildColorSwatch(const Color(0xFF6B453E)),
                          const SizedBox(width: 16),
                          _buildColorSwatch(const Color(0xFF381B9C)),
                        ],
                      ),
                      const SizedBox(height: 48),
                      Row(
                        children: [
                          // ✅ FIX: Add to Cart — item pass பண்ணும்
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  // ✅ Selected item cart-க்கு pass பண்ணும்
                                  final cartItem = {
                                    'title': displayName,
                                    'price': priceValue,
                                    'qty': 1,
                                    'image': displayImage,
                                    'size': _selectedSize,
                                  };
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CartPage(newItem: cartItem),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFE0E0E0),
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26))),
                                child: const Text('Add to Cart',
                                    style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // ✅ FIX: Buy Now — delivery page-க்கு போகும்
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => DeliveryPage(
                                        cartItems: [
                                          {
                                            'title': displayName,
                                            'price': priceValue,
                                            'qty': 1,
                                            'image': displayImage,
                                          }
                                        ],
                                        subTotal: priceValue,
                                        deliveryFee: 5.0,
                                        discount: 0.0,
                                        totalAmount: priceValue + 5.0,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFBD232B),
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26))),
                                child: const Text('Buy Now',
                                    style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThumbnail(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Image.asset(imagePath, width: 75, height: 75, fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(width: 75, height: 75,
              color: Colors.grey.shade200, child: const Icon(Icons.image, color: Colors.grey))),
    );
  }

  Widget _buildColorSwatch(Color color) {
    return Container(width: 25, height: 25,
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2)));
  }
}