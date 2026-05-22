import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'delivery_page.dart';

class CartPage extends StatefulWidget {
  // ✅ newItem — product page-லிருந்து வரும்
  final Map<String, dynamic>? newItem;

  const CartPage({super.key, this.newItem});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late List<Map<String, dynamic>> _items;

  double deliveryFee = 5.0;
  double discountAmount = 50.0;

  @override
  void initState() {
    super.initState();
    // Default items
    _items = [
      {'title': 'Short Frock', 'price': 200.00, 'qty': 1, 'image': 'assets/images/my cart/download_1.png'},
      {'title': 'Mens Watch', 'price': 100.00, 'qty': 1, 'image': 'assets/images/my cart/download_2.jpeg'},
      {'title': 'Mens Wallet', 'price': 90.00, 'qty': 1, 'image': 'assets/images/my cart/download_3.png'},
    ];

    // ✅ Product page-லிருந்து item வந்தால் add பண்ணும்
    if (widget.newItem != null) {
      final newItem = widget.newItem!;
      // Already இருக்கா check பண்ணும்
      final existingIndex = _items.indexWhere((i) => i['title'] == newItem['title']);
      if (existingIndex >= 0) {
        _items[existingIndex]['qty']++;
      } else {
        _items.add(Map.from(newItem));
      }
    }
  }

  double get subTotal => _items.fold(0, (sum, item) => sum + (item['price'] * item['qty']));
  double get totalAmount => subTotal + deliveryFee - discountAmount;
  int get totalItems => _items.fold(0, (sum, item) => sum + (item['qty'] as int));

  void _incrementQty(int index) => setState(() => _items[index]['qty']++);
  void _decrementQty(int index) {
    setState(() { if (_items[index]['qty'] > 1) _items[index]['qty']--; });
  }
  void _removeItem(int index) => setState(() => _items.removeAt(index));

  Future<void> _proceedToCheckout() async {
    final user = await FirebaseAuth.instance.authStateChanges().first;
    if (!mounted) return;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('முதலில் login செய்யுங்கள்!'), backgroundColor: Colors.red),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DeliveryPage(
          cartItems: List.from(_items),
          totalAmount: totalAmount,
          subTotal: subTotal,
          deliveryFee: deliveryFee,
          discount: discountAmount,
        ),
      ),
    );
  }

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
                      icon: const Padding(padding: EdgeInsets.only(left: 6.0),
                          child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Expanded(
                    child: Text('My Cart', textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'serif', color: Colors.black,
                            fontWeight: FontWeight.bold, fontSize: 26)),
                  ),
                  IconButton(icon: const Icon(Icons.search, color: Colors.black, size: 28), onPressed: () {}),
                ],
              ),
            ),
            Expanded(
              child: _items.isEmpty
                  ? const Center(child: Text('Cart காலியாக உள்ளது',
                      style: TextStyle(fontFamily: 'serif', fontSize: 18, color: Colors.black54)))
                  : ListView.builder(
                      padding: const EdgeInsets.all(16.0),
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final item = _items[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: _buildCartItem(item, index),
                        );
                      },
                    ),
            ),
            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(color: Color(0xFFDBDBDB)),
              child: Column(
                children: [
                  _buildSummaryRow('Sub Total ($totalItems items)', 'Rs.${subTotal.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Delivery Fee', 'Rs.${deliveryFee.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Discount', '- Rs.${discountAmount.toStringAsFixed(2)}'),
                  const Divider(thickness: 1, color: Colors.black38),
                  _buildSummaryRow('Total', 'Rs.${totalAmount.toStringAsFixed(2)}'),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity, height: 52,
                    child: ElevatedButton(
                      onPressed: () => _proceedToCheckout(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBD232B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Proceed to Checkout',
                              style: TextStyle(fontFamily: 'serif', fontSize: 18,
                                  color: Colors.black, fontWeight: FontWeight.bold)),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'serif', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
        Text(value, style: const TextStyle(fontFamily: 'serif', fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }

  Widget _buildCartItem(Map<String, dynamic> item, int index) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topCenter, end: Alignment.bottomCenter,
          colors: [Color(0xFFCEB0AE), Color(0xFFBD232B)],
        ),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(item['image'], width: 80, height: 100, fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Container(width: 80, height: 100,
                          color: Colors.grey.shade200, child: const Icon(Icons.image, color: Colors.grey))),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(item['title'], style: const TextStyle(fontFamily: 'serif',
                        fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black)),
                    const SizedBox(height: 4),
                    if (item['size'] != null)
                      Text('Size: ${item['size']}', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                    const SizedBox(height: 8),
                    Text('Rs.${item['price'].toStringAsFixed(2)}',
                        style: const TextStyle(fontFamily: 'serif', fontSize: 14,
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 16.0, bottom: 16.0),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () => _decrementQty(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: const Color(0xFFDBDBDB), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.remove, size: 20, color: Colors.black),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text('${item['qty']}', style: const TextStyle(fontFamily: 'serif',
                          fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: () => _incrementQty(index),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(color: const Color(0xFFDBDBDB), borderRadius: BorderRadius.circular(8)),
                          child: const Icon(Icons.add, size: 20, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 8, right: 8,
            child: GestureDetector(
              onTap: () => _removeItem(index),
              child: const Icon(Icons.close, color: Colors.black, size: 24),
            ),
          ),
        ],
      ),
    );
  }
}