import 'package:cloud_firestore/cloud_firestore.dart';

class Coffee {
  final String id;
  final String name;
  final String description;
  final String categoryId;
  final String currency;
  final Map<String, dynamic> pricing; // size -> {price, volume}
  final double rating;
  final int reviewCount;
  final int popularity;
  final bool isAvailable;
  final String? thumbnailUrl;

  Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryId,
    required this.currency,
    required this.pricing,
    required this.rating,
    required this.reviewCount,
    required this.popularity,
    required this.isAvailable,
    required this.thumbnailUrl,
  });

  factory Coffee.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final metadata = data['metadata'] as Map<String, dynamic>? ?? {};
    return Coffee(
      id: doc.id,
      name: data['name'] ?? 'Unknown',
      description: data['description'] ?? '',
      categoryId: data['categoryId'] ?? '',
      currency: data['pricingCurrency'] ?? 'BDT',
      pricing: Map<String, dynamic>.from(data['pricing'] ?? {}),
      rating: (metadata['rating'] ?? 0).toDouble(),
      reviewCount: (metadata['reviewCount'] ?? 0).toInt(),
      popularity: (metadata['popularity'] ?? 0).toInt(),
      isAvailable: metadata['isAvailable'] ?? true,
      thumbnailUrl:
          (data['images'] as Map<String, dynamic>? ?? {})['thumbnail']
              as String?,
    );
  }

  double? firstPrice() {
    if (pricing.isEmpty) return null;
    final first = pricing.values.first;
    if (first is Map && first['price'] != null) {
      return (first['price'] as num).toDouble();
    }
    return null;
  }

  String? firstSizeLabel() {
    if (pricing.isEmpty) return null;
    return pricing.keys.first;
  }
}

class CoffeeService {
  final _col = FirebaseFirestore.instance.collection('coffees');

  Stream<List<Coffee>> streamCoffees({bool onlyAvailable = true}) {
    Query query = _col.orderBy('metadata.popularity', descending: true);
    if (onlyAvailable) {
      query = query.where('metadata.isAvailable', isEqualTo: true);
    }
    return query.snapshots().map(
      (snap) => snap.docs.map((d) => Coffee.fromDoc(d)).toList(),
    );
  }
}
