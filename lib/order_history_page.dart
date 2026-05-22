import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

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
                    child: Text('Order History', textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: 'serif', fontSize: 22,
                            fontWeight: FontWeight.bold, color: Colors.black)),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),

            // ✅ FIX: StreamBuilder for auth + orders
            Expanded(
              child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, authSnapshot) {
                  if (authSnapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFFBD232B)));
                  }

                  final user = authSnapshot.data;
                  if (user == null) {
                    return const Center(
                      child: Text('Login செய்யுங்கள்!',
                          style: TextStyle(fontFamily: 'serif', fontSize: 18, color: Colors.grey)),
                    );
                  }

                  // ✅ FIX: orderBy நீக்கி — index error தவிர்க்க
                  return StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('orders')
                        .where('userId', isEqualTo: user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator(color: Color(0xFFBD232B)));
                      }

                      if (snapshot.hasError) {
                        return Center(child: Text('பிழை: ${snapshot.error}'));
                      }

                      if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.shopping_bag_outlined, size: 80, color: Colors.grey.shade300),
                              const SizedBox(height: 16),
                              const Text('இன்னும் order இல்லை!',
                                  style: TextStyle(fontFamily: 'serif', fontSize: 18, color: Colors.grey)),
                            ],
                          ),
                        );
                      }

                      // ✅ Client-side sort by createdAt
                      final orders = snapshot.data!.docs;
                      orders.sort((a, b) {
                        final aData = a.data() as Map<String, dynamic>;
                        final bData = b.data() as Map<String, dynamic>;
                        final aTime = aData['createdAt'] as Timestamp?;
                        final bTime = bData['createdAt'] as Timestamp?;
                        if (aTime == null || bTime == null) return 0;
                        return bTime.compareTo(aTime);
                      });

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: orders.length,
                        itemBuilder: (context, index) {
                          final order = orders[index].data() as Map<String, dynamic>;
                          final items = order['items'] as List<dynamic>? ?? [];
                          final createdAt = order['createdAt'] as Timestamp?;
                          final date = createdAt != null
                              ? '${createdAt.toDate().day}/${createdAt.toDate().month}/${createdAt.toDate().year}'
                              : 'N/A';

                          return Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDBDBDB),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Order Header
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Order #${index + 1}',
                                          style: const TextStyle(fontFamily: 'serif',
                                              fontSize: 16, fontWeight: FontWeight.bold)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFBD232B),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(order['status'] ?? 'Confirmed',
                                            style: const TextStyle(color: Colors.white,
                                                fontSize: 12, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text('Date: $date',
                                      style: const TextStyle(fontSize: 13, color: Colors.black54)),
                                  Text('Payment: ${order['paymentMethod'] ?? 'N/A'}',
                                      style: const TextStyle(fontSize: 13, color: Colors.black54)),
                                  const Divider(height: 16),

                                  // Items
                                  ...items.map((item) {
                                    final i = item as Map<String, dynamic>;
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 2),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('${i['title']} x${i['qty']}',
                                              style: const TextStyle(fontFamily: 'serif', fontSize: 14)),
                                          Text('Rs.${i['price']}',
                                              style: const TextStyle(fontFamily: 'serif',
                                                  fontSize: 14, fontWeight: FontWeight.bold)),
                                        ],
                                      ),
                                    );
                                  }),
                                  const Divider(height: 16),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Total',
                                          style: TextStyle(fontFamily: 'serif',
                                              fontSize: 16, fontWeight: FontWeight.bold)),
                                      Text('Rs.${order['totalAmount']}',
                                          style: const TextStyle(fontFamily: 'serif',
                                              fontSize: 16, fontWeight: FontWeight.bold,
                                              color: Color(0xFFBD232B))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}