import 'package:flutter/material.dart';
import 'payment_page.dart';

class DeliveryPage extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double totalAmount;
  final double subTotal;
  final double deliveryFee;
  final double discount;

  const DeliveryPage({
    super.key,
    required this.cartItems,
    required this.totalAmount,
    required this.subTotal,
    required this.deliveryFee,
    required this.discount,
  });

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _postalController = TextEditingController();

  String _selectedDelivery = 'Standard Delivery';

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalController.dispose();
    super.dispose();
  }

  void _proceed() {
    if (_nameController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _addressController.text.trim().isEmpty ||
        _cityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('அனைத்து fields-உம் பூர்த்தி செய்யுங்கள்!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentPage(
          cartItems: widget.cartItems,
          totalAmount: widget.totalAmount,
          subTotal: widget.subTotal,
          deliveryFee: widget.deliveryFee,
          discount: widget.discount,
          deliveryName: _nameController.text.trim(),
          deliveryPhone: _phoneController.text.trim(),
          deliveryAddress: _addressController.text.trim(),
          deliveryCity: _cityController.text.trim(),
          deliveryPostal: _postalController.text.trim(),
          deliveryType: _selectedDelivery,
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
            // Status Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('9:41',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black)),
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
                  Container(
                    width: 48, height: 48,
                    decoration: const BoxDecoration(color: Color(0xFFBD232B), shape: BoxShape.circle),
                    child: IconButton(
                      icon: const Padding(
                        padding: EdgeInsets.only(left: 6.0),
                        child: Icon(Icons.arrow_back_ios, color: Colors.black, size: 20),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  const Spacer(),
                  const Text('Delivery Details',
                      style: TextStyle(fontFamily: 'serif', fontSize: 22,
                          fontWeight: FontWeight.bold, color: Colors.black)),
                  const Spacer(),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // Form
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Type
                    const Text('Delivery Type',
                        style: TextStyle(fontFamily: 'serif', fontSize: 16,
                            fontWeight: FontWeight.bold, color: Colors.black)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildDeliveryType('Standard Delivery', 'Rs.5.00', Icons.local_shipping_outlined),
                        const SizedBox(width: 12),
                        _buildDeliveryType('Express Delivery', 'Rs.15.00', Icons.flash_on),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Full Name
                    _buildLabel('Full Name'),
                    _buildTextField(_nameController, 'உங்கள் பெயர்', Icons.person_outline),
                    const SizedBox(height: 16),

                    // Phone
                    _buildLabel('Phone Number'),
                    _buildTextField(_phoneController, '07XXXXXXXX', Icons.phone_outlined,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 16),

                    // Address
                    _buildLabel('Street Address'),
                    _buildTextField(_addressController, 'No. X, Street Name', Icons.home_outlined,
                        maxLines: 2),
                    const SizedBox(height: 16),

                    // City
                    _buildLabel('City'),
                    _buildTextField(_cityController, 'Colombo', Icons.location_city_outlined),
                    const SizedBox(height: 16),

                    // Postal Code
                    _buildLabel('Postal Code (Optional)'),
                    _buildTextField(_postalController, '10000', Icons.markunread_mailbox_outlined,
                        keyboardType: TextInputType.number),
                    const SizedBox(height: 32),

                    // Summary
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFDBDBDB),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow('Sub Total', 'Rs.${widget.subTotal.toStringAsFixed(2)}'),
                          const SizedBox(height: 6),
                          _buildSummaryRow('Delivery Fee', 'Rs.${widget.deliveryFee.toStringAsFixed(2)}'),
                          const SizedBox(height: 6),
                          _buildSummaryRow('Discount', '- Rs.${widget.discount.toStringAsFixed(2)}'),
                          const Divider(thickness: 1, color: Colors.black38),
                          _buildSummaryRow('Total', 'Rs.${widget.totalAmount.toStringAsFixed(2)}'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Proceed Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _proceed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFBD232B),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text('Proceed to Payment',
                            style: TextStyle(fontFamily: 'serif', fontSize: 18,
                                color: Colors.black, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryType(String label, String price, IconData icon) {
    final isSelected = _selectedDelivery == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedDelivery = label),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFBD232B) : const Color(0xFFDBDBDB),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? const Color(0xFFBD232B) : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? Colors.white : Colors.black, size: 28),
              const SizedBox(height: 6),
              Text(label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'serif', fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black)),
              Text(price,
                  style: TextStyle(
                      fontFamily: 'serif', fontSize: 11,
                      color: isSelected ? Colors.white70 : Colors.black54)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(label,
          style: const TextStyle(fontFamily: 'serif', fontSize: 14,
              fontWeight: FontWeight.bold, color: Colors.black54)),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon,
      {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.black12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(fontFamily: 'serif', fontSize: 15, color: Colors.black),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: const Color(0xFFBD232B), size: 20),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontFamily: 'serif', fontSize: 14,
            fontWeight: FontWeight.bold, color: Colors.black)),
        Text(value, style: const TextStyle(fontFamily: 'serif', fontSize: 14,
            fontWeight: FontWeight.bold, color: Colors.black)),
      ],
    );
  }
}