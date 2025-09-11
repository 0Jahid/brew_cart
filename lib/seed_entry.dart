// Flutter entrypoint to seed Firestore data.
// Run with:
//   flutter run -d windows -t lib/seed_entry.dart
// or any other device/emulator. It will seed then exit.
// NOTE: Do NOT run via `dart run` (needs Flutter engine for plugins).

import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final db = FirebaseFirestore.instance;
  stdout.writeln('Seeding start...');
  await _seedCategories(db);
  await _seedPromoCodes(db);
  await _seedConfig(db);
  stdout.writeln('Seeding complete. Exit in 2s');
  // Give Firestore a moment to flush network tasks.
  await Future.delayed(const Duration(seconds: 2));
  exit(0);
}

Future<void> _seedCategories(FirebaseFirestore db) async {
  final categories = <Map<String, dynamic>>[
    {
      'id': 'latte',
      'name': 'Latte',
      'description': 'Espresso with steamed milk',
      'imageUrl': 'https://example.com/images/latte_cat.png',
      'position': 1,
      'isActive': true,
      'products': [
        {
          'id': 'vanilla_latte',
          'name': 'Vanilla Latte',
          'description': 'Smooth espresso with vanilla syrup & milk',
          'imageUrl': 'https://example.com/images/vanilla_latte.png',
          'basePrice': 4.00,
          'sizes': {
            'small': {'price': 3.50, 'volumeMl': 240},
            'medium': {'price': 4.50, 'volumeMl': 350},
            'large': {'price': 5.25, 'volumeMl': 470},
          },
          'customizations': {
            'milk': ['Whole', 'Skim', 'Oat', 'Almond'],
            'sugar': ['None', 'Less', 'Regular', 'Extra'],
            'extraShots': {'max': 3, 'pricePerShot': 0.75},
            'toppings': {
              'options': [
                {'id': 'cinnamon', 'label': 'Cinnamon', 'price': 0.30},
                {'id': 'whip', 'label': 'Whipped Cream', 'price': 0.50},
              ],
              'allowMultiple': true,
            },
          },
          'isAvailable': true,
          'isFeatured': true,
          'tags': ['seasonal', 'vanilla'],
          'rating': {'average': 4.6, 'count': 128},
          'pi': 88,
        },
        {
          'id': 'caramel_latte',
          'name': 'Caramel Latte',
          'description': 'Rich caramel with velvety steamed milk',
          'imageUrl': 'https://images.unsplash.com/photo-1541167760496-1628856ab772?w=600',
          'basePrice': 4.25,
          'sizes': {
            'small': {'price': 3.75, 'volumeMl': 240},
            'medium': {'price': 4.75, 'volumeMl': 350},
            'large': {'price': 5.50, 'volumeMl': 470},
          },
          'customizations': {
            'milk': ['Whole', 'Skim', 'Oat', 'Almond'],
            'sugar': ['None', 'Less', 'Regular', 'Extra'],
            'toppings': {
              'options': [
                {'id': 'caramel_drizzle', 'label': 'Caramel Drizzle', 'price': 0.40},
              ],
              'allowMultiple': true,
            },
          },
          'isAvailable': true,
          'isFeatured': false,
          'tags': ['caramel'],
          'rating': {'average': 4.5, 'count': 92},
          'pi': 76,
        },
        {
          'id': 'hazelnut_latte',
          'name': 'Hazelnut Latte',
          'description': 'Nutty hazelnut flavor with smooth milk foam',
          'imageUrl': 'https://images.unsplash.com/photo-1523942839745-7848d4d6ea25?w=600',
          'basePrice': 4.50,
          'sizes': {
            'small': {'price': 3.95, 'volumeMl': 240},
            'medium': {'price': 4.95, 'volumeMl': 350},
            'large': {'price': 5.75, 'volumeMl': 470},
          },
          'customizations': {
            'milk': ['Whole', 'Skim', 'Oat', 'Almond'],
            'sugar': ['None', 'Less', 'Regular', 'Extra'],
          },
          'isAvailable': true,
          'isFeatured': false,
          'tags': ['nutty'],
          'rating': {'average': 4.3, 'count': 51},
          'pi': 61,
        },
      ],
    },
    {
      'id': 'cold_brew',
      'name': 'Cold Brew',
      'description': 'Slow steeped cold extraction',
      'imageUrl': 'https://example.com/images/coldbrew_cat.png',
      'position': 2,
      'isActive': true,
      'products': [
        {
          'id': 'classic_cold_brew',
          'name': 'Classic Cold Brew',
          'description': 'Bold & smooth cold brew over ice',
          'imageUrl': 'https://example.com/images/classic_coldbrew.png',
          'basePrice': 3.75,
          'sizes': {
            'small': {'price': 3.25, 'volumeMl': 240},
            'medium': {'price': 4.00, 'volumeMl': 350},
            'large': {'price': 4.75, 'volumeMl': 470},
          },
          'customizations': {
            'sweetener': ['None', 'Sugar', 'Stevia'],
            'ice': ['Light', 'Normal', 'Extra'],
            'toppings': {
              'options': [
                {'id': 'lemon_zest', 'label': 'Lemon Zest', 'price': 0.30},
              ],
              'allowMultiple': true,
            },
          },
          'isAvailable': true,
          'isFeatured': false,
          'tags': ['cold', 'summer'],
          'rating': {'average': 4.4, 'count': 64},
          'pi': 72,
        },
        {
          'id': 'vanilla_cold_brew',
          'name': 'Vanilla Cold Brew',
          'description': 'Cold brew lightly sweetened with vanilla',
          'imageUrl': 'https://images.unsplash.com/photo-1498804103079-a6351b050096?w=600',
          'basePrice': 3.95,
          'sizes': {
            'small': {'price': 3.45, 'volumeMl': 240},
            'medium': {'price': 4.20, 'volumeMl': 350},
            'large': {'price': 4.95, 'volumeMl': 470},
          },
          'customizations': {
            'sweetener': ['None', 'Sugar', 'Vanilla Syrup'],
            'ice': ['Light', 'Normal', 'Extra'],
          },
          'isAvailable': true,
          'isFeatured': true,
          'tags': ['cold', 'vanilla'],
          'rating': {'average': 4.6, 'count': 110},
          'pi': 84,
        },
        {
          'id': 'nitro_cold_brew',
          'name': 'Nitro Cold Brew',
          'description': 'Creamy nitro-infused cold brew',
          'imageUrl': 'https://images.unsplash.com/photo-1498804103079-a6351b050096?w=601',
          'basePrice': 4.50,
          'sizes': {
            'small': {'price': 3.95, 'volumeMl': 240},
            'medium': {'price': 4.75, 'volumeMl': 350},
            'large': {'price': 5.50, 'volumeMl': 470},
          },
          'customizations': {
            'sweetener': ['None', 'Sugar'],
            'ice': ['Light', 'Normal'],
          },
          'isAvailable': true,
          'isFeatured': false,
          'tags': ['nitro', 'smooth'],
          'rating': {'average': 4.5, 'count': 78},
          'pi': 69,
        },
      ],
    },
    {
      'id': 'espresso',
      'name': 'Espresso',
      'description': 'Strong & bold espresso classics',
      'imageUrl': 'https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?w=600',
      'position': 3,
      'isActive': true,
      'products': [
        {
          'id': 'single_espresso',
          'name': 'Single Espresso',
          'description': 'A single shot of intense espresso',
          'imageUrl': 'https://images.unsplash.com/photo-1503481766315-7a586b20f66f?w=600',
          'basePrice': 2.00,
          'sizes': {
            'single': {'price': 2.00, 'volumeMl': 30},
            'double': {'price': 2.75, 'volumeMl': 60},
          },
          'customizations': {
            'sugar': ['None', 'Less', 'Regular'],
            'toppings': {
              'options': [
                {'id': 'lemon_twist', 'label': 'Lemon Twist', 'price': 0.20},
              ],
              'allowMultiple': false,
            },
          },
          'isAvailable': true,
          'isFeatured': false,
          'tags': ['strong'],
          'rating': {'average': 4.2, 'count': 45},
          'pi': 55,
        },
        {
          'id': 'americano',
          'name': 'Americano',
          'description': 'Espresso diluted with hot water',
          'imageUrl': 'https://images.unsplash.com/photo-1470337458703-46ad1756a187?w=600',
          'basePrice': 2.50,
          'sizes': {
            'small': {'price': 2.25, 'volumeMl': 240},
            'medium': {'price': 2.75, 'volumeMl': 350},
            'large': {'price': 3.25, 'volumeMl': 470},
          },
          'customizations': {
            'sweetener': ['None', 'Sugar'],
          },
          'isAvailable': true,
          'isFeatured': false,
          'tags': ['smooth'],
          'rating': {'average': 4.1, 'count': 38},
          'pi': 58,
        },
        {
          'id': 'macchiato',
          'name': 'Macchiato',
          'description': 'Espresso topped with foamed milk',
          'imageUrl': 'https://images.unsplash.com/photo-1517260911058-0fcfd733702f?w=600',
          'basePrice': 2.75,
          'sizes': {
            'single': {'price': 2.75, 'volumeMl': 40},
            'double': {'price': 3.25, 'volumeMl': 70},
          },
          'customizations': {
            'milk': ['Whole', 'Skim'],
          },
          'isAvailable': true,
          'isFeatured': false,
          'tags': ['classic'],
          'rating': {'average': 4.0, 'count': 22},
          'pi': 50,
        },
      ],
    },
    {
      'id': 'tea',
      'name': 'Teas',
      'description': 'Comforting hot teas',
      'imageUrl': 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=600',
      'position': 4,
      'isActive': true,
      'products': [
        {
          'id': 'english_breakfast',
          'name': 'English Breakfast Tea',
          'description': 'Robust black tea blend',
          'imageUrl': 'https://images.unsplash.com/photo-1451743504076-6e7ff6e2cd81?w=600',
          'basePrice': 2.25,
          'sizes': {
            'regular': {'price': 2.25, 'volumeMl': 300},
            'large': {'price': 2.75, 'volumeMl': 420},
          },
          'customizations': {
            'milk': ['None', 'Whole', 'Skim', 'Oat'],
            'sugar': ['None', 'Less', 'Regular'],
          },
          'isAvailable': true,
          'isFeatured': false,
          'tags': ['tea'],
          'rating': {'average': 4.3, 'count': 33},
          'pi': 44,
        },
        {
          'id': 'green_tea',
          'name': 'Green Tea',
          'description': 'Light and refreshing',
          'imageUrl': 'https://images.unsplash.com/photo-1504384308090-c894fdcc538d?w=600',
          'basePrice': 2.25,
          'sizes': {
            'regular': {'price': 2.25, 'volumeMl': 300},
            'large': {'price': 2.75, 'volumeMl': 420},
          },
          'customizations': {
            'sweetener': ['None', 'Honey'],
          },
          'isAvailable': true,
          'isFeatured': false,
          'tags': ['tea'],
          'rating': {'average': 4.2, 'count': 27},
          'pi': 39,
        },
        {
          'id': 'masala_chai',
          'name': 'Masala Chai',
          'description': 'Spiced Indian tea with milk',
          'imageUrl': 'https://images.unsplash.com/photo-1571934811356-5cc061b6821f?w=600',
          'basePrice': 2.75,
          'sizes': {
            'regular': {'price': 2.75, 'volumeMl': 300},
            'large': {'price': 3.25, 'volumeMl': 420},
          },
          'customizations': {
            'milk': ['Full Cream', 'Half Milk'],
            'sugar': ['Less', 'Normal', 'Extra'],
            'toppings': {
              'options': [
                {'id': 'ginger', 'label': 'Extra Ginger', 'price': 0.20},
                {'id': 'cardamom', 'label': 'Extra Cardamom', 'price': 0.25},
              ],
              'allowMultiple': true,
            },
          },
          'isAvailable': true,
          'isFeatured': true,
          'tags': ['tea', 'spiced'],
          'rating': {'average': 4.7, 'count': 210},
          'pi': 93,
        },
      ],
    },
  ];

  for (final cat in categories) {
    final catRef = db.collection('categories').doc(cat['id']);
    await catRef.set({
      'name': cat['name'],
      'description': cat['description'],
      'imageUrl': cat['imageUrl'],
      'position': cat['position'],
      'isActive': cat['isActive'],
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));

    for (final product in (cat['products'] as List)) {
      final prodRef = catRef.collection('products').doc(product['id']);
      await prodRef.set({
        'name': product['name'],
        'description': product['description'],
        'imageUrl': product['imageUrl'],
        'basePrice': product['basePrice'],
        'sizes': product['sizes'],
        'customizations': product['customizations'],
        'isAvailable': product['isAvailable'],
        'isFeatured': product['isFeatured'],
        'tags': product['tags'],
        'rating': product['rating'],
        'pi': product['pi'] ?? 0,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }
  stdout.writeln('Categories & products seeded');
}

Future<void> _seedPromoCodes(FirebaseFirestore db) async {
  final promo = {
    'code': 'WELCOME10',
    'description': '10% off first order',
    'type': 'percent',
    'value': 10,
    'maxDiscount': 5.00,
    'minOrder': 10.00,
    'isActive': true,
    'usageLimitGlobal': 5000,
    'usageLimitPerUser': 1,
    'startsAt': FieldValue.serverTimestamp(),
    'expiresAt': null,
  };
  await db
      .collection('promo_codes')
      .doc('WELCOME10')
      .set(promo, SetOptions(merge: true));
  stdout.writeln('Promo codes seeded');
}

Future<void> _seedConfig(FirebaseFirestore db) async {
  await db.collection('config').doc('app_settings').set({
    'delivery': {
      'baseFee': 1.00,
      'freeDeliveryMin': 25.00,
      'serviceFeePercent': 5,
    },
    'ui': {'showRatings': true},
    'updatedAt': FieldValue.serverTimestamp(),
  }, SetOptions(merge: true));
  stdout.writeln('Config seeded');
}
