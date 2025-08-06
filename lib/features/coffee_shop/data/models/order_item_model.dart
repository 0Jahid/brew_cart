import '../../domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.id,
    required super.coffeeId,
    required super.coffeeName,
    required super.coffeeImageUrl,
    required super.size,
    required super.sugarLevel,
    required super.temperature,
    required super.quantity,
    required super.unitPrice,
    required super.totalPrice,
    super.customizations,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      coffeeId: json['coffeeId'] as String,
      coffeeName: json['coffeeName'] as String,
      coffeeImageUrl: json['coffeeImageUrl'] as String,
      size: json['size'] as String,
      sugarLevel: json['sugarLevel'] as String,
      temperature: json['temperature'] as String,
      quantity: json['quantity'] as int,
      unitPrice: (json['unitPrice'] as num).toDouble(),
      totalPrice: (json['totalPrice'] as num).toDouble(),
      customizations: json['customizations'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coffeeId': coffeeId,
      'coffeeName': coffeeName,
      'coffeeImageUrl': coffeeImageUrl,
      'size': size,
      'sugarLevel': sugarLevel,
      'temperature': temperature,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'customizations': customizations,
    };
  }

  factory OrderItemModel.fromFirestore(Map<String, dynamic> data) {
    return OrderItemModel(
      id: data['id'] as String,
      coffeeId: data['coffeeId'] as String,
      coffeeName: data['coffeeName'] as String,
      coffeeImageUrl: data['coffeeImageUrl'] as String,
      size: data['size'] as String,
      sugarLevel: data['sugarLevel'] as String,
      temperature: data['temperature'] as String,
      quantity: data['quantity'] as int,
      unitPrice: (data['unitPrice'] as num).toDouble(),
      totalPrice: (data['totalPrice'] as num).toDouble(),
      customizations: data['customizations'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'coffeeId': coffeeId,
      'coffeeName': coffeeName,
      'coffeeImageUrl': coffeeImageUrl,
      'size': size,
      'sugarLevel': sugarLevel,
      'temperature': temperature,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'totalPrice': totalPrice,
      'customizations': customizations,
    };
  }
}
