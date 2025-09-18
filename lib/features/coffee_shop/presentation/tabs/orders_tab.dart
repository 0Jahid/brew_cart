import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/models/order_item.dart';
import '../../../../core/services/auth_service.dart';
import '../state/coffee_shop_nav.dart';

class OrdersTab extends StatefulWidget {
  const OrdersTab({super.key, required this.onBack});
  final VoidCallback onBack;
  @override
  State<OrdersTab> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<OrdersTab> {
  final cart = CartManager();
  final promoController = TextEditingController();
  String? appliedPromoCode;
  String? promoError;
  double promoDiscount = 0.0; // monetary amount
  String paymentMethod = 'Cash';
  bool placing = false;

  @override
  void dispose() {
    promoController.dispose();
    super.dispose();
  }

  double get subtotal => cart.totalPrice;
  static const double deliveryFee = 2.00;
  static const double serviceFee = 1.00;
  double get total => (subtotal - promoDiscount) + deliveryFee + serviceFee;

  Future<void> _applyPromo() async {
    final code = promoController.text.trim().toUpperCase();
    if (code.isEmpty) return;
    setState(() {
      promoError = null;
      appliedPromoCode = null;
      promoDiscount = 0;
    });
    try {
      final doc = await FirebaseFirestore.instance
          .collection('promo_codes')
          .doc(code)
          .get();
      if (!doc.exists) {
        setState(() => promoError = 'Code not found');
        return;
      }
      final data = doc.data()!;
      if (!(data['isActive'] as bool? ?? false)) {
        setState(() => promoError = 'Code inactive');
        return;
      }
      final minOrder = (data['minOrder'] as num?)?.toDouble() ?? 0;
      if (subtotal < minOrder) {
        setState(
          () => promoError = 'Min order ৳${minOrder.toStringAsFixed(2)}',
        );
        return;
      }
      final type = data['type'];
      double discount = 0;
      if (type == 'percent') {
        final percent = (data['value'] as num?)?.toDouble() ?? 0;
        discount = subtotal * (percent / 100);
        final maxDisc = (data['maxDiscount'] as num?)?.toDouble();
        if (maxDisc != null) discount = discount.clamp(0, maxDisc);
      } else if (type == 'amount') {
        discount = (data['value'] as num?)?.toDouble() ?? 0;
      }
      setState(() {
        appliedPromoCode = code;
        promoDiscount = discount;
      });
    } catch (e) {
      setState(() => promoError = 'Error: $e');
    }
  }

  Future<void> _placeOrder() async {
    if (cart.cartItems.isEmpty) return;
    final user = AuthService.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please sign in')));
      return;
    }
    // Capture financial snapshot BEFORE clearing cart so dialog shows real totals.
    final snapSubtotal = subtotal;
    final snapPromoDiscount = promoDiscount;
    final snapDelivery = deliveryFee;
    final snapService = serviceFee;
    final snapTotal = total; // uses current getters
    final now = DateTime.now();
    final autoDeliverAt = now.add(const Duration(minutes: 25));

    setState(() => placing = true);
    try {
      final userOrders = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('orders');
      final orderRef = userOrders.doc();
      await orderRef.set({
        'createdAt': FieldValue.serverTimestamp(),
        'autoDeliverAt': autoDeliverAt, // client computed target delivery time
        'status': 'pending',
        'items': [
          for (final i in cart.cartItems)
            {
              'coffeeId': i.coffeeId,
              'name': i.coffeeName,
              'size': i.size,
              'sugar': i.sugar,
              'ice': i.ice,
              'qty': i.quantity,
              // Extract numeric unit price from string like "$4.50"
              'unitPrice': () {
                final m = RegExp(
                  r'[0-9]+(?:\.[0-9]+)?',
                ).firstMatch(i.coffeePrice);
                return m != null ? double.tryParse(m.group(0)!) ?? 0 : 0;
              }(),
              'total': i.totalPrice,
            },
        ],
        'subtotal': snapSubtotal,
        'deliveryFee': snapDelivery,
        'serviceFee': snapService,
        'promoCode': appliedPromoCode,
        'promoDiscount': snapPromoDiscount,
        'total': snapTotal,
        'paymentMethod': paymentMethod,
      });

      // Rewards: 1 point per whole currency unit spent (based on total).
      // Also increment user's ordersCount and update lastOrderAt.
      final pointsInc = snapTotal.floor();
      final userDoc = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid);
      await FirebaseFirestore.instance.runTransaction((tx) async {
        final snap = await tx.get(userDoc);
        final data = (snap.data() as Map<String, dynamic>?) ?? {};
        final prevPoints = (data['points'] as num?)?.toInt() ?? 0;
        final prevRewards = (data['rewardsCount'] as num?)?.toInt() ?? 0;
        final newPoints = prevPoints + pointsInc;
        // Earn 1 reward for every 100 points accumulated (cumulative).
        final earnedBefore = prevPoints ~/ 100;
        final earnedAfter = newPoints ~/ 100;
        final newlyEarned = (earnedAfter - earnedBefore);
        final newRewards = prevRewards + (newlyEarned > 0 ? newlyEarned : 0);
        tx.set(userDoc, {
          'points': newPoints,
          'rewardsCount': newRewards,
          'ordersCount': FieldValue.increment(1),
          'lastOrderAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });

      cart.clearCart();
      setState(() {
        appliedPromoCode = null;
        promoDiscount = 0;
      });

      if (!mounted) return;
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Order Placed'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total: ৳${snapTotal.toStringAsFixed(2)}'),
              const SizedBox(height: 4),
              Text('Estimated delivery in 25 min'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context); // close dialog
                setCoffeeShopTab(2); // History tab index
              },
              child: const Text('Track Order'),
            ),
          ],
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to place order: $e')));
    } finally {
      if (mounted) setState(() => placing = false);
    }
  }

  void _changePayment() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final m in ['Cash', 'Card', 'Wallet'])
              RadioListTile<String>(
                title: Text(m),
                value: m,
                groupValue: paymentMethod,
                onChanged: (v) {
                  setState(() => paymentMethod = v!);
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    _buildCartList(),
                    const SizedBox(height: 16),
                    _buildPromoSection(),
                    const SizedBox(height: 16),
                    _buildSummaryCard(),
                    const SizedBox(height: 16),
                    _buildPaymentMethodCard(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            _buildPlaceOrderBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: widget.onBack,
          ),
          const Expanded(
            child: Text(
              'Your Cart',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildCartList() {
    final items = cart.cartItems;
    if (items.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: _cardDecoration(),
        child: const Column(
          children: [
            Icon(Icons.shopping_cart_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text('Your cart is empty'),
          ],
        ),
      );
    }
    return Container(
      decoration: _cardDecoration(),
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final it = items[index];
          return ListTile(
            title: Text(it.coffeeName),
            subtitle: Text('${it.size} • ${it.sugar} • ${it.ice}'),
            leading: CircleAvatar(
              backgroundColor: Colors.brown.shade100,
              child: const Icon(Icons.coffee),
            ),
            trailing: SizedBox(
              width: 130,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _qtyBtn(index, -1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(it.quantity.toString()),
                  ),
                  _qtyBtn(index, 1),
                  const SizedBox(width: 8),
                  Text('\$${it.totalPrice.toStringAsFixed(2)}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _qtyBtn(int index, int delta) {
    return InkWell(
      onTap: () {
        final current = cart.cartItems[index].quantity;
        cart.updateQuantity(index, current + delta);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.brown.shade200,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(delta > 0 ? Icons.add : Icons.remove, size: 18),
      ),
    );
  }

  Widget _buildPromoSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Promo Code',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: promoController,
                  decoration: InputDecoration(
                    hintText: 'Enter code',
                    errorText: promoError,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _applyPromo,
                child: const Text('Apply'),
              ),
            ],
          ),
          if (appliedPromoCode != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: Colors.green.shade600,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'Applied $appliedPromoCode (-\$${promoDiscount.toStringAsFixed(2)})',
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 18),
                  onPressed: () {
                    setState(() {
                      appliedPromoCode = null;
                      promoDiscount = 0;
                    });
                  },
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          _summaryRow('Subtotal', subtotal),
          if (promoDiscount > 0)
            _summaryRow('Promo Discount', -promoDiscount, highlight: true),
          _summaryRow('Delivery', deliveryFee),
          _summaryRow('Service Fee', serviceFee),
          const Divider(height: 24),
          _summaryRow('Total', total, bold: true),
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard() {
    return InkWell(
      onTap: _changePayment,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: _cardDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.payment),
                const SizedBox(width: 8),
                Text(paymentMethod),
              ],
            ),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceOrderBar() {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton.icon(
              onPressed: placing ? null : _placeOrder,
              icon: placing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.check),
              label: Text(placing ? 'Placing...' : 'Place Order'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.04),
        blurRadius: 4,
        offset: const Offset(0, 4),
      ),
    ],
  );

  Widget _summaryRow(
    String label,
    double value, {
    bool highlight = false,
    bool bold = false,
  }) {
    final color = highlight ? Colors.green : Colors.black;
    final style = TextStyle(
      fontSize: 14,
      fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
      color: color,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(
            '${value < 0 ? '-' : ''}\$${value.abs().toStringAsFixed(2)}',
            style: style,
          ),
        ],
      ),
    );
  }
}
