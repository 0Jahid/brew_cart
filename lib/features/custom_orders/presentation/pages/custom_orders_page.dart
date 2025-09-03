import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/order_item.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';

class CustomOrdersPage extends StatefulWidget {
  final String coffeeId;
  final String? coffeeName;
  final String? coffeePrice;
  final double? rating;

  const CustomOrdersPage({
    super.key,
    required this.coffeeId,
    this.coffeeName,
    this.coffeePrice,
    this.rating,
  });

  @override
  State<CustomOrdersPage> createState() => _CustomOrdersPageState();
}

class _CustomOrdersPageState extends State<CustomOrdersPage> {
  String selectedSize = 'Regular';
  String selectedSugar = 'Normal Sugar';
  String selectedIce = 'No Ice';
  int quantity = 1;

  final List<String> sizeOptions = ['Small', 'Regular', 'Large'];
  final List<String> sugarOptions = ['Normal Sugar', 'Less Sugar', 'No Sugar'];
  final List<String> iceOptions = ['Normal Ice', 'Less Ice', 'No Ice'];

  @override
  Widget build(BuildContext context) {
    final coffeeName = widget.coffeeName ?? 'Cappuccino';
    final coffeePrice = widget.coffeePrice ?? '\$5.20';

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black87,
              size: 18,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        centerTitle: true,
        title: const Text(
          'Custom orders',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              // Coffee Item Header
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 15,
                ),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.coffee,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Text(
                          coffeeName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1C1310),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      coffeePrice,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // Size Selection
              _buildSelectionSection(
                'Size',
                sizeOptions,
                selectedSize,
                (value) => setState(() => selectedSize = value),
              ),

              const SizedBox(height: 22),

              // Sugar Selection
              _buildSelectionSection(
                'Sugar',
                sugarOptions,
                selectedSugar,
                (value) => setState(() => selectedSugar = value),
              ),

              const SizedBox(height: 22),

              // Ice Selection
              _buildSelectionSection(
                'Ice',
                iceOptions,
                selectedIce,
                (value) => setState(() => selectedIce = value),
              ),

              const SizedBox(height: 37),

              // Quantity and Add Order
              Row(
                children: [
                  // Quantity Controls
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (quantity > 1) {
                              setState(() => quantity--);
                            }
                          },
                          child: Container(
                            width: 29,
                            height: 28,
                            decoration: BoxDecoration(
                              color: quantity > 1
                                  ? AppColors.primary
                                  : Colors.grey[400],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),

                        const SizedBox(width: 19),

                        Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),

                        const SizedBox(width: 19),

                        GestureDetector(
                          onTap: () {
                            setState(() => quantity++);
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Add Order Button
                  Expanded(
                    child: Container(
                      height: 69,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary,
                            AppColors.primary.withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(46),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            _showOrderConfirmation();
                          },
                          borderRadius: BorderRadius.circular(46),
                          child: const Center(
                            child: Text(
                              'Add Order',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectionSection(
    String title,
    List<String> options,
    String selectedValue,
    Function(String) onChanged,
  ) {
    return Container(
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
        children: [
          // Section Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFB9B9B9),
                ),
              ),
              Text(
                'Mandatory Select one',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 23),

          // Options
          Column(
            children: options.asMap().entries.map((entry) {
              final index = entry.key;
              final option = entry.value;
              final isSelected = option == selectedValue;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        option,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => onChanged(option),
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Colors.grey[400]!,
                              width: 2,
                            ),
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.circle,
                                  color: Colors.white,
                                  size: 8,
                                )
                              : null,
                        ),
                      ),
                    ],
                  ),
                  if (index < options.length - 1) ...[
                    const SizedBox(height: 14),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey[200],
                    ),
                    const SizedBox(height: 14),
                  ],
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  void _showOrderConfirmation() {
    // Create order item
    final orderItem = OrderItem(
      coffeeId: widget.coffeeId,
      coffeeName: widget.coffeeName ?? 'Cappuccino',
      coffeePrice: widget.coffeePrice ?? '\$5.20',
      size: selectedSize,
      sugar: selectedSugar,
      ice: selectedIce,
      quantity: quantity,
      rating: widget.rating,
    );

    // Add to cart
    CartManager().addItem(orderItem);

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
              const Text('Order Added!'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${widget.coffeeName ?? "Cappuccino"} x$quantity'),
              const SizedBox(height: 4),
              Text('Size: $selectedSize'),
              Text('Sugar: $selectedSugar'),
              Text('Ice: $selectedIce'),
              const SizedBox(height: 8),
              Text(
                'Total: ${orderItem.formattedTotalPrice}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Cart Total: ${CartManager().formattedTotalPrice} (${CartManager().itemCount} items)',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to details page
              },
              child: Text(
                'Continue Shopping',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Go back to details page
                // Show cart summary
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Added to cart! Cart has ${CartManager().itemCount} items',
                    ),
                    backgroundColor: AppColors.primary,
                    behavior: SnackBarBehavior.floating,
                    action: SnackBarAction(
                      label: 'View Cart',
                      textColor: Colors.white,
                      onPressed: () {
                        _showCartSummary();
                      },
                    ),
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
              child: const Text('View Cart'),
            ),
          ],
        );
      },
    );
  }

  void _showCartSummary() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final cartItems = CartManager().cartItems;
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Text('Cart Summary (${CartManager().itemCount} items)'),
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (cartItems.isEmpty)
                  const Text('Your cart is empty')
                else
                  ...cartItems.asMap().entries.map((entry) {
                    final index = entry.key;
                    final item = entry.value;
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${item.coffeeName} x${item.quantity}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${item.size}, ${item.sugar}, ${item.ice}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                Text(
                                  item.formattedTotalPrice,
                                  style: TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              CartManager().removeItem(index);
                              Navigator.of(context).pop();
                              _showCartSummary(); // Refresh dialog
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        CartManager().formattedTotalPrice,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close', style: TextStyle(color: AppColors.primary)),
            ),
            ElevatedButton(
              onPressed: cartItems.isEmpty
                  ? null
                  : () {
                      Navigator.of(context).pop(); // Close dialog
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CheckoutPage(),
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
              child: const Text('Checkout'),
            ),
          ],
        );
      },
    );
  }
}
