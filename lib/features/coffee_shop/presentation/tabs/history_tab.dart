import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/services/auth_service.dart';

class HistoryTab extends StatelessWidget {
  const HistoryTab({super.key, required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            if (user == null)
              const Expanded(
                child: Center(child: Text('Sign in to view your orders')),
              )
            else
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(user.uid)
                      .collection('orders')
                      .orderBy('createdAt', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    }
                    final docs = snapshot.data?.docs ?? [];
                    if (docs.isEmpty) {
                      return const Center(child: Text('No orders yet'));
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        final d = docs[index];
                        final data = d.data() as Map<String, dynamic>;
                        final ts = data['createdAt'];
                        DateTime created;
                        if (ts is Timestamp) {
                          created = ts.toDate();
                        } else if (ts is DateTime) {
                          created = ts;
                        } else {
                          created = DateTime.now();
                        }
                        final target = data['autoDeliverAt'];
                        DateTime? autoDeliverAt;
                        if (target is Timestamp)
                          autoDeliverAt = target.toDate();
                        else if (target is DateTime)
                          autoDeliverAt = target;
                        String status =
                            (data['status'] as String?) ?? 'pending';
                        // Compute derived status if pending and past autoDeliverAt.
                        if (status == 'pending' &&
                            autoDeliverAt != null &&
                            DateTime.now().isAfter(autoDeliverAt)) {
                          status = 'delivered';
                        }
                        final items = (data['items'] as List<dynamic>? ?? []);
                        final total = (data['total'] as num?)?.toDouble() ?? 0;
                        final itemsLabel = items
                            .map((e) {
                              if (e is Map<String, dynamic>) {
                                final name = (e['name'] ?? '') as String;
                                final qty = (e['qty'] ?? 1).toString();
                                return '$name x$qty';
                              }
                              return '';
                            })
                            .where((s) => s.isNotEmpty)
                            .join(', ');
                        final createdStr = _formatDate(created);
                        final etaMinutes = autoDeliverAt != null
                            ? autoDeliverAt.difference(DateTime.now()).inMinutes
                            : null;
                        return _OrderCard(
                          items: itemsLabel,
                          date: createdStr,
                          price: '\$${total.toStringAsFixed(2)}',
                          status: status,
                          etaMinutes:
                              status == 'pending' &&
                                  etaMinutes != null &&
                                  etaMinutes > 0
                              ? etaMinutes
                              : null,
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

  Widget _header() => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    child: Row(
      children: [
        GestureDetector(
          onTap: onBack,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.arrow_back, color: Colors.black, size: 20),
          ),
        ),
        const Expanded(
          child: Text(
            'Order History',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: 'Inter',
            ),
          ),
        ),
        const SizedBox(width: 36),
      ],
    ),
  );

  String _formatDate(DateTime dt) {
    return '${dt.year}-${_two(dt.month)}-${_two(dt.day)} ${_two(dt.hour)}:${_two(dt.minute)}';
  }

  String _two(int v) => v.toString().padLeft(2, '0');
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.items,
    required this.date,
    required this.price,
    required this.status,
    this.etaMinutes,
  });
  final String items;
  final String date;
  final String price;
  final String status; // pending | delivered | cancelled
  final int? etaMinutes;

  Color get _statusColor => switch (status) {
    'delivered' => Colors.green,
    'cancelled' => Colors.red,
    _ => Colors.orange,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFC67C4E).withOpacity(0.15),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.local_cafe,
              color: Color(0xFFC67C4E),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  items,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  date,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
                const SizedBox(height: 4),
                Text(
                  price,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFFC67C4E),
                    fontFamily: 'Montserrat',
                  ),
                ),
                if (etaMinutes != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'ETA ~ $etaMinutes min',
                      style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status[0].toUpperCase() + status.substring(1),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _statusColor,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
