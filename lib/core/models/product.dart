import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String? imageUrl;
  final int position;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.position,
    required this.isActive,
  });

  factory CategoryModel.fromDoc(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};
    return CategoryModel(
      id: doc.id,
      name: d['name'] ?? '',
      description: d['description'] ?? '',
      imageUrl: d['imageUrl'] as String?,
      position: (d['position'] ?? 0) is int
          ? d['position'] as int
          : (d['position'] as num?)?.toInt() ?? 0,
      isActive: d['isActive'] as bool? ?? true,
    );
  }
}

class ProductModel {
  final String id;
  final String categoryId;
  final String name;
  final String description;
  final String? imageUrl;
  final double basePrice;
  final Map<String, dynamic> sizes; // sizeKey -> {price, volumeMl}
  final Map<String, dynamic> customizations; // raw customizations map
  final bool isAvailable;
  final bool isFeatured;
  final List<dynamic> tags;
  final double ratingAverage;
  final int ratingCount;
  final int popularityIndex; // 'pi' field

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.basePrice,
    required this.sizes,
    required this.customizations,
    required this.isAvailable,
    required this.isFeatured,
    required this.tags,
    required this.ratingAverage,
    required this.ratingCount,
    required this.popularityIndex,
  });

  factory ProductModel.fromDoc(String categoryId, DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};
    final rating = d['rating'] as Map<String, dynamic>? ?? {};
    return ProductModel(
      id: doc.id,
      categoryId: categoryId,
      name: d['name'] ?? '',
      description: d['description'] ?? '',
      imageUrl: d['imageUrl'] as String?,
      basePrice: (d['basePrice'] as num?)?.toDouble() ?? 0,
      sizes: Map<String, dynamic>.from(
        d['sizes'] as Map<String, dynamic>? ?? {},
      ),
      customizations: Map<String, dynamic>.from(
        d['customizations'] as Map<String, dynamic>? ?? {},
      ),
      isAvailable: d['isAvailable'] as bool? ?? true,
      isFeatured: d['isFeatured'] as bool? ?? false,
      tags: (d['tags'] as List<dynamic>? ?? const []),
      ratingAverage: (rating['average'] as num?)?.toDouble() ?? 0,
      ratingCount: (rating['count'] as num?)?.toInt() ?? 0,
      popularityIndex: (d['pi'] as num?)?.toInt() ?? 0,
    );
  }

  /// Build from a collectionGroup 'products' snapshot; derives categoryId from the path.
  factory ProductModel.fromGroupDoc(DocumentSnapshot doc) {
    final parentCat = doc.reference.parent.parent?.id ?? '';
    return ProductModel.fromDoc(parentCat, doc);
  }

  double firstPrice() {
    if (sizes.isNotEmpty) {
      final first = sizes.values.first;
      if (first is Map && first['price'] != null) {
        return (first['price'] as num).toDouble();
      }
    }
    return basePrice;
  }

  String firstSizeLabel() {
    if (sizes.isNotEmpty) return sizes.keys.first;
    return '';
  }
}

class ProductService {
  final _db = FirebaseFirestore.instance;

  Stream<List<CategoryModel>> streamCategories() {
    return _db
        .collection('categories')
        .where('isActive', isEqualTo: true)
        .orderBy('position')
        .snapshots()
        .map((snap) => snap.docs.map(CategoryModel.fromDoc).toList());
  }

  Stream<List<ProductModel>> streamProductsByCategory(String categoryId) {
    return _db
        .collection('categories')
        .doc(categoryId)
        .collection('products')
        .where('isAvailable', isEqualTo: true)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => ProductModel.fromDoc(categoryId, d))
              .toList(),
        );
  }

  Future<ProductModel?> fetchProduct(
    String categoryId,
    String productId,
  ) async {
    final doc = await _db
        .collection('categories')
        .doc(categoryId)
        .collection('products')
        .doc(productId)
        .get();
    if (!doc.exists) return null;
    return ProductModel.fromDoc(categoryId, doc);
  }
}
