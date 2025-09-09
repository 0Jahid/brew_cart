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
