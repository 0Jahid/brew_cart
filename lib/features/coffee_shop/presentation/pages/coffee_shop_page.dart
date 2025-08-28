import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/coffee_card.dart';
import '../../../../shared/widgets/popular_coffee_item.dart';
import '../../../../shared/widgets/categories_section.dart';

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
        return _buildMenuPage();
      case 2:
        return _buildCartPage();
      case 3:
        return _buildOrdersPage();
      case 4:
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
                  return CoffeeCard(
                    name: 'Cappuccino',
                    size: '160 ml',
                    price: 5.20,
                    rating: 4.9,
                    onAddPressed: () {
                      // TODO: Handle add to cart
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
                    onAddPressed: () {
                      // TODO: Handle add to cart
                    },
                    onRemovePressed: () {
                      // TODO: Handle remove from cart
                    },
                  ),
                  PopularCoffeeItem(
                    name: 'Cappuccino Latte',
                    size: '160 ml',
                    price: 5.20,
                    onAddPressed: () {
                      // TODO: Handle add to cart
                    },
                    onRemovePressed: () {
                      // TODO: Handle remove from cart
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Extra bottom padding for navigation bar
          ],
        ),
      ),
    );
  }

  Widget _buildMenuPage() {
    return const Center(
      child: Text(
        'Menu Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildCartPage() {
    return const Center(
      child: Text(
        'Cart Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOrdersPage() {
    return const Center(
      child: Text(
        'Orders Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildProfilePage() {
    return const Center(
      child: Text(
        'Profile Page',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        userName: 'Jahid',
        location: 'Dhaka, Bangladesh',
        onNotificationPressed: () {
          // TODO: Handle notification press
        },
        onLocationPressed: () {
          // TODO: Handle location press
        },
      ),
      body: _buildBody(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: AppStrings.home,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.coffee_outlined),
            activeIcon: Icon(Icons.coffee),
            label: AppStrings.menu,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart_outlined),
            activeIcon: Icon(Icons.shopping_cart),
            label: AppStrings.cart,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long_outlined),
            activeIcon: Icon(Icons.receipt_long),
            label: AppStrings.orders,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: AppStrings.profile,
          ),
        ],
      ),
    );
  }
}
