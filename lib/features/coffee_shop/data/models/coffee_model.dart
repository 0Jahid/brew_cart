import '../../domain/entities/coffee.dart';

class CoffeeModel extends Coffee {
  const CoffeeModel({
    required super.id,
    required super.name,
    required super.description,
    required super.category,
    required super.basePrice,
    required super.imageUrl,
    required super.ingredients,
    super.rating,
    super.reviewCount,
    super.isPopular,
    super.isFeatured,
    required super.sizePrices,
    required super.availableSizes,
    required super.createdAt,
    required super.updatedAt,
  });

  factory CoffeeModel.fromJson(Map<String, dynamic> json) {
    return CoffeeModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      basePrice: (json['basePrice'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      ingredients: List<String>.from(json['ingredients'] as List),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      isPopular: json['isPopular'] as bool? ?? false,
      isFeatured: json['isFeatured'] as bool? ?? false,
      sizePrices: Map<String, double>.from(
        (json['sizePrices'] as Map).map(
          (key, value) => MapEntry(key as String, (value as num).toDouble()),
        ),
      ),
      availableSizes: List<String>.from(json['availableSizes'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'basePrice': basePrice,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'rating': rating,
      'reviewCount': reviewCount,
      'isPopular': isPopular,
      'isFeatured': isFeatured,
      'sizePrices': sizePrices,
      'availableSizes': availableSizes,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory CoffeeModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CoffeeModel(
      id: id,
      name: data['name'] as String,
      description: data['description'] as String,
      category: data['category'] as String,
      basePrice: (data['basePrice'] as num).toDouble(),
      imageUrl: data['imageUrl'] as String,
      ingredients: List<String>.from(data['ingredients'] as List),
      rating: (data['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: data['reviewCount'] as int? ?? 0,
      isPopular: data['isPopular'] as bool? ?? false,
      isFeatured: data['isFeatured'] as bool? ?? false,
      sizePrices: Map<String, double>.from(
        (data['sizePrices'] as Map).map(
          (key, value) => MapEntry(key as String, (value as num).toDouble()),
        ),
      ),
      availableSizes: List<String>.from(data['availableSizes'] as List),
      createdAt: (data['createdAt'] as dynamic).toDate() as DateTime,
      updatedAt: (data['updatedAt'] as dynamic).toDate() as DateTime,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'category': category,
      'basePrice': basePrice,
      'imageUrl': imageUrl,
      'ingredients': ingredients,
      'rating': rating,
      'reviewCount': reviewCount,
      'isPopular': isPopular,
      'isFeatured': isFeatured,
      'sizePrices': sizePrices,
      'availableSizes': availableSizes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
