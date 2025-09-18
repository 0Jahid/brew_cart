// CLEAN REWRITE START
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/models/order_item.dart';
import '../../../../core/models/product.dart';
import '../../../coffee_shop/presentation/state/coffee_shop_nav.dart';

class CustomOrdersPage extends StatefulWidget {
  final String coffeeId;
  final String? categoryId;
  final String? coffeeName;
  final String? coffeePrice;
  final double? rating;
  const CustomOrdersPage({
    super.key,
    required this.coffeeId,
    this.categoryId,
    this.coffeeName,
    this.coffeePrice,
    this.rating,
  });
  @override
  State<CustomOrdersPage> createState() => _CustomOrdersPageState();
}

class _CustomOrdersPageState extends State<CustomOrdersPage> {
  String? selectedSize;
  String? selectedSugar;
  String selectedIce = 'Normal Ice';
  int quantity = 1;
  List<String> sizeOptions = const [];
  List<String> sugarOptions = const [];
  final List<String> iceOptions = const ['Normal Ice', 'Less Ice', 'No Ice'];
  ProductModel? _product;
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    if (widget.categoryId == null) {
      setState(() {
        sizeOptions = const ['Regular'];
        sugarOptions = const ['Normal Sugar', 'Less Sugar', 'No Sugar'];
        selectedSize = sizeOptions.first;
        selectedSugar = sugarOptions.first;
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final doc = await FirebaseFirestore.instance
          .collection('categories')
          .doc(widget.categoryId)
          .collection('products')
          .doc(widget.coffeeId)
          .get();
      if (!doc.exists) {
        setState(() {
          _error = 'Product not found';
          _loading = false;
          sizeOptions = const ['Regular'];
          sugarOptions = const ['Normal Sugar', 'Less Sugar', 'No Sugar'];
          selectedSize = sizeOptions.first;
          selectedSugar = sugarOptions.first;
        });
        return;
      }
      final prod = ProductModel.fromDoc(widget.categoryId!, doc);
      final sizes = prod.sizes.keys.map((e) => e.toString()).toList();
      final sugar = (prod.customizations['sugar'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList();
      setState(() {
        _product = prod;
        sizeOptions = sizes.isEmpty ? ['Regular'] : sizes;
        sugarOptions = sugar.isEmpty
            ? ['Normal Sugar', 'Less Sugar', 'No Sugar']
            : sugar;
        selectedSize = sizeOptions.first;
        selectedSugar = sugarOptions.first;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Load failed: $e';
        _loading = false;
      });
    }
  }

  double _priceForSelectedSize() {
    if (_product != null) {
      final s = selectedSize;
      if (s != null && _product!.sizes[s] is Map) {
        final map = _product!.sizes[s] as Map;
        final raw = map['price'];
        if (raw is num) return raw.toDouble();
      }
      return _product!.firstPrice();
    }
    if (widget.coffeePrice != null) {
      final m = RegExp(r'[0-9]+(?:\.[0-9]+)?').firstMatch(widget.coffeePrice!);
      if (m != null) {
        final v = double.tryParse(m.group(0)!);
        if (v != null) return v;
      }
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final coffeeName = widget.coffeeName ?? _product?.name ?? 'Coffee';
    final unitPrice = _priceForSelectedSize();
    final displayPrice = '৳' + unitPrice.toStringAsFixed(2);
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        title: Text(
          coffeeName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Continue', style: TextStyle(color: AppColors.primary)),
          ),
          TextButton(onPressed: _goToOrdersTab, child: const Text('View Cart')),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_error != null) ...[
                _errorBanner(_error!),
                const SizedBox(height: 16),
              ],
              _header(coffeeName, displayPrice),
              const SizedBox(height: 20),
              if (_product?.description != null) ...[
                _description(),
                const SizedBox(height: 20),
              ],
              _sizeSection(),
              const SizedBox(height: 20),
              _choiceSection(
                'Sugar',
                sugarOptions,
                selectedSugar ?? sugarOptions.first,
                (v) {
                  setState(() => selectedSugar = v);
                },
              ),
              const SizedBox(height: 20),
              _choiceSection('Ice', iceOptions, selectedIce, (v) {
                setState(() => selectedIce = v);
              }),
              const SizedBox(height: 30),
              _qtyAndAdd(unitPrice),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorBanner(String msg) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.red.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 18),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            msg,
            style: const TextStyle(fontSize: 12.5, color: Colors.red),
          ),
        ),
      ],
    ),
  );

  Widget _header(String name, String price) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 6,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: AppColors.primary.withValues(alpha: 0.08),
            image: _product?.imageUrl != null
                ? DecorationImage(
                    image: NetworkImage(_product!.imageUrl!),
                    fit: BoxFit.cover,
                  )
                : null,
          ),
          child: _product?.imageUrl == null
              ? Icon(Icons.coffee, color: AppColors.primary, size: 30)
              : null,
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1C1310),
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber.shade600, size: 18),
                  const SizedBox(width: 4),
                  Text(
                    (_product?.ratingAverage.toStringAsFixed(1) ??
                        (widget.rating?.toStringAsFixed(1) ?? '0.0')),
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '(${_product?.ratingCount ?? 0})',
                    style: const TextStyle(fontSize: 12, color: Colors.black54),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: Text(
            price,
            key: ValueKey(price),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    ),
  );

  Widget _description() => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Text(
      _product!.description,
      style: const TextStyle(
        fontSize: 13.5,
        color: Colors.black87,
        height: 1.35,
      ),
    ),
  );

  Widget _sizeSection() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Size',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFFB9B9B9),
              ),
            ),
            Text(
              'Select one',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Column(
          children: sizeOptions.asMap().entries.map((e) {
            final idx = e.key;
            final size = e.value;
            double? p;
            if (_product != null && _product!.sizes[size] is Map) {
              final map = _product!.sizes[size] as Map;
              final raw = map['price'];
              if (raw is num) p = raw.toDouble();
            }
            final sel = size == selectedSize;
            return Column(
              children: [
                GestureDetector(
                  onTap: () => setState(() => selectedSize = size),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          p != null
                              ? '$size  (৳${p.toStringAsFixed(2)})'
                              : size,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Container(
                        width: 18,
                        height: 18,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: sel ? AppColors.primary : Colors.grey[400]!,
                            width: 2,
                          ),
                          color: sel ? AppColors.primary : Colors.transparent,
                        ),
                        child: sel
                            ? const Icon(
                                Icons.circle,
                                size: 8,
                                color: Colors.white,
                              )
                            : null,
                      ),
                    ],
                  ),
                ),
                if (idx < sizeOptions.length - 1) ...[
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

  Widget _choiceSection(
    String title,
    List<String> options,
    String selected,
    Function(String) onChanged,
  ) => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 4,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: Column(
      children: [
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
              'Select one',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 23),
        Column(
          children: options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final sel = option == selected;
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
                            color: sel ? AppColors.primary : Colors.grey[400]!,
                            width: 2,
                          ),
                          color: sel ? AppColors.primary : Colors.transparent,
                        ),
                        child: sel
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

  Widget _qtyAndAdd(double unitPrice) => Row(
    children: [
      Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
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
                if (quantity > 1) setState(() => quantity--);
              },
              child: Container(
                width: 29,
                height: 28,
                decoration: BoxDecoration(
                  color: quantity > 1 ? AppColors.primary : Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.remove, color: Colors.white, size: 16),
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
              onTap: () => setState(() => quantity++),
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 16),
              ),
            ),
          ],
        ),
      ),
      const SizedBox(width: 16),
      Expanded(
        child: Container(
          height: 69,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primary,
                AppColors.primary.withValues(alpha: 0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(46),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.3),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showOrderConfirmation,
              borderRadius: BorderRadius.circular(46),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Add Order',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        letterSpacing: 0.6,
                      ),
                    ),
                    Text(
                      'Total: ৳' + (unitPrice * quantity).toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );

  void _showOrderConfirmation() {
    final price = _priceForSelectedSize();
    final item = OrderItem(
      coffeeId: widget.coffeeId,
      coffeeName: widget.coffeeName ?? _product?.name ?? 'Coffee',
      coffeePrice: '৳' + price.toStringAsFixed(2),
      size: selectedSize ?? 'Regular',
      sugar: selectedSugar ?? 'Normal Sugar',
      ice: selectedIce,
      quantity: quantity,
      rating: widget.rating ?? _product?.ratingAverage,
    );
    CartManager().addItem(item);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.check_circle, color: AppColors.primary, size: 28),
            const SizedBox(width: 8),
            const Text('Added to Cart'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${item.coffeeName} x${item.quantity}'),
            const SizedBox(height: 4),
            Text('Size: ${item.size}'),
            Text('Sugar: ${item.sugar}'),
            Text('Ice: ${item.ice}'),
            const SizedBox(height: 8),
            Text(
              'Item total: ${item.formattedTotalPrice}',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text('Cart Total: ' + CartManager().formattedTotalPrice),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Continue', style: TextStyle(color: AppColors.primary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
              setCoffeeShopTab(1);
            },
            child: const Text('View Cart'),
          ),
        ],
      ),
    );
  }

  void _goToOrdersTab() {
    Navigator.of(context).pop();
    setCoffeeShopTab(1);
  }
}

// CLEAN REWRITE END
