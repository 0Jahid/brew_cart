import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> main() async {
  // Initialize Firebase
  await Firebase.initializeApp();

  final db = FirebaseFirestore.instance;

  // ---------- SETTINGS (App Config) ----------
  await db.collection('settings').doc('app_config').set({
    'payment': {
      'currency': {'code': 'BDT', 'symbol': '৳'},
      'adminFee': 10.0,
      'taxRate': 0.00,
      'acceptedMethods': ['cash', 'e_wallet', 'card'],
    },
    'delivery': {
      'baseFee': 40.0,
      'freeDeliveryMinimum': 800.0,
      'estimatedTime': {'preparation': 12, 'delivery': 25},
    },
    'business': {
      'name': 'Brew Cart BD',
      'email': 'support@brewcart.bd',
      'phone': '+8801700000000',
      'address': 'Dhaka, Bangladesh',
      'openingHours': {
        'monday': {'open': '07:00', 'close': '22:00'},
        'tuesday': {'open': '07:00', 'close': '22:00'},
        'wednesday': {'open': '07:00', 'close': '22:00'},
        'thursday': {'open': '07:00', 'close': '22:00'},
        'friday': {'open': '07:00', 'close': '23:00'},
        'saturday': {'open': '08:00', 'close': '23:00'},
        'sunday': {'open': '08:00', 'close': '21:00'},
      },
    },
    'app': {'version': '1.0.0', 'forceUpdate': false},
  });

  // ---------- CATEGORIES ----------
  await db.collection('categories').doc('cat_espresso').set({
    'categoryId': 'cat_espresso',
    'name': 'Espresso Based',
    'description': 'Classic espresso drinks',
    'imageUrl': 'https://i.imgur.com/espresso-category.jpg',
    'iconUrl': 'https://i.imgur.com/espresso-icon.svg',
    'displayOrder': 1,
    'isActive': true,
  });

  await db.collection('categories').doc('cat_cold').set({
    'categoryId': 'cat_cold',
    'name': 'Iced & Cold',
    'description': 'Chilled and refreshing',
    'imageUrl': 'https://i.imgur.com/cold-category.jpg',
    'iconUrl': 'https://i.imgur.com/cold-icon.svg',
    'displayOrder': 2,
    'isActive': true,
  });

  await db.collection('categories').doc('cat_traditional').set({
    'categoryId': 'cat_traditional',
    'name': 'Traditional',
    'description': 'Local Bangladeshi tea & coffee',
    'imageUrl': 'https://i.imgur.com/traditional-category.jpg',
    'iconUrl': 'https://i.imgur.com/tea-icon.svg',
    'displayOrder': 3,
    'isActive': true,
  });

  // ---------- COFFEES ----------
  await db.collection('coffees').doc('coffee_espresso').set({
    'name': 'Espresso',
    'description': 'Strong, bold single shot',
    'categoryId': 'cat_espresso',
    'pricingCurrency': 'BDT',
    'images': {
      'thumbnail': 'https://i.imgur.com/espresso-thumb.jpg',
      'main': 'https://i.imgur.com/espresso-main.jpg',
      'gallery': [
        'https://i.imgur.com/espresso-1.jpg',
        'https://i.imgur.com/espresso-2.jpg',
      ],
    },
    'pricing': {
      'single': {'price': 140.0, 'volume': '30 ml'},
      'double': {'price': 180.0, 'volume': '60 ml'},
    },
    'customization': {
      'sizes': ['single', 'double'],
      'milkOptions': [],
      'sugarOptions': ['none', 'less', 'normal'],
      'extras': [
        {'name': 'Extra Shot', 'price': 40.0},
      ],
      'iceOptions': [],
    },
    'metadata': {
      'rating': 4.6,
      'reviewCount': 52,
      'popularity': 75,
      'isAvailable': true,
      'preparationTime': 4,
      'tags': ['strong', 'classic'],
    },
  });

  await db.collection('coffees').doc('coffee_cappuccino').set({
    'name': 'Cappuccino',
    'description': 'Espresso with steamed milk foam',
    'categoryId': 'cat_espresso',
    'pricingCurrency': 'BDT',
    'images': {
      'thumbnail':
          'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=200&h=200&fit=crop',
      'main':
          'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=500&h=500&fit=crop',
      'gallery': [
        'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=600&h=400&fit=crop',
        'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=600&h=400&fit=crop',
      ],
    },
    'pricing': {
      'small': {'price': 180.0, 'volume': '200 ml'},
      'regular': {'price': 220.0, 'volume': '250 ml'},
      'large': {'price': 260.0, 'volume': '320 ml'},
    },
    'customization': {
      'sizes': ['small', 'regular', 'large'],
      'milkOptions': [
        {'name': 'Whole', 'extraCost': 0.0, 'isDefault': true},
        {'name': 'Low Fat', 'extraCost': 0.0},
        {'name': 'Almond', 'extraCost': 30.0},
        {'name': 'Oat', 'extraCost': 35.0},
      ],
      'sugarOptions': [
        {'name': 'No Sugar'},
        {'name': 'Less'},
        {'name': 'Normal', 'isDefault': true},
      ],
      'extras': [
        {'name': 'Vanilla Syrup', 'price': 30.0},
        {'name': 'Caramel Syrup', 'price': 30.0},
        {'name': 'Extra Shot', 'price': 40.0},
      ],
      'iceOptions': ['No Ice', 'Less Ice', 'Normal Ice'],
    },
    'metadata': {
      'rating': 4.7,
      'reviewCount': 188,
      'popularity': 90,
      'isAvailable': true,
      'isFeatured': true,
      'isNew': false,
      'preparationTime': 6,
      'tags': ['milky', 'popular'],
    },
  });

  await db.collection('coffees').doc('coffee_latte').set({
    'name': 'Latte',
    'description': 'Smooth espresso with steamed milk',
    'categoryId': 'cat_espresso',
    'pricingCurrency': 'BDT',
    'images': {
      'thumbnail':
          'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=200&h=200&fit=crop',
      'main':
          'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=500&h=500&fit=crop',
      'gallery': [
        'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=600&h=400&fit=crop',
      ],
    },
    'pricing': {
      'small': {'price': 200.0, 'volume': '250 ml'},
      'regular': {'price': 240.0, 'volume': '350 ml'},
      'large': {'price': 280.0, 'volume': '450 ml'},
    },
    'customization': {
      'sizes': ['small', 'regular', 'large'],
      'milkOptions': [
        {'name': 'Whole', 'extraCost': 0.0, 'isDefault': true},
        {'name': 'Almond', 'extraCost': 30.0},
        {'name': 'Oat', 'extraCost': 35.0},
      ],
      'sugarOptions': ['none', 'less', 'normal', 'extra'],
      'extras': [
        {'name': 'Vanilla Syrup', 'price': 30.0},
        {'name': 'Hazelnut Syrup', 'price': 30.0},
        {'name': 'Extra Shot', 'price': 40.0},
      ],
      'iceOptions': ['No Ice', 'Less Ice', 'Normal Ice'],
    },
    'metadata': {
      'rating': 4.5,
      'reviewCount': 142,
      'popularity': 85,
      'isAvailable': true,
      'isFeatured': true,
      'isNew': true,
      'preparationTime': 5,
      'tags': ['smooth', 'milky'],
    },
  });

  await db.collection('coffees').doc('coffee_americano').set({
    'name': 'Americano',
    'description': 'Espresso diluted with hot water',
    'categoryId': 'cat_espresso',
    'pricingCurrency': 'BDT',
    'images': {
      'thumbnail':
          'https://images.unsplash.com/photo-1507133750040-4a8f57021571?w=200&h=200&fit=crop',
      'main':
          'https://images.unsplash.com/photo-1507133750040-4a8f57021571?w=500&h=500&fit=crop',
      'gallery': [
        'https://images.unsplash.com/photo-1507133750040-4a8f57021571?w=600&h=400&fit=crop',
      ],
    },
    'pricing': {
      'small': {'price': 160.0, 'volume': '200 ml'},
      'regular': {'price': 190.0, 'volume': '300 ml'},
      'large': {'price': 220.0, 'volume': '400 ml'},
    },
    'customization': {
      'sizes': ['small', 'regular', 'large'],
      'milkOptions': [
        {'name': 'None', 'extraCost': 0.0, 'isDefault': true},
        {'name': 'A splash', 'extraCost': 20.0},
      ],
      'sugarOptions': ['none', 'less', 'normal'],
      'extras': [
        {'name': 'Extra Shot', 'price': 40.0},
      ],
      'iceOptions': ['No Ice', 'Less Ice', 'Normal Ice'],
    },
    'metadata': {
      'rating': 4.4,
      'reviewCount': 96,
      'popularity': 70,
      'isAvailable': true,
      'isFeatured': false,
      'isNew': false,
      'preparationTime': 4,
      'tags': ['strong', 'simple'],
    },
  });

  await db.collection('coffees').doc('coffee_cold_brew').set({
    'name': 'Cold Brew',
    'description': 'Slow steeped smooth cold coffee',
    'categoryId': 'cat_cold',
    'pricingCurrency': 'BDT',
    'images': {
      'thumbnail':
          'https://images.unsplash.com/photo-1517959105821-eaf2591984ca?w=200&h=200&fit=crop',
      'main':
          'https://images.unsplash.com/photo-1517959105821-eaf2591984ca?w=500&h=500&fit=crop',
      'gallery': [
        'https://images.unsplash.com/photo-1517959105821-eaf2591984ca?w=600&h=400&fit=crop',
      ],
    },
    'pricing': {
      'regular': {'price': 260.0, 'volume': '250 ml'},
      'large': {'price': 300.0, 'volume': '350 ml'},
    },
    'customization': {
      'sizes': ['regular', 'large'],
      'milkOptions': [
        {'name': 'None', 'extraCost': 0.0, 'isDefault': true},
        {'name': 'Almond', 'extraCost': 30.0},
        {'name': 'Oat', 'extraCost': 35.0},
      ],
      'sugarOptions': ['none', 'less', 'normal'],
      'extras': [
        {'name': 'Vanilla Syrup', 'price': 30.0},
        {'name': 'Caramel Syrup', 'price': 30.0},
      ],
      'iceOptions': ['Less Ice', 'Normal Ice', 'Extra Ice'],
    },
    'metadata': {
      'rating': 4.5,
      'reviewCount': 64,
      'popularity': 70,
      'isAvailable': true,
      'isFeatured': false,
      'isNew': true,
      'preparationTime': 10,
      'tags': ['cold', 'smooth'],
    },
  });

  await db.collection('coffees').doc('coffee_iced_latte').set({
    'name': 'Iced Latte',
    'description': 'Chilled latte with ice',
    'categoryId': 'cat_cold',
    'pricingCurrency': 'BDT',
    'images': {
      'thumbnail':
          'https://images.unsplash.com/photo-1543007625-f17c95948ac4?w=200&h=200&fit=crop',
      'main':
          'https://images.unsplash.com/photo-1543007625-f17c95948ac4?w=500&h=500&fit=crop',
      'gallery': [
        'https://images.unsplash.com/photo-1543007625-f17c95948ac4?w=600&h=400&fit=crop',
      ],
    },
    'pricing': {
      'regular': {'price': 250.0, 'volume': '350 ml'},
      'large': {'price': 290.0, 'volume': '450 ml'},
    },
    'customization': {
      'sizes': ['regular', 'large'],
      'milkOptions': [
        {'name': 'Whole', 'extraCost': 0.0, 'isDefault': true},
        {'name': 'Almond', 'extraCost': 30.0},
        {'name': 'Oat', 'extraCost': 35.0},
      ],
      'sugarOptions': ['none', 'less', 'normal'],
      'extras': [
        {'name': 'Vanilla Syrup', 'price': 30.0},
        {'name': 'Caramel Syrup', 'price': 30.0},
        {'name': 'Extra Shot', 'price': 40.0},
      ],
      'iceOptions': ['Normal Ice', 'Extra Ice'],
    },
    'metadata': {
      'rating': 4.6,
      'reviewCount': 89,
      'popularity': 80,
      'isAvailable': true,
      'isFeatured': true,
      'isNew': true,
      'preparationTime': 6,
      'tags': ['cold', 'refreshing'],
    },
  });

  await db.collection('coffees').doc('coffee_masala_chai').set({
    'name': 'Masala Chai',
    'description': 'Traditional spiced tea with milk',
    'categoryId': 'cat_traditional',
    'pricingCurrency': 'BDT',
    'images': {
      'thumbnail':
          'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=200&h=200&fit=crop',
      'main':
          'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=500&h=500&fit=crop',
      'gallery': [
        'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=600&h=400&fit=crop',
      ],
    },
    'pricing': {
      'small': {'price': 80.0, 'volume': '150 ml'},
      'regular': {'price': 100.0, 'volume': '200 ml'},
      'large': {'price': 120.0, 'volume': '300 ml'},
    },
    'customization': {
      'sizes': ['small', 'regular', 'large'],
      'milkOptions': [
        {'name': 'Full Cream', 'extraCost': 0.0, 'isDefault': true},
        {'name': 'Half Milk', 'extraCost': 0.0},
      ],
      'sugarOptions': ['less', 'normal', 'extra'],
      'extras': [
        {'name': 'Extra Ginger', 'price': 10.0},
        {'name': 'Extra Cardamom', 'price': 15.0},
      ],
      'iceOptions': [],
    },
    'metadata': {
      'rating': 4.8,
      'reviewCount': 234,
      'popularity': 95,
      'isAvailable': true,
      'isFeatured': true,
      'isNew': false,
      'preparationTime': 8,
      'tags': ['traditional', 'spiced', 'popular'],
    },
  });

  // ---------- PROMO ----------
  await db.collection('promos').doc('FIRST15').set({
    'title': 'First Order 15% Off',
    'description': 'Save 15% on your first order (min ৳400)',
    'bannerImageUrl':
        'https://images.unsplash.com/photo-1559056199-641a0ac8b55e?w=800&h=400&fit=crop',
    'iconUrl':
        'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?w=100&h=100&fit=crop',
    'type': 'percentage',
    'value': 15,
    'conditions': {
      'minimumOrder': 400.0,
      'maximumDiscount': 120.0,
      'firstTimeUserOnly': true,
    },
    'validity': {
      'startDate': DateTime.now().toIso8601String(),
      'endDate': DateTime.now().add(Duration(days: 90)).toIso8601String(),
      'isActive': true,
    },
    'metadata': {'priority': 1, 'isPublic': true},
  });

  await db.collection('promos').doc('WEEKEND20').set({
    'title': 'Weekend Special',
    'description': '20% off on weekends (Fri-Sun)',
    'bannerImageUrl':
        'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=800&h=400&fit=crop',
    'iconUrl':
        'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=100&h=100&fit=crop',
    'type': 'percentage',
    'value': 20,
    'conditions': {
      'minimumOrder': 300.0,
      'maximumDiscount': 150.0,
      'validDays': ['friday', 'saturday', 'sunday'],
    },
    'validity': {
      'startDate': DateTime.now().toIso8601String(),
      'endDate': DateTime.now().add(Duration(days: 365)).toIso8601String(),
      'isActive': true,
    },
    'metadata': {'priority': 2, 'isPublic': true},
  });

  // ---------- DEMO USER ----------
  final userId = 'demo_user_bdt';
  await db.collection('users').doc(userId).set({
    'profile': {
      'displayName': 'Rahim Uddin',
      'email': 'rahim@example.com',
      'phone': '+8801700000000',
      'profileImageUrl':
          'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=200&h=200&fit=crop',
      'dateJoined': DateTime.now().toIso8601String(),
    },
    'membership': {
      'tier': 'bronze',
      'points': 120,
      'totalOrders': 3,
      'totalSpent': 1240.0,
    },
    'preferences': {
      'defaultSize': 'regular',
      'defaultMilk': 'Whole',
      'defaultSugar': 'Normal',
      'notifications': {
        'orderUpdates': true,
        'promotions': true,
        'pushEnabled': true,
      },
    },
    'currentCart': {
      'items': [
        {
          'id': 'cart_item_1',
          'coffeeId': 'coffee_cappuccino',
          'coffeeName': 'Cappuccino',
          'coffeeImageUrl':
              'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=200&h=200&fit=crop',
          'size': 'regular',
          'quantity': 1,
          'unitPrice': 220.0,
          'totalPrice': 220.0,
          'customizations': {'milk': 'Whole', 'sugar': 'Normal', 'extras': []},
          'addedAt': DateTime.now().toIso8601String(),
        },
        {
          'id': 'cart_item_2',
          'coffeeId': 'coffee_masala_chai',
          'coffeeName': 'Masala Chai',
          'coffeeImageUrl':
              'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=200&h=200&fit=crop',
          'size': 'regular',
          'quantity': 2,
          'unitPrice': 100.0,
          'totalPrice': 200.0,
          'customizations': {
            'milk': 'Full Cream',
            'sugar': 'Normal',
            'extras': ['Extra Ginger'],
          },
          'addedAt': DateTime.now().toIso8601String(),
        },
      ],
      'summary': {
        'itemCount': 3,
        'subtotal': 420.0,
        'deliveryFee': 40.0,
        'adminFee': 10.0,
        'total': 470.0,
        'currency': 'BDT',
        'lastUpdated': DateTime.now().toIso8601String(),
      },
    },
    'orderHistory': [
      {
        'orderId': 'ORD_BD_001',
        'status': 'delivered',
        'placedAt': DateTime.now()
            .subtract(Duration(days: 2))
            .toIso8601String(),
        'deliveredAt': DateTime.now()
            .subtract(Duration(days: 2, hours: -1))
            .toIso8601String(),
        'items': [
          {
            'coffeeId': 'coffee_cappuccino',
            'coffeeName': 'Cappuccino',
            'coffeeImageUrl':
                'https://images.unsplash.com/photo-1517701604599-bb29b565090c?w=200&h=200&fit=crop',
            'size': 'regular',
            'quantity': 1,
            'unitPrice': 220.0,
            'totalPrice': 220.0,
            'customizations': {
              'milk': 'Whole',
              'sugar': 'Normal',
              'extras': [],
            },
          },
          {
            'coffeeId': 'coffee_cold_brew',
            'coffeeName': 'Cold Brew',
            'coffeeImageUrl':
                'https://images.unsplash.com/photo-1517959105821-eaf2591984ca?w=200&h=200&fit=crop',
            'size': 'regular',
            'quantity': 1,
            'unitPrice': 260.0,
            'totalPrice': 260.0,
            'customizations': {'milk': 'None', 'sugar': 'Less', 'extras': []},
          },
        ],
        'summary': {
          'subtotal': 480.0,
          'deliveryFee': 40.0,
          'adminFee': 10.0,
          'discount': 20.0,
          'total': 510.0,
          'currency': 'BDT',
        },
        'payment': {
          'method': 'e_wallet',
          'provider': 'bKash',
          'status': 'paid',
          'transactionId': 'bkash_demo_123',
        },
      },
      {
        'orderId': 'ORD_BD_002',
        'status': 'delivered',
        'placedAt': DateTime.now()
            .subtract(Duration(days: 5))
            .toIso8601String(),
        'deliveredAt': DateTime.now()
            .subtract(Duration(days: 5, hours: -1))
            .toIso8601String(),
        'items': [
          {
            'coffeeId': 'coffee_masala_chai',
            'coffeeName': 'Masala Chai',
            'coffeeImageUrl':
                'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=200&h=200&fit=crop',
            'size': 'large',
            'quantity': 3,
            'unitPrice': 120.0,
            'totalPrice': 360.0,
            'customizations': {
              'milk': 'Full Cream',
              'sugar': 'Extra',
              'extras': ['Extra Ginger', 'Extra Cardamom'],
            },
          },
        ],
        'summary': {
          'subtotal': 360.0,
          'deliveryFee': 40.0,
          'adminFee': 10.0,
          'discount': 0.0,
          'total': 410.0,
          'currency': 'BDT',
        },
        'payment': {
          'method': 'cash',
          'provider': 'Cash on Delivery',
          'status': 'paid',
        },
      },
      {
        'orderId': 'ORD_BD_003',
        'status': 'cancelled',
        'placedAt': DateTime.now()
            .subtract(Duration(days: 7))
            .toIso8601String(),
        'cancelledAt': DateTime.now()
            .subtract(Duration(days: 7, hours: -2))
            .toIso8601String(),
        'items': [
          {
            'coffeeId': 'coffee_latte',
            'coffeeName': 'Latte',
            'coffeeImageUrl':
                'https://images.unsplash.com/photo-1461023058943-07fcbe16d735?w=200&h=200&fit=crop',
            'size': 'large',
            'quantity': 1,
            'unitPrice': 280.0,
            'totalPrice': 280.0,
            'customizations': {
              'milk': 'Oat',
              'sugar': 'Normal',
              'extras': ['Vanilla Syrup'],
            },
          },
        ],
        'summary': {
          'subtotal': 280.0,
          'deliveryFee': 40.0,
          'adminFee': 10.0,
          'discount': 0.0,
          'total': 330.0,
          'currency': 'BDT',
        },
        'payment': {
          'method': 'e_wallet',
          'provider': 'Rocket',
          'status': 'refunded',
        },
      },
    ],
    'favorites': [
      {
        'coffeeId': 'coffee_cappuccino',
        'addedAt': DateTime.now().toIso8601String(),
      },
      {
        'coffeeId': 'coffee_masala_chai',
        'addedAt': DateTime.now().toIso8601String(),
      },
    ],
  });

  print(
    '✅ Firebase seed data populated successfully with BDT currency and images!',
  );
  print('📊 Created:');
  print('   - 3 Categories with images');
  print('   - 8 Coffee items with Unsplash images');
  print('   - 2 Promotional offers');
  print('   - 1 Demo user with order history');
  print('   - App settings with BDT currency');
  print('💰 Currency: Bangladeshi Taka (৳)');
  print('🖼️  Images: Unsplash URLs for all items');
}
