import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'complete_page.dart';

class PaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;
  final double subTotal;
  final double deliveryFee;
  final double discount;
  final String deliveryName;
  final String deliveryPhone;
  final String deliveryAddress;
  final String deliveryCity;
  final String deliveryPostal;
  final String deliveryType;

  const PaymentPage({
    super.key,
    this.cartItems = const [],
    this.totalAmount = 0.0,
    this.subTotal = 0.0,
    this.deliveryFee = 0.0,
    this.discount = 0.0,
    this.deliveryName = '',
    this.deliveryPhone = '',
    this.deliveryAddress = '',
    this.deliveryCity = '',
    this.deliveryPostal = '',
    this.deliveryType = 'Standard Delivery',
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  bool _isLoading = false;
  String _selectedPayment = 'Credit/Debit Card';

  Future<void> _placeOrder() async {
    setState(() => _isLoading = true);

    try {
      final user = await FirebaseAuth.instance.authStateChanges().first;

      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('முதலில் login செய்யுங்கள்!'), backgroundColor: Colors.red),
          );
        }
        setState(() => _isLoading = false);
        return;
      }

      await FirebaseFirestore.instance.collection('orders').add({
        'userId': user.uid,
        'userEmail': user.email ?? '',
        'items': widget.cartItems.map((item) => {
          'title': item['title'] ?? '',
          'price': item['price'] ?? 0.0,
          'qty': item['qty'] ?? 1,
        }).toList(),
        'subTotal': widget.subTotal,
        'deliveryFee': widget.deliveryFee,
        'discount': widget.discount,
        'totalAmount': widget.totalAmount,
        'paymentMethod': _selectedPayment,
        'deliveryDetails': {
          'name': widget.deliveryName,
          'phone': widget.deliveryPhone,
          'address': widget.deliveryAddress,
          'city': widget.deliveryCity,
          'postal': widget.deliveryPostal,
          'type': widget.deliveryType,
        },
        'status': 'Confirmed',
        'createdAt': FieldValue.serverTimestamp(),
      });

      setState(() => _isLoading = false);

      if (mounted) {
        Navigator.push(context, MaterialPageRoute(builder: (_) => const CompletePage()));
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('பிழை: $e'), backgroundColor: Colors.red),
        );
      }
    }
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
                  const Spacer(),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 8.0, bottom: 16.0),
              child: Text('Select Payment Method',
                  style: TextStyle(fontFamily: 'serif', fontSize: 24,
                      fontWeight: FontWeight.bold, color: Colors.black)),
            ),

            // Delivery Summary
            if (widget.deliveryName.isNotEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF3DE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: Color(0xFF3B6D11), size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${widget.deliveryName} • ${widget.deliveryAddress}, ${widget.deliveryCity}',
                        style: const TextStyle(fontFamily: 'serif', fontSize: 13, color: Color(0xFF3B6D11)),
                      ),
                    ),
                  ],
                ),
              ),

            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      _buildPaymentOption('Credit/Debit Card', Icons.credit_card),
                      const SizedBox(height: 24),
                      _buildPaymentOption('Cash on Delivery', Icons.money),
                      const SizedBox(height: 24),
                      _buildPaymentOption('Instalment', Icons.payment),
                    ],
                  ),
                ),
              ),
            ),

            Container(
              padding: const EdgeInsets.all(24.0),
              decoration: const BoxDecoration(color: Color(0xFFDBDBDB)),
              child: Column(
                children: [
                  _buildSummaryRow('Sub Total', 'Rs.${widget.subTotal.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Delivery Fee', 'Rs.${widget.deliveryFee.toStringAsFixed(2)}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Discount', '- Rs.${widget.discount.toStringAsFixed(2)}'),
                  const Divider(thickness: 1, color: Colors.black38),
                  _buildSummaryRow('Total Amount', 'Rs.${widget.totalAmount.toStringAsFixed(2)}'),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity, height: 52,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _placeOrder,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFBD232B),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        disabledBackgroundColor: Colors.grey,
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Pay Now',
                              style: TextStyle(fontFamily: 'serif', fontSize: 24,
                                  color: Colors.black, fontWeight: FontWeight.bold)),
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

  Widget _buildPaymentOption(String label, IconData icon) {
    final isSelected = _selectedPayment == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedPayment = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFFDBDBDB),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.blueAccent : Colors.transparent, width: 3),
        ),
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontFamily: 'serif', fontSize: 18,
                fontWeight: FontWeight.bold, color: Colors.black)),
            const Spacer(),
            Icon(icon, size: 32, color: Colors.black54),
            const SizedBox(width: 12),
            Icon(isSelected ? Icons.check_circle : Icons.arrow_forward_ios,
                color: isSelected ? Colors.blueAccent : Colors.black, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'serif', fontSize: 16,
            fontWeight: FontWeight.bold, color: Colors.black)),
        Text(value, style: const TextStyle(fontFamily: 'serif', fontSize: 16,
            fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }
}