import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../shared/widgets/categories_section.dart';
import '../../../../shared/widgets/coffee_card.dart';
import '../../../coffee_details/presentation/pages/coffee_details_page.dart';
import '../../../custom_orders/presentation/pages/custom_orders_page.dart';
import '../../../../shared/widgets/popular_coffee_item.dart';
import '../../../../core/models/product.dart';

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});
  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  String? _selectedCategoryId = 'ALL';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          CategoriesSection(
            onCategorySelected: (cat) {
              if (cat.id != _selectedCategoryId) {
                setState(() => _selectedCategoryId = cat.id);
              }
            },
          ),
          const SizedBox(height: 24),
          _CategoryProductsGrid(categoryId: _selectedCategoryId ?? 'ALL'),
          const SizedBox(height: 32),
          const _PopularSection(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _CategoryProductsGrid extends StatelessWidget {
  final String categoryId;
  const _CategoryProductsGrid({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final isAll = categoryId == 'ALL';
    final stream = isAll
        ? FirebaseFirestore.instance
              .collectionGroup('products')
              // no where() to avoid collection group index; filter client-side
              .limit(200)
              .snapshots()
        : FirebaseFirestore.instance
              .collection('categories')
              .doc(categoryId)
              .collection('products')
              .where('isAvailable', isEqualTo: true)
              .snapshots();
    return StreamBuilder<QuerySnapshot>(
      stream: stream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Failed to load products: ${snapshot.error}'),
          );
        }
        final docs = snapshot.data?.docs ?? [];
        final filteredDocs = isAll
            ? docs.where((d) {
                final m = d.data() as Map<String, dynamic>? ?? {};
                return (m['isAvailable'] as bool?) ?? true;
              }).toList()
            : docs;
        final products = isAll
            ? filteredDocs.map(ProductModel.fromGroupDoc).toList()
            : filteredDocs
                  .map((d) => ProductModel.fromDoc(categoryId, d))
                  .toList();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: products.isEmpty
              ? const Text('No products in this category')
              : GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemBuilder: (context, index) {
                    final p = products[index];
                    final price = p.firstPrice();
                    final sizeLabel = p.firstSizeLabel();
                    return CoffeeCard(
                      name: p.name,
                      size: sizeLabel,
                      price: price,
                      rating: p.ratingAverage,
                      imageUrl: p.imageUrl,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CoffeeDetailsPage(
                              coffeeId: p.id,
                              categoryId: p.categoryId,
                              coffeeName: p.name,
                              coffeePrice: '\$${price.toStringAsFixed(2)}',
                              coffeeSize: sizeLabel,
                              rating: p.ratingAverage,
                              reviews: p.ratingCount,
                            ),
                          ),
                        );
                      },
                      onAddPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CustomOrdersPage(
                              coffeeId: p.id,
                              categoryId: p.categoryId,
                              coffeeName: p.name,
                              coffeePrice: '\$${price.toStringAsFixed(2)}',
                              rating: p.ratingAverage,
                            ),
                          ),
                        );
                      },
                    );
                  },
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
    final stream = FirebaseFirestore.instance
        .collectionGroup('products')
        // Avoid orderBy on collectionGroup to prevent index requirement; sort client-side
        .limit(200)
        .snapshots();
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
          StreamBuilder<QuerySnapshot>(
            stream: stream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 160,
                  child: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.hasError) {
                return Text('Failed to load popular: ${snapshot.error}');
              }
              final docs = snapshot.data?.docs ?? [];
              if (docs.isEmpty) {
                return const Text('No popular items yet');
              }
              // map, filter available, sort by popularityIndex desc, and take top 5
              final items =
                  docs
                      .map(ProductModel.fromGroupDoc)
                      .where((p) => p.isAvailable)
                      .toList()
                    ..sort(
                      (a, b) => b.popularityIndex.compareTo(a.popularityIndex),
                    );
              final top5 = items.take(5).toList();
              if (top5.isEmpty) return const Text('No popular items yet');
              return Column(
                children: top5.map((prod) {
                  final price = prod.firstPrice();
                  return PopularCoffeeItem(
                    name: prod.name,
                    size: prod.firstSizeLabel(),
                    price: price,
                    imageUrl: prod.imageUrl,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CoffeeDetailsPage(
                            coffeeId: prod.id,
                            categoryId: prod.categoryId,
                            coffeeName: prod.name,
                            coffeePrice: '\$${price.toStringAsFixed(2)}',
                            coffeeSize: prod.firstSizeLabel(),
                            rating: prod.ratingAverage,
                            reviews: prod.ratingCount,
                          ),
                        ),
                      );
                    },
                    onAddPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomOrdersPage(
                            coffeeId: prod.id,
                            categoryId: prod.categoryId,
                            coffeeName: prod.name,
                            coffeePrice: '\$${price.toStringAsFixed(2)}',
                            rating: prod.ratingAverage,
                          ),
                        ),
                      );
                    },
                    onRemovePressed: () {},
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
