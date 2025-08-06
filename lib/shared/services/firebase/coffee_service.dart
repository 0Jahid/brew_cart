import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/exceptions.dart';
import '../../../features/coffee_shop/domain/entities/coffee.dart';
import '../../../features/coffee_shop/data/models/coffee_model.dart';

abstract class CoffeeService {
  Future<List<Coffee>> getAllCoffees();
  Future<List<Coffee>> getCoffeesByCategory(String category);
  Future<List<Coffee>> getFeaturedCoffees();
  Future<List<Coffee>> getPopularCoffees();
  Future<Coffee?> getCoffeeById(String id);
  Future<List<String>> getCategories();
  Future<List<Coffee>> searchCoffees(String query);
}

class FirebaseCoffeeService implements CoffeeService {
  final FirebaseFirestore _firestore;

  FirebaseCoffeeService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<Coffee>> getAllCoffees() async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.coffeeCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();

      return querySnapshot.docs
          .map((doc) => CoffeeModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Coffee>> getCoffeesByCategory(String category) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.coffeeCollection)
          .where('category', isEqualTo: category)
          .where('isActive', isEqualTo: true)
          .orderBy('name')
          .get();

      return querySnapshot.docs
          .map((doc) => CoffeeModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Coffee>> getFeaturedCoffees() async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.coffeeCollection)
          .where('isFeatured', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .orderBy('rating', descending: true)
          .limit(10)
          .get();

      return querySnapshot.docs
          .map((doc) => CoffeeModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Coffee>> getPopularCoffees() async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.coffeeCollection)
          .where('isPopular', isEqualTo: true)
          .where('isActive', isEqualTo: true)
          .orderBy('rating', descending: true)
          .limit(10)
          .get();

      return querySnapshot.docs
          .map((doc) => CoffeeModel.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<Coffee?> getCoffeeById(String id) async {
    try {
      final docSnapshot = await _firestore
          .collection(AppConstants.coffeeCollection)
          .doc(id)
          .get();

      if (!docSnapshot.exists) {
        return null;
      }

      return CoffeeModel.fromFirestore(docSnapshot.data()!, docSnapshot.id);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<String>> getCategories() async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.categoriesCollection)
          .where('isActive', isEqualTo: true)
          .orderBy('order')
          .get();

      return querySnapshot.docs
          .map((doc) => doc.data()['name'] as String)
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<Coffee>> searchCoffees(String query) async {
    try {
      final querySnapshot = await _firestore
          .collection(AppConstants.coffeeCollection)
          .where('isActive', isEqualTo: true)
          .get();

      // Firestore doesn't support full-text search, so we filter in memory
      // For production, consider using Algolia or Elasticsearch
      final coffees = querySnapshot.docs
          .map((doc) => CoffeeModel.fromFirestore(doc.data(), doc.id))
          .where((coffee) =>
              coffee.name.toLowerCase().contains(query.toLowerCase()) ||
              coffee.description.toLowerCase().contains(query.toLowerCase()) ||
              coffee.category.toLowerCase().contains(query.toLowerCase()))
          .toList();

      return coffees;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
