import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/order_item.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    final cartItems = CartManager().cartItems;
    final subtotal = CartManager().totalPrice;
    const shippingCost = 2.00;
    const adminFee = 1.00;
    final total = subtotal + shippingCost + adminFee;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.black,
                        size: 20,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Text(
                      'Orders',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(width: 36), // Balance the back button
                ],
              ),
            ),

            // Scrollable Content
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),

                      // Address Section
                      _buildAddressSection(),

                      const SizedBox(height: 24),

                      // Detail Cappuccino Section
                      _buildOrderDetailsSection(cartItems),

                      const SizedBox(height: 16),

                      // Promo Section
                      _buildPromoSection(),

                      const SizedBox(height: 16),

                      // Payment Summary Section
                      _buildPaymentSummarySection(
                        subtotal,
                        shippingCost,
                        adminFee,
                        total,
                      ),

                      const SizedBox(height: 16),

                      // Payment Method Section
                      _buildPaymentMethodSection(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),

            // Pay Now Button (Fixed at bottom)
            Padding(
              padding: const EdgeInsets.all(30),
              child: _buildPayNowButton(total),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Jl. Kepang Ranju',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1310),
                    fontFamily: 'Montserrat',
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Oceanview Terrace, Pasuruan, Jawa Timur',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFB9B9B9),
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: const Color(0xFFC67C4E),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.edit_outlined,
                color: Colors.white,
                size: 16,
              ),
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Add Address Details Button
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
            borderRadius: BorderRadius.circular(100),
          ),
          child: const Row(
            children: [
              Icon(Icons.location_on_outlined, size: 16, color: Colors.black54),
              SizedBox(width: 10),
              Text(
                'Add Address details',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Colors.black54,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildOrderDetailsSection(List<OrderItem> cartItems) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Detail Cappuccino',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFC67C4E)),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const Text(
                  'Edit',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFFC67C4E),
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Order Details
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Details Column
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (cartItems.isNotEmpty) ...[
                      _buildDetailRow('Size', cartItems.first.size),
                      const SizedBox(height: 4),
                      _buildDetailRow('Sugar', cartItems.first.sugar),
                      const SizedBox(height: 4),
                      _buildDetailRow('Ice', cartItems.first.ice),
                      const SizedBox(height: 4),
                      _buildDetailRow('Topping', 'No'),
                    ] else ...[
                      _buildDetailRow('Size', 'Regular'),
                      const SizedBox(height: 4),
                      _buildDetailRow('Sugar', 'Normal'),
                      const SizedBox(height: 4),
                      _buildDetailRow('Ice', 'No Ice'),
                      const SizedBox(height: 4),
                      _buildDetailRow('Topping', 'No'),
                    ],
                  ],
                ),
              ),

              const SizedBox(width: 20),

              // Coffee Image
              Container(
                width: 87,
                height: 85,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.coffee, size: 40, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        SizedBox(
          width: 60,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFFB9B9B9),
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        const SizedBox(width: 25),
        const Text(
          ':',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFFB9B9B9),
            fontFamily: 'Montserrat',
          ),
        ),
        const SizedBox(width: 30),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  Widget _buildPromoSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFC67C4E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.local_offer,
                  size: 12,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Place your promo',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF9B9B9B),
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
          const Icon(Icons.chevron_right, size: 20, color: Color(0xFF9B9B9B)),
        ],
      ),
    );
  }

  Widget _buildPaymentSummarySection(
    double subtotal,
    double shippingCost,
    double adminFee,
    double total,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Payment Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
              fontFamily: 'Montserrat',
            ),
          ),

          const SizedBox(height: 16),

          // Price breakdown
          _buildSummaryRow('Price', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildSummaryRow(
            'Shipping Cost',
            '\$${shippingCost.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          _buildSummaryRow('Admin Fee', '\$${adminFee.toStringAsFixed(0)}'),

          const SizedBox(height: 16),

          // Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Payment',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                ),
              ),
              Text(
                '\$${total.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontFamily: 'Montserrat',
          ),
        ),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  color: Color(0xFFC67C4E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.attach_money,
                  size: 14,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Payment Method',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),
          const Icon(
            Icons.keyboard_arrow_down,
            size: 24,
            color: Color(0xFF9B9B9B),
          ),
        ],
      ),
    );
  }

  Widget _buildPayNowButton(double total) {
    return Container(
      width: double.infinity,
      height: 62,
      decoration: BoxDecoration(
        color: const Color(0xFFC67C4E),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            _showOrderConfirmation(total);
          },
          borderRadius: BorderRadius.circular(16),
          child: const Center(
            child: Text(
              'Pay Now',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontFamily: 'Montserrat',
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showOrderConfirmation(double total) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.primary, size: 28),
              const SizedBox(width: 8),
              const Text('Order Placed!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Your order has been successfully placed.'),
              const SizedBox(height: 8),
              Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Order ID: ORD${DateTime.now().millisecondsSinceEpoch}',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to cart
                CartManager().clearCart(); // Clear the cart
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Order placed successfully!'),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: Text(
                'Continue Shopping',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to cart
                CartManager().clearCart(); // Clear the cart
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text(
                      'Order placed! Track your order in the Orders tab.',
                    ),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Track Order'),
            ),
          ],
        );
      },
    );
  }
}
