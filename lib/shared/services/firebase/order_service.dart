import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../features/coffee_shop/domain/entities/order.dart';
import '../../../features/coffee_shop/data/models/order_model.dart';

abstract class OrderService {
  Future<String> createOrder(CoffeeOrder order);
  Future<List<CoffeeOrder>> getUserOrders(String userId);
  Future<CoffeeOrder?> getOrderById(String orderId);
  Future<void> updateOrderStatus(String orderId, String status);
  Stream<CoffeeOrder?> watchOrder(String orderId);
}

class FirebaseOrderService implements OrderService {
  final FirebaseFirestore _firestore;

  FirebaseOrderService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<String> createOrder(CoffeeOrder order) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.ordersCollection)
          .add((order as OrderModel).toFirestore());

      return docRef.id;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CoffeeOrder>> getUserOrders(String userId) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.ordersCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('orderDate', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<CoffeeOrder?> getOrderById(String orderId) async {
    try {
      final docSnapshot = await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .get();

      if (!docSnapshot.exists) {
        return null;
      }

      return OrderModel.fromFirestore(docSnapshot.data()!, docSnapshot.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<CoffeeOrder?> watchOrder(String orderId) {
    try {
      return _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .snapshots()
          .map((docSnapshot) {
        if (!docSnapshot.exists) {
          return null;
        }
        return OrderModel.fromFirestore(docSnapshot.data()!, docSnapshot.id);
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
