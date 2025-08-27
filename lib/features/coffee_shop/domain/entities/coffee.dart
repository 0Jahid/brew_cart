import 'package:equatable/equatable.dart';

class Coffee extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final double basePrice;
  final String imageUrl;
  final List<String> ingredients;
  final double rating;
  final int reviewCount;
  final bool isPopular;
  final bool isFeatured;
  final Map<String, double> sizePrices; // Small, Medium, Large
  final List<String> availableSizes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Coffee({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.basePrice,
    required this.imageUrl,
    required this.ingredients,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isPopular = false,
    this.isFeatured = false,
    required this.sizePrices,
    required this.availableSizes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    category,
    basePrice,
    imageUrl,
    ingredients,
    rating,
    reviewCount,
    isPopular,
    isFeatured,
    sizePrices,
    availableSizes,
    createdAt,
    updatedAt,
  ];

  Coffee copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? basePrice,
    String? imageUrl,
    List<String>? ingredients,
    double? rating,
    int? reviewCount,
    bool? isPopular,
    bool? isFeatured,
    Map<String, double>? sizePrices,
    List<String>? availableSizes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Coffee(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      basePrice: basePrice ?? this.basePrice,
      imageUrl: imageUrl ?? this.imageUrl,
      ingredients: ingredients ?? this.ingredients,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isPopular: isPopular ?? this.isPopular,
      isFeatured: isFeatured ?? this.isFeatured,
      sizePrices: sizePrices ?? this.sizePrices,
      availableSizes: availableSizes ?? this.availableSizes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
