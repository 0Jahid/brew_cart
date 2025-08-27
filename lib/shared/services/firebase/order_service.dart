import '../../../features/coffee_shop/domain/entities/order.dart';
import '../../../features/coffee_shop/data/models/order_model.dart';

abstract class OrderService {
  Future<String> createOrder(CoffeeOrder order);
  Future<List<CoffeeOrder>> getUserOrders(String userId);
  Future<CoffeeOrder?> getOrderById(String orderId);
  Future<void> updateOrderStatus(String orderId, String status);
  Stream<CoffeeOrder?> watchOrder(String orderId);
}

class DummyOrderService implements OrderService {
  final Map<String, CoffeeOrder> _orders = {};

  @override
  Future<String> createOrder(CoffeeOrder order) async {
    final id = order.id.isNotEmpty
        ? order.id
        : DateTime.now().millisecondsSinceEpoch.toString();
    _orders[id] = (order as OrderModel).copyWith(id: id);
    return id;
  }

  @override
  Future<CoffeeOrder?> getOrderById(String orderId) async => _orders[orderId];

  @override
  Future<List<CoffeeOrder>> getUserOrders(String userId) async =>
      _orders.values.where((o) => o.userId == userId).toList();

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    final existing = _orders[orderId];
    if (existing != null) {
      _orders[orderId] = (existing as OrderModel).copyWith(status: status);
    }
  }

  @override
  Stream<CoffeeOrder?> watchOrder(String orderId) async* {
    yield _orders[orderId];
  }
}
