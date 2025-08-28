import 'package:flutter/material.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../shared/widgets/custom_app_bar.dart';

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
    return const SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          SearchBar(
            hintText: AppStrings.searchCoffee,
            leading: Icon(Icons.search),
          ),
          SizedBox(height: 24),

          // Featured Section
          Text(
            AppStrings.featured,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),

          // Placeholder for featured items
          SizedBox(
            height: 200,
            child: Center(
              child: Text(
                'Featured coffee items will be displayed here',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),

          SizedBox(height: 24),

          // Categories Section
          Text(
            AppStrings.categories,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          SizedBox(height: 16),

          // Placeholder for categories
          SizedBox(
            height: 100,
            child: Center(
              child: Text(
                'Coffee categories will be displayed here',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
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
