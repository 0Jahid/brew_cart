import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_colors.dart';
import '../../core/models/product.dart';

class CategoriesSection extends StatefulWidget {
  final ValueChanged<CategoryModel>? onCategorySelected;
  const CategoriesSection({super.key, this.onCategorySelected});

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      // Simplest query (no where/orderBy) to avoid composite index issues; we filter & sort client-side.
      stream: FirebaseFirestore.instance.collection('categories').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 90,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError) {
          final err = snapshot.error.toString();
          final needsIndex =
              err.contains('failed-precondition') && err.contains('index');
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Failed to load categories',
                  style: TextStyle(
                    color: Colors.red[700],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  needsIndex
                      ? 'Firestore index needed. Tap to retry after creating index.'
                      : err,
                  style: const TextStyle(fontSize: 12, color: Colors.black87),
                ),
                if (needsIndex)
                  Text(
                    'Create composite index on (isActive ASC, position ASC).',
                    style: TextStyle(fontSize: 11, color: Colors.grey[700]),
                  ),
              ],
            ),
          );
        }
        final docs = snapshot.data?.docs ?? [];
        final categories =
            docs.map(CategoryModel.fromDoc).where((c) => c.isActive).toList()
              ..sort((a, b) => a.position.compareTo(b.position));
        // Inject synthetic "All" category at the beginning
        final items = [
          CategoryModel(
            id: 'ALL',
            name: 'All',
            description: '',
            imageUrl: null,
            position: -1,
            isActive: true,
          ),
          ...categories,
        ];
        if (items.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No categories'),
          );
        }
        final selected = items[selectedIndex % items.length];
        // Notify parent on first build
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.onCategorySelected?.call(selected);
        });
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    'See all',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(items.length, (index) {
                    final c = items[index];
                    final isSel = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        setState(() => selectedIndex = index);
                        widget.onCategorySelected?.call(c);
                      },
                      child: Container(
                        margin: EdgeInsets.only(
                          right: index < items.length - 1 ? 16 : 0,
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: isSel ? AppColors.primary : Colors.grey[200],
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (isSel)
                              const Padding(
                                padding: EdgeInsets.only(right: 8),
                                child: Icon(
                                  Icons.coffee,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            Text(
                              c.name,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: isSel ? Colors.white : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
