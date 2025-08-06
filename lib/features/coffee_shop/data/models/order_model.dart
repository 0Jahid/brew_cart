import '../../domain/entities/order.dart';
import '../../domain/entities/order_item.dart';
import 'order_item_model.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    required super.userId,
    required super.items,
    required super.subtotal,
    required super.deliveryFee,
    required super.tax,
    required super.total,
    required super.status,
    required super.paymentMethod,
    required super.deliveryAddress,
    required super.orderDate,
    super.estimatedDeliveryTime,
    super.completedAt,
    super.notes,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List)
          .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      status: json['status'] as String,
      paymentMethod: json['paymentMethod'] as String,
      deliveryAddress: json['deliveryAddress'] as String,
      orderDate: DateTime.parse(json['orderDate'] as String),
      estimatedDeliveryTime: json['estimatedDeliveryTime'] != null
          ? DateTime.parse(json['estimatedDeliveryTime'] as String)
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'items': items.map((item) => (item as OrderItemModel).toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'total': total,
      'status': status,
      'paymentMethod': paymentMethod,
      'deliveryAddress': deliveryAddress,
      'orderDate': orderDate.toIso8601String(),
      'estimatedDeliveryTime': estimatedDeliveryTime?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'notes': notes,
    };
  }

  factory OrderModel.fromFirestore(Map<String, dynamic> data, String id) {
    return OrderModel(
      id: id,
      userId: data['userId'] as String,
      items: (data['items'] as List)
          .map((item) => OrderItemModel.fromFirestore(item as Map<String, dynamic>))
          .toList(),
      subtotal: (data['subtotal'] as num).toDouble(),
      deliveryFee: (data['deliveryFee'] as num).toDouble(),
      tax: (data['tax'] as num).toDouble(),
      total: (data['total'] as num).toDouble(),
      status: data['status'] as String,
      paymentMethod: data['paymentMethod'] as String,
      deliveryAddress: data['deliveryAddress'] as String,
      orderDate: (data['orderDate'] as dynamic).toDate() as DateTime,
      estimatedDeliveryTime: data['estimatedDeliveryTime'] != null
          ? (data['estimatedDeliveryTime'] as dynamic).toDate() as DateTime
          : null,
      completedAt: data['completedAt'] != null
          ? (data['completedAt'] as dynamic).toDate() as DateTime
          : null,
      notes: data['notes'] as String?,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((item) => (item as OrderItemModel).toFirestore()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'total': total,
      'status': status,
      'paymentMethod': paymentMethod,
      'deliveryAddress': deliveryAddress,
      'orderDate': orderDate,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'completedAt': completedAt,
      'notes': notes,
    };
  }
}
