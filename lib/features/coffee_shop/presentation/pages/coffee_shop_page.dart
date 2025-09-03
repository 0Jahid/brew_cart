import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/coffee_card.dart';
import '../../../../shared/widgets/popular_coffee_item.dart';
import '../../../../shared/widgets/categories_section.dart';
import '../../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../../../coffee_details/presentation/pages/coffee_details_page.dart';
import '../../../custom_orders/presentation/pages/custom_orders_page.dart';
import '../../../../core/models/order_item.dart';

class CoffeeShopPage extends StatefulWidget {
  const CoffeeShopPage({super.key});

  @override
  State<CoffeeShopPage> createState() => _CoffeeShopPageState();
}

class _CoffeeShopPageState extends State<CoffeeShopPage> {
  int _selectedIndex = 0;

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
                            coffeePrice: '\$${(coffee['price'] as double).toStringAsFixed(2)}',
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
                            coffeePrice: '\$${(coffee['price'] as double).toStringAsFixed(2)}',
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
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
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
                              child: const Icon(Icons.coffee, color: Colors.grey, size: 30),
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Checkout feature coming soon!'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
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
          'Orders',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Orders Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
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
          ),
        ),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Profile Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
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
