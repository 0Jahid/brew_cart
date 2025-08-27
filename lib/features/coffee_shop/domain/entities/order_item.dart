import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String id;
  final String coffeeId;
  final String coffeeName;
  final String coffeeImageUrl;
  final String size;
  final String sugarLevel;
  final String temperature;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final Map<String, dynamic> customizations;

  const OrderItem({
    required this.id,
    required this.coffeeId,
    required this.coffeeName,
    required this.coffeeImageUrl,
    required this.size,
    required this.sugarLevel,
    required this.temperature,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.customizations = const {},
  });

  @override
  List<Object?> get props => [
    id,
    coffeeId,
    coffeeName,
    coffeeImageUrl,
    size,
    sugarLevel,
    temperature,
    quantity,
    unitPrice,
    totalPrice,
    customizations,
  ];

  OrderItem copyWith({
    String? id,
    String? coffeeId,
    String? coffeeName,
    String? coffeeImageUrl,
    String? size,
    String? sugarLevel,
    String? temperature,
    int? quantity,
    double? unitPrice,
    double? totalPrice,
    Map<String, dynamic>? customizations,
  }) {
    return OrderItem(
      id: id ?? this.id,
      coffeeId: coffeeId ?? this.coffeeId,
      coffeeName: coffeeName ?? this.coffeeName,
      coffeeImageUrl: coffeeImageUrl ?? this.coffeeImageUrl,
      size: size ?? this.size,
      sugarLevel: sugarLevel ?? this.sugarLevel,
      temperature: temperature ?? this.temperature,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      totalPrice: totalPrice ?? this.totalPrice,
      customizations: customizations ?? this.customizations,
    );
  }
}
