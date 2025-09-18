class OrderItem {
  final String coffeeId;
  final String coffeeName;
  final String coffeePrice;
  final String size;
  final String sugar;
  final String ice;
  final int quantity;
  final double? rating;

  OrderItem({
    required this.coffeeId,
    required this.coffeeName,
    required this.coffeePrice,
    required this.size,
    required this.sugar,
    required this.ice,
    required this.quantity,
    this.rating,
  });

  double get totalPrice {
    // Parse price and calculate total based on quantity
    final match = RegExp(r'[0-9]+(?:\.[0-9]+)?').firstMatch(coffeePrice);
    double price = match != null
        ? double.tryParse(match.group(0)!) ?? 5.20
        : 5.20;
    return price * quantity;
  }

  String get formattedTotalPrice {
    return '৳${totalPrice.toStringAsFixed(2)}';
  }

  OrderItem copyWith({
    String? coffeeId,
    String? coffeeName,
    String? coffeePrice,
    String? size,
    String? sugar,
    String? ice,
    int? quantity,
    double? rating,
  }) {
    return OrderItem(
      coffeeId: coffeeId ?? this.coffeeId,
      coffeeName: coffeeName ?? this.coffeeName,
      coffeePrice: coffeePrice ?? this.coffeePrice,
      size: size ?? this.size,
      sugar: sugar ?? this.sugar,
      ice: ice ?? this.ice,
      quantity: quantity ?? this.quantity,
      rating: rating ?? this.rating,
    );
  }

  @override
  String toString() {
    return '$coffeeName ($size, $sugar, $ice) x$quantity - $formattedTotalPrice';
  }
}

class CartManager {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<OrderItem> _cartItems = [];

  List<OrderItem> get cartItems => List.unmodifiable(_cartItems);

  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  double get totalPrice =>
      _cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);

  String get formattedTotalPrice => '৳${totalPrice.toStringAsFixed(2)}';

  void addItem(OrderItem item) {
    // Check if same coffee with same customizations already exists
    int existingIndex = _cartItems.indexWhere(
      (cartItem) =>
          cartItem.coffeeId == item.coffeeId &&
          cartItem.size == item.size &&
          cartItem.sugar == item.sugar &&
          cartItem.ice == item.ice,
    );

    if (existingIndex != -1) {
      // Update quantity if item already exists
      _cartItems[existingIndex] = _cartItems[existingIndex].copyWith(
        quantity: _cartItems[existingIndex].quantity + item.quantity,
      );
    } else {
      // Add new item
      _cartItems.add(item);
    }
  }

  void removeItem(int index) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
    }
  }

  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _cartItems.length) {
      if (newQuantity <= 0) {
        removeItem(index);
      } else {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      }
    }
  }

  // Replace an existing item with a modified version (size/sugar/ice changes etc.)
  void updateItem(int index, OrderItem newItem) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index] = newItem;
    }
  }

  void clearCart() {
    _cartItems.clear();
  }
}
