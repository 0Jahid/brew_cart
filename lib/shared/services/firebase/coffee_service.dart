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

/// Dummy in-memory data to keep UI running without backend
class DummyCoffeeService implements CoffeeService {
  final List<CoffeeModel> _coffees = [
    CoffeeModel(
      id: 'classic_americano',
      name: 'Classic Americano',
      description: 'Rich espresso with hot water',
      category: 'espresso',
      basePrice: 3.5,
      imageUrl: 'https://picsum.photos/seed/americano/400/300',
      ingredients: const ['Espresso', 'Hot Water'],
      rating: 4.5,
      reviewCount: 128,
      isPopular: true,
      isFeatured: false,
      sizePrices: const {'Small': 3.5, 'Medium': 4.0, 'Large': 4.5},
      availableSizes: const ['Small', 'Medium', 'Large'],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Future<List<Coffee>> getAllCoffees() async => _coffees;

  @override
  Future<List<Coffee>> getCoffeesByCategory(String category) async =>
      _coffees.where((c) => c.category == category).toList();

  @override
  Future<List<Coffee>> getFeaturedCoffees() async =>
      _coffees.where((c) => c.isFeatured).toList();

  @override
  Future<Coffee?> getCoffeeById(String id) async =>
      _coffees.firstWhere((c) => c.id == id, orElse: () => _coffees.first);

  @override
  Future<List<String>> getCategories() async => ['espresso'];

  @override
  Future<List<Coffee>> getPopularCoffees() async =>
      _coffees.where((c) => c.isPopular).toList();

  @override
  Future<List<Coffee>> searchCoffees(String query) async => _coffees
      .where((c) => c.name.toLowerCase().contains(query.toLowerCase()))
      .toList();
}
