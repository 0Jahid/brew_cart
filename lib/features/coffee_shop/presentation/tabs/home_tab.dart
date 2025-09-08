import 'package:flutter/material.dart';
import '../../../../shared/widgets/categories_section.dart';
import '../../../../shared/widgets/coffee_card.dart';
import '../../../coffee_details/presentation/pages/coffee_details_page.dart';
import '../../../custom_orders/presentation/pages/custom_orders_page.dart';
import '../../../../shared/widgets/popular_coffee_item.dart';
import '../../../../core/models/coffee.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final coffeeService = CoffeeService();
    return StreamBuilder<List<Coffee>>(
      stream: coffeeService.streamCoffees(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
            child: Text('Error loading coffees: ${snapshot.error}'),
          );
        }
        final coffees = snapshot.data ?? [];
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              const CategoriesSection(),
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: coffees.isEmpty
                    ? const Text('No coffees available right now')
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: coffees.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 0.72,
                            ),
                        itemBuilder: (context, index) {
                          final coffee = coffees[index];
                          final displayPrice = coffee.firstPrice() ?? 0;
                          final sizeLabel = coffee.firstSizeLabel() ?? '';
                          return CoffeeCard(
                            name: coffee.name,
                            size: sizeLabel,
                            price: displayPrice,
                            rating: coffee.rating,
                            imageUrl: coffee.thumbnailUrl,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CoffeeDetailsPage(
                                    coffeeId: coffee.id,
                                    coffeeName: coffee.name,
                                    coffeePrice:
                                        '৳${displayPrice.toStringAsFixed(0)}',
                                    coffeeSize: sizeLabel,
                                    rating: coffee.rating,
                                    reviews: coffee.reviewCount,
                                  ),
                                ),
                              );
                            },
                            onAddPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomOrdersPage(
                                    coffeeId: coffee.id,
                                    coffeeName: coffee.name,
                                    coffeePrice:
                                        '৳${displayPrice.toStringAsFixed(0)}',
                                    rating: coffee.rating,
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
              const SizedBox(height: 32),
              const _PopularSection(),
              const SizedBox(height: 100),
            ],
          ),
        );
      },
    );
  }
}

class _PopularSection extends StatelessWidget {
  const _PopularSection();
  @override
  Widget build(BuildContext context) {
    return Padding(
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
                child: const Icon(Icons.menu, color: Colors.white, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PopularCoffeeItem(
            name: 'Mocha Cappuccino',
            size: '160 ml',
            price: 5.20,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CoffeeDetailsPage(
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
                  builder: (context) => const CustomOrdersPage(
                    coffeeId: 'mocha_cappuccino',
                    coffeeName: 'Mocha Cappuccino',
                    coffeePrice: '\$5.20',
                    rating: 4.8,
                  ),
                ),
              );
            },
            onRemovePressed: () {},
          ),
          PopularCoffeeItem(
            name: 'Cappuccino Latte',
            size: '160 ml',
            price: 5.20,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CoffeeDetailsPage(
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
                  builder: (context) => const CustomOrdersPage(
                    coffeeId: 'cappuccino_latte',
                    coffeeName: 'Cappuccino Latte',
                    coffeePrice: '\$5.20',
                    rating: 4.7,
                  ),
                ),
              );
            },
            onRemovePressed: () {},
          ),
        ],
      ),
    );
  }
}
