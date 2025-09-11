import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/product.dart';
import '../../../custom_orders/presentation/pages/custom_orders_page.dart';

class CoffeeDetailsPage extends StatefulWidget {
  final String coffeeId; // product id
  final String? categoryId; // optional, speeds up lookup
  final String? coffeeName; // fallback pre-fetched values
  final String? coffeePrice;
  final String? coffeeSize;
  final double? rating;
  final int? reviews;

  const CoffeeDetailsPage({
    super.key,
    required this.coffeeId,
    this.categoryId,
    this.coffeeName,
    this.coffeePrice,
    this.coffeeSize,
    this.rating,
    this.reviews,
  });

  @override
  State<CoffeeDetailsPage> createState() => _CoffeeDetailsPageState();
}

class _CoffeeDetailsPageState extends State<CoffeeDetailsPage> {
  bool isFavorited = false;
  ProductModel? _product;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    try {
      DocumentSnapshot? doc;
      if (widget.categoryId != null) {
        doc = await FirebaseFirestore.instance
            .collection('categories')
            .doc(widget.categoryId)
            .collection('products')
            .doc(widget.coffeeId)
            .get();
        if (!doc.exists) doc = null;
      }
      if (doc == null) {
        // Fallback: search via collectionGroup (ensure index if filtering further later)
        final cg = await FirebaseFirestore.instance
            .collectionGroup('products')
            .where(FieldPath.documentId, isEqualTo: widget.coffeeId)
            .limit(1)
            .get();
        if (cg.docs.isNotEmpty) doc = cg.docs.first;
      }
      if (doc == null || !doc.exists) {
        setState(() {
          _error = 'Product not found';
          _loading = false;
        });
        return;
      }
      final prod = ProductModel.fromGroupDoc(doc);
      setState(() {
        _product = prod;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Use provided data or defaults
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(_error!)),
      );
    }
    final prod = _product;
    final coffeeName = prod?.name ?? widget.coffeeName ?? 'Coffee';
    final rating = prod?.ratingAverage ?? widget.rating ?? 0.0;
    final reviews = prod?.ratingCount ?? widget.reviews ?? 0;
    final price = prod != null ? prod.firstPrice() : 0.0;
    final coffeePrice = prod != null
        ? '\$${price.toStringAsFixed(2)}'
        : (widget.coffeePrice ?? '\$0.00');

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
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
        actions: [
          Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: Icon(
                isFavorited ? Icons.favorite : Icons.favorite_border,
                color: isFavorited ? Colors.red : Colors.black87,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  isFavorited = !isFavorited;
                });
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Coffee Image Section
          Expanded(
            flex: 6,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.grey[300]!, Colors.grey[200]!],
                ),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  if (prod?.imageUrl != null)
                    Positioned.fill(
                      child: Image.network(prod!.imageUrl!, fit: BoxFit.cover),
                    )
                  else
                    Center(
                      child: Container(
                        width: 350,
                        height: 380,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(
                          Icons.coffee,
                          size: 100,
                          color: AppColors.primary.withOpacity(0.6),
                        ),
                      ),
                    ),

                  // Coffee Info Overlay
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        // Coffee Name and Actions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Coffee Name
                                  Text(
                                    coffeeName,
                                    style: const TextStyle(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Rating and Reviews
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 16,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        rating.toString(),
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '($reviews Review)',
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white70,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Price
                        Text(
                          coffeePrice,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Description Section
          Expanded(
            flex: 4,
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Description Title
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Description Text
                      Text(
                        prod?.description ?? 'No description provided.',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF606060),
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Add Order Button
                      Container(
                        width: double.infinity,
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CustomOrdersPage(
                                    coffeeId: widget.coffeeId,
                                    coffeeName: coffeeName,
                                    coffeePrice: coffeePrice,
                                    rating: rating,
                                  ),
                                ),
                              );
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
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
