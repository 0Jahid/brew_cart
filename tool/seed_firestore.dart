// Run with: dart run tool/seed_firestore.dart
// Make sure you have run `flutterfire configure` so firebase_options.dart exists.

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// Adjust the path if your firebase_options.dart is elsewhere
import 'package:brew_cart/firebase_options.dart';

Future<void> main(List<String> args) async {
  final dryRun = args.contains('--dry-run');
  stdout.writeln('== BrewCart Firestore Seeder ==');
  stdout.writeln('Dry run: $dryRun');

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final fs = FirebaseFirestore.instance;
  // (Optional) speed up batch writes
  fs.settings = const Settings(persistenceEnabled: true);

  // Data definitions
  final categories = <Map<String, dynamic>>[
    {
      'id': 'espresso',
      'name': 'Espresso',
      'description': 'Rich and bold coffee shots',
      'imageUrl': 'https://example.com/espresso.jpg',
      'isActive': true,
      'order': 1,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'id': 'latte',
      'name': 'Latte',
      'description': 'Smooth coffee with steamed milk',
      'imageUrl': 'https://example.com/latte.jpg',
      'isActive': true,
      'order': 2,
      'createdAt': FieldValue.serverTimestamp(),
    },
    {
      'id': 'cappuccino',
      'name': 'Cappuccino',
      'description': 'Coffee with frothy milk foam',
      'imageUrl': 'https://example.com/cappuccino.jpg',
      'isActive': true,
      'order': 3,
      'createdAt': FieldValue.serverTimestamp(),
    },
  ];

  final coffees = <Map<String, dynamic>>[
    {
      'id': 'classic_americano',
      'name': 'Classic Americano',
      'description': 'Rich espresso with hot water',
      'category': 'espresso', // link to category id
      'basePrice': 3.50,
      'imageUrl': 'https://example.com/americano.jpg',
      'ingredients': ['Espresso', 'Hot Water'],
      'rating': 4.5,
      'reviewCount': 128,
      'isPopular': true,
      'isFeatured': false,
      'sizePrices': {
        'Small': 3.50,
        'Medium': 4.00,
        'Large': 4.50,
      },
      'availableSizes': ['Small', 'Medium', 'Large'],
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    },
  ];

  Future<void> seedCollection({
    required String name,
    required List<Map<String, dynamic>> docs,
  }) async {
    stdout.writeln('-- Seeding $name (${docs.length})');
    final batch = fs.batch();
    var writes = 0;
    for (final doc in docs) {
      final id = doc['id'] as String? ?? fs.collection(name).doc().id;
      final ref = fs.collection(name).doc(id);
      final snap = await ref.get();
      if (snap.exists) {
        stdout.writeln('   Skipping existing doc: $id');
        continue;
      }
      if (dryRun) {
        stdout.writeln('   Would create: $id');
        continue;
      }
      batch.set(ref, Map<String, dynamic>.from(doc)..remove('id'));
      writes++;
      if (writes == 450) { // safety flush before 500 limit
        await batch.commit();
        stdout.writeln('   Committed 450 writes chunk');
        writes = 0;
      }
    }
    if (!dryRun && writes > 0) {
      await batch.commit();
      stdout.writeln('   Committed final $writes writes');
    }
  }

  try {
    await seedCollection(name: 'categories', docs: categories);
    await seedCollection(name: 'coffees', docs: coffees);
    stdout.writeln('== Seeding complete ==');
  } catch (e, st) {
    stderr.writeln('Error seeding: $e');
    stderr.writeln(st);
    exitCode = 1;
  }
}
