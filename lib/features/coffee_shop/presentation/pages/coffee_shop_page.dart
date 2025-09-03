import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/coffee_card.dart';
import '../../../../shared/widgets/popular_coffee_item.dart';
import '../../../../shared/widgets/categories_section.dart';
import '../../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../../coffee_details/presentation/pages/coffee_details_page.dart';
import '../../../custom_orders/presentation/pages/custom_orders_page.dart';
import '../../../checkout/presentation/pages/checkout_page.dart';
import '../../../../core/models/order_item.dart';

class CoffeeShopPage extends StatefulWidget {
  const CoffeeShopPage({super.key});

  @override
  State<CoffeeShopPage> createState() => _CoffeeShopPageState();
}

class _CoffeeShopPageState extends State<CoffeeShopPage> {
  int _selectedIndex = 0;

  // Order page state variables
  String _selectedAddress = 'Jl. Kepang Ranju';
  String _addressDetails = 'Oceanview Terrace, Pasuruan, Jawa Timur';
  String _promoCode = '';
  String _selectedPaymentMethod = 'Cash';
  bool _hasPromo = false;

  Widget _buildBody() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomePage();
      case 1:
        return _buildCartPage();
      case 2:
        return _buildOrdersPage();
      case 3:
        return _buildProfilePage();
      default:
        return _buildHomePage();
    }
  }

  Widget _buildHomePage() {
    return Container(
      color: Colors.grey[100], // Light gray background
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),

            // Categories Section
            const CategoriesSection(),

            const SizedBox(height: 24),

            // Coffee Grid Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: 4, // Show 4 coffee cards initially
                itemBuilder: (context, index) {
                  // Different coffee varieties
                  final coffeeTypes = [
                    {'name': 'Cappuccino', 'price': 5.20, 'rating': 4.9},
                    {'name': 'Latte', 'price': 4.80, 'rating': 4.7},
                    {'name': 'Americano', 'price': 3.90, 'rating': 4.5},
                    {'name': 'Espresso', 'price': 3.50, 'rating': 4.8},
                  ];

                  final coffee = coffeeTypes[index];

                  return CoffeeCard(
                    name: coffee['name'] as String,
                    size: '160 ml',
                    price: coffee['price'] as double,
                    rating: coffee['rating'] as double,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoffeeDetailsPage(
                            coffeeId: 'coffee_$index',
                            coffeeName: coffee['name'] as String,
                            coffeePrice:
                                '\$${(coffee['price'] as double).toStringAsFixed(2)}',
                            coffeeSize: '160 ml',
                            rating: coffee['rating'] as double,
                            reviews: 2453,
                          ),
                        ),
                      );
                    },
                    onAddPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomOrdersPage(
                            coffeeId: 'coffee_$index',
                            coffeeName: coffee['name'] as String,
                            coffeePrice:
                                '\$${(coffee['price'] as double).toStringAsFixed(2)}',
                            rating: coffee['rating'] as double,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 32),

            // Popular Now Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Popular Now',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.brown[400],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Popular Coffee Items
                  PopularCoffeeItem(
                    name: 'Mocha Cappuccino',
                    size: '160 ml',
                    price: 5.20,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoffeeDetailsPage(
                            coffeeId: 'mocha_cappuccino',
                            coffeeName: 'Mocha Cappuccino',
                            coffeePrice: '\$5.20',
                            coffeeSize: '160 ml',
                            rating: 4.8,
                            reviews: 1876,
                          ),
                        ),
                      );
                    },
                    onAddPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomOrdersPage(
                            coffeeId: 'mocha_cappuccino',
                            coffeeName: 'Mocha Cappuccino',
                            coffeePrice: '\$5.20',
                            rating: 4.8,
                          ),
                        ),
                      );
                    },
                    onRemovePressed: () {
                      // TODO: Handle remove from cart
                    },
                  ),
                  PopularCoffeeItem(
                    name: 'Cappuccino Latte',
                    size: '160 ml',
                    price: 5.20,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoffeeDetailsPage(
                            coffeeId: 'cappuccino_latte',
                            coffeeName: 'Cappuccino Latte',
                            coffeePrice: '\$5.20',
                            coffeeSize: '160 ml',
                            rating: 4.7,
                            reviews: 2134,
                          ),
                        ),
                      );
                    },
                    onAddPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomOrdersPage(
                            coffeeId: 'cappuccino_latte',
                            coffeeName: 'Cappuccino Latte',
                            coffeePrice: '\$5.20',
                            rating: 4.7,
                          ),
                        ),
                      );
                    },
                    onRemovePressed: () {
                      // TODO: Handle remove from cart
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 100,
            ), // Extra bottom padding for navigation bar
          ],
        ),
      ),
    );
  }

  Widget _buildCartPage() {
    final cartItems = CartManager().cartItems;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () {
            setState(() {
              _selectedIndex = 0; // Go back to home
            });
          },
        ),
        title: Text(
          'Cart (${CartManager().itemCount})',
          style: const TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Add some coffee to get started!',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Coffee Image
                            Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.coffee,
                                color: Colors.grey,
                                size: 30,
                              ),
                            ),

                            const SizedBox(width: 16),

                            // Coffee Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${item.coffeeName} x${item.quantity}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${item.size}, ${item.sugar}, ${item.ice}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    item.formattedTotalPrice,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Remove Button
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  CartManager().removeItem(index);
                                });
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Cart Summary
                if (cartItems.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              CartManager().formattedTotalPrice,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: () {
                              if (CartManager().cartItems.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Your cart is empty!'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                                return;
                              }

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CheckoutPage(),
                                ),
                              ).then((_) {
                                // Refresh cart when returning from checkout
                                setState(() {});
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF8B4513),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              'Checkout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
    );
  }

  Widget _buildOrdersPage() {
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
                    onTap: () {
                      setState(() {
                        _selectedIndex = 0; // Go back to home
                      });
                    },
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
                      _buildOrderAddressSection(),

                      const SizedBox(height: 24),

                      // Order Details Section
                      _buildOrderDetailsSection(),

                      const SizedBox(height: 16),

                      // Promo Section
                      _buildOrderPromoSection(),

                      const SizedBox(height: 16),

                      // Payment Summary Section
                      _buildOrderPaymentSummarySection(),

                      const SizedBox(height: 16),

                      // Payment Method Section
                      _buildOrderPaymentMethodSection(),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),

            // Pay Now Button (Fixed at bottom)
            Padding(
              padding: const EdgeInsets.all(30),
              child: _buildOrderPayNowButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Address Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _selectedAddress,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1C1310),
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _addressDetails,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFFB9B9B9),
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: _showEditAddressDialog,
              child: Container(
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
            ),
          ],
        ),

        const SizedBox(height: 20),

        // Add Address Details Button
        GestureDetector(
          onTap: _showAddAddressDialog,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFDDDDDD), width: 1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16,
                  color: Colors.black54,
                ),
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
        ),
      ],
    );
  }

  Widget _buildOrderDetailsSection() {
    final cartItems = CartManager().cartItems;
    final hasItems = cartItems.isNotEmpty;

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
              Expanded(
                child: Text(
                  'Details Items',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
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

          // Order Details - Show all cart items
          if (hasItems) ...[
            ...cartItems.map((item) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Details Column
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.coffeeName,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(height: 8),
                        _buildOrderDetailRow('Size', item.size),
                        const SizedBox(height: 4),
                        _buildOrderDetailRow('Sugar', item.sugar),
                        const SizedBox(height: 4),
                        _buildOrderDetailRow('Ice', item.ice),
                        const SizedBox(height: 4),
                        _buildOrderDetailRow('Quantity', '${item.quantity}'),
                      ],
                    ),
                  ),

                  const SizedBox(width: 20),

                  // Coffee Image
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9D9D9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.coffee, size: 30, color: Colors.grey),
                  ),
                ],
              ),
            )),
          ] else ...[
            // Empty cart placeholder
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'No items in cart',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      const SizedBox(height: 8),
                      _buildOrderDetailRow('Size', 'Regular'),
                      const SizedBox(height: 4),
                      _buildOrderDetailRow('Sugar', 'Normal'),
                      const SizedBox(height: 4),
                      _buildOrderDetailRow('Ice', 'No Ice'),
                      const SizedBox(height: 4),
                      _buildOrderDetailRow('Quantity', '1'),
                    ],
                  ),
                ),

                const SizedBox(width: 20),

                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.coffee, size: 30, color: Colors.grey),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderDetailRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
        const Text(
          ':',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontFamily: 'Montserrat',
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
              fontFamily: 'Montserrat',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderPromoSection() {
    return GestureDetector(
      onTap: _showPromoDialog,
      child: Container(
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
                Text(
                  _hasPromo ? 'Promo: $_promoCode' : 'Place your promo',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: _hasPromo ? Colors.black : const Color(0xFF9B9B9B),
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
            const Icon(Icons.chevron_right, size: 20, color: Color(0xFF9B9B9B)),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderPaymentSummarySection() {
    final subtotal = CartManager().totalPrice;
    const shippingCost = 2.00;
    const adminFee = 1.00;
    final total = subtotal + shippingCost + adminFee;

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
          _buildOrderSummaryRow('Price', '\$${subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          _buildOrderSummaryRow(
            'Shipping Cost',
            '\$${shippingCost.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 8),
          _buildOrderSummaryRow(
            'Admin Fee',
            '\$${adminFee.toStringAsFixed(0)}',
          ),

          // Show promo discount if applied
          if (_hasPromo) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Promo Discount',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const Text(
                  '-\$1.00',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.green,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ],
            ),
          ],

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
                '\$${(_hasPromo ? total - 1.00 : total).toStringAsFixed(2)}',
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

  Widget _buildOrderSummaryRow(String label, String amount) {
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

  Widget _buildOrderPaymentMethodSection() {
    return GestureDetector(
      onTap: _showPaymentMethodDialog,
      child: Container(
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
                Text(
                  'Payment Method: $_selectedPaymentMethod',
                  style: const TextStyle(
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
      ),
    );
  }

  Widget _buildOrderPayNowButton() {
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
            _showOrderConfirmationDialog();
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

  void _showOrderConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: Color(0xFFC67C4E), size: 28),
              SizedBox(width: 8),
              Text('Order Placed!'),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your order has been successfully placed.'),
              SizedBox(height: 8),
              Text(
                'Total: \$8.20',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC67C4E),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Order ID: ORD2025090301',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                setState(() {
                  _selectedIndex = 0; // Go back to home
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Order placed successfully!'),
                    backgroundColor: Color(0xFFC67C4E),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              child: const Text(
                'Continue Shopping',
                style: TextStyle(color: Color(0xFFC67C4E)),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
                setState(() {
                  _selectedIndex = 0; // Go back to home
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Order placed! Check your orders for tracking.',
                    ),
                    backgroundColor: Color(0xFFC67C4E),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC67C4E),
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

  // Interactive dialog methods for the orders page
  void _showEditAddressDialog() {
    final addressController = TextEditingController(text: _selectedAddress);
    final detailsController = TextEditingController(text: _addressDetails);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Address'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'Address',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: detailsController,
                decoration: const InputDecoration(
                  labelText: 'Details',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedAddress = addressController.text;
                  _addressDetails = detailsController.text;
                });
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC67C4E),
              ),
              child: const Text('Save', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAddAddressDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Address Details'),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: 'Apartment/Floor',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Delivery Instructions',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Address details added!'),
                    backgroundColor: Color(0xFFC67C4E),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC67C4E),
              ),
              child: const Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showPromoDialog() {
    final promoController = TextEditingController(text: _promoCode);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Promo Code'),
          content: TextField(
            controller: promoController,
            decoration: const InputDecoration(
              labelText: 'Promo Code',
              border: OutlineInputBorder(),
              hintText: 'Enter your promo code',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (promoController.text.isNotEmpty) {
                  setState(() {
                    _promoCode = promoController.text;
                    _hasPromo = true;
                  });
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Promo code "$_promoCode" applied!'),
                      backgroundColor: const Color(0xFFC67C4E),
                    ),
                  );
                } else {
                  setState(() {
                    _hasPromo = false;
                    _promoCode = '';
                  });
                  Navigator.of(context).pop();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC67C4E),
              ),
              child: const Text('Apply', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showPaymentMethodDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Payment Method'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPaymentOption('Cash', Icons.money),
              _buildPaymentOption('Credit Card', Icons.credit_card),
              _buildPaymentOption(
                'Digital Wallet',
                Icons.account_balance_wallet,
              ),
              _buildPaymentOption('Bank Transfer', Icons.account_balance),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPaymentOption(String method, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFFC67C4E)),
      title: Text(method),
      trailing: _selectedPaymentMethod == method
          ? const Icon(Icons.check, color: Color(0xFFC67C4E))
          : null,
      onTap: () {
        setState(() {
          _selectedPaymentMethod = method;
        });
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment method set to: $method'),
            backgroundColor: const Color(0xFFC67C4E),
          ),
        );
      },
    );
  }

  Widget _buildProfilePage() {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () {
            setState(() {
              _selectedIndex = 0; // Go back to home
            });
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
            fontFamily: 'Montserrat',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Profile Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  // Profile Picture
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF8B4513), Color(0xFFA0522D)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF8B4513).withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // User Name
                  const Text(
                    'Jahid Rahman',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Email
                  Text(
                    'jahid@brew-cart.com',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                      fontFamily: 'Montserrat',
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Stats Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildStatItem('Orders', '24'),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.grey[300],
                      ),
                      _buildStatItem('Points', '1,200'),
                      Container(
                        height: 40,
                        width: 1,
                        color: Colors.grey[300],
                      ),
                      _buildStatItem('Rewards', '3'),
                    ],
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Membership Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF8B4513), Color(0xFFA0522D)],
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF8B4513).withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.local_cafe,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Gold Member',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        Text(
                          '5% discount on all orders',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Menu Options
            _buildMenuSection([
              _buildMenuTile(
                icon: Icons.person_outline,
                title: 'Edit Profile',
                subtitle: 'Update your personal information',
                onTap: () => _showEditProfileDialog(context),
              ),
              _buildMenuTile(
                icon: Icons.location_on_outlined,
                title: 'Delivery Address',
                subtitle: 'Manage your addresses',
                onTap: () => _showAddressDialog(context),
              ),
              _buildMenuTile(
                icon: Icons.payment_outlined,
                title: 'Payment Methods',
                subtitle: 'Manage payment options',
                onTap: () => _showPaymentDialog(context),
              ),
              _buildMenuTile(
                icon: Icons.history,
                title: 'Order History',
                subtitle: 'View your past orders',
                onTap: () => _showOrderHistory(context),
              ),
            ]),
            
            const SizedBox(height: 24),
            
            _buildMenuSection([
              _buildMenuTile(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () => _showNotificationSettings(context),
              ),
              _buildMenuTile(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help with your orders',
                onTap: () => _showHelpDialog(context),
              ),
              _buildMenuTile(
                icon: Icons.info_outline,
                title: 'About',
                subtitle: 'App version and information',
                onTap: () => _showAboutDialog(context),
              ),
            ]),
            
            const SizedBox(height: 24),
            
            // Logout Button
            Container(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[50],
                  foregroundColor: Colors.red[600],
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.red[200]!),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text(
                  'Logout',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF8B4513),
            fontFamily: 'Montserrat',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: items,
      ),
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          color: const Color(0xFF8B4513).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: const Color(0xFF8B4513),
          size: 24,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
          fontFamily: 'Montserrat',
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[600],
          fontFamily: 'Montserrat',
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
    );
  }

  // Dialog Methods
  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: 'Jahid Rahman'),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: 'jahid@brew-cart.com'),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Phone',
                border: OutlineInputBorder(),
              ),
              controller: TextEditingController(text: '+880 1234 567890'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile updated successfully!'),
                  backgroundColor: Color(0xFF8B4513),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF8B4513)),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAddressDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Delivery Addresses',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.home, color: Color(0xFF8B4513)),
              title: const Text('Home'),
              subtitle: const Text('Jl. Kepang Ranju, Pasuruan, Jawa Timur'),
              trailing: const Icon(Icons.edit),
            ),
            ListTile(
              leading: const Icon(Icons.work, color: Color(0xFF8B4513)),
              title: const Text('Office'),
              subtitle: const Text('Dhaka Tech Park, Dhaka, Bangladesh'),
              trailing: const Icon(Icons.edit),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.add, color: Color(0xFF8B4513)),
              title: const Text('Add New Address'),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Payment Methods',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.credit_card, color: Color(0xFF8B4513)),
              title: const Text('Credit Card'),
              subtitle: const Text('**** **** **** 1234'),
              trailing: const Icon(Icons.edit),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Color(0xFF8B4513)),
              title: const Text('E-Wallet'),
              subtitle: const Text('Connected'),
              trailing: const Icon(Icons.edit),
            ),
            ListTile(
              leading: const Icon(Icons.money, color: Color(0xFF8B4513)),
              title: const Text('Cash on Delivery'),
              subtitle: const Text('Available'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showOrderHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Order History',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        content: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.local_cafe, color: Color(0xFF8B4513)),
                title: const Text('Cappuccino x2'),
                subtitle: const Text('Dec 2, 2024 - \$10.40'),
                trailing: const Text('Delivered', style: TextStyle(color: Colors.green)),
              ),
              ListTile(
                leading: const Icon(Icons.local_cafe, color: Color(0xFF8B4513)),
                title: const Text('Latte x1'),
                subtitle: const Text('Dec 1, 2024 - \$4.80'),
                trailing: const Text('Delivered', style: TextStyle(color: Colors.green)),
              ),
              ListTile(
                leading: const Icon(Icons.local_cafe, color: Color(0xFF8B4513)),
                title: const Text('Americano x3'),
                subtitle: const Text('Nov 30, 2024 - \$11.70'),
                trailing: const Text('Delivered', style: TextStyle(color: Colors.green)),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showNotificationSettings(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Notification Settings',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SwitchListTile(
              title: const Text('Order Updates'),
              subtitle: const Text('Get notified about order status'),
              value: true,
              activeColor: const Color(0xFF8B4513),
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('Promotions'),
              subtitle: const Text('Receive promotional offers'),
              value: false,
              activeColor: const Color(0xFF8B4513),
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text('New Menu Items'),
              subtitle: const Text('Be first to know about new items'),
              value: true,
              activeColor: const Color(0xFF8B4513),
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Help & Support',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.phone, color: Color(0xFF8B4513)),
              title: const Text('Call Support'),
              subtitle: const Text('+880 1234 567890'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.email, color: Color(0xFF8B4513)),
              title: const Text('Email Support'),
              subtitle: const Text('support@brew-cart.com'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.chat, color: Color(0xFF8B4513)),
              title: const Text('Live Chat'),
              subtitle: const Text('Chat with our support team'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Color(0xFF8B4513)),
              title: const Text('FAQ'),
              subtitle: const Text('Frequently asked questions'),
              onTap: () {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'About Brew Cart',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Version: 1.0.0',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 8),
            Text(
              'Build: 100',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 16),
            Text(
              'Brew Cart is your premium coffee delivery app. We bring the finest coffee experience right to your doorstep.',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Text(
              '© 2024 Brew Cart. All rights reserved.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Logout',
          style: TextStyle(fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
        ),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Logged out successfully!'),
                  backgroundColor: Color(0xFF8B4513),
                ),
              );
              // TODO: Implement actual logout logic
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _selectedIndex == 0
          ? CustomAppBar(
              userName: 'Jahid',
              location: 'Dhaka, Bangladesh',
              onNotificationPressed: () {
                // TODO: Handle notification press
              },
              onLocationPressed: () {
                // TODO: Handle location press
              },
            )
          : null,
      body: _buildBody(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        cartItemCount: CartManager().itemCount,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      extendBody: true,
    );
  }
}
