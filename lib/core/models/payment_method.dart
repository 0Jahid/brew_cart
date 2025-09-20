import 'package:equatable/equatable.dart';

class PaymentMethod extends Equatable {
  final String id;
  final String name;
  final String type; // 'card', 'mobile_banking', 'cash'
  final String? icon;
  final bool isDefault;
  final bool isEnabled;

  const PaymentMethod({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.isDefault = false,
    this.isEnabled = true,
  });

  factory PaymentMethod.fromJson(Map<String, dynamic> json) {
    return PaymentMethod(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      icon: json['icon'] as String?,
      isDefault: json['isDefault'] as bool? ?? false,
      isEnabled: json['isEnabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'type': type,
      'icon': icon,
      'isDefault': isDefault,
      'isEnabled': isEnabled,
    };
  }

  PaymentMethod copyWith({
    String? id,
    String? name,
    String? type,
    String? icon,
    bool? isDefault,
    bool? isEnabled,
  }) {
    return PaymentMethod(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      isDefault: isDefault ?? this.isDefault,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  @override
  List<Object?> get props => [id, name, type, icon, isDefault, isEnabled];

  static List<PaymentMethod> getAvailablePaymentMethods() {
    return [
      const PaymentMethod(
        id: 'stripe_card',
        name: 'Credit/Debit Card',
        type: 'card',
        icon: '💳',
        isDefault: true,
        isEnabled: true,
      ),
      const PaymentMethod(
        id: 'cash_on_delivery',
        name: 'Cash on Delivery',
        type: 'cash',
        icon: '💵',
        isDefault: false,
        isEnabled: true,
      ),
    ];
  }
}