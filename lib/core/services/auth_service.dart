import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  AuthService._();
  static final instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential> signIn(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    // Ensure counters exist for legacy users
    await _ensureUserDoc(
      uid: cred.user!.uid,
      data: {'ordersCount': 0, 'points': 0, 'rewardsCount': 0},
    );
    return cred;
  }

  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
    String? phone,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    await credential.user?.updateDisplayName(name.trim());
    await _ensureUserDoc(
      uid: credential.user!.uid,
      data: {
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone?.trim(),
        'createdAt': FieldValue.serverTimestamp(),
        'roles': ['user'],
        'ordersCount': 0,
        'points': 0,
        'rewardsCount': 0,
      },
    );
    return credential;
  }

  Future<void> signOut() => _auth.signOut();

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = currentUser;
    if (user == null) return null;

    try {
      final doc = await _db.collection('users').doc(user.uid).get();
      return doc.exists ? doc.data() : null;
    } catch (e) {
      print('Error getting user data: $e');
      return null;
    }
  }

  Future<String> getCurrentUserName() async {
    final userData = await getCurrentUserData();
    return userData?['name'] ?? currentUser?.displayName ?? 'User';
  }

  Future<void> _ensureUserDoc({
    required String uid,
    required Map<String, dynamic> data,
  }) async {
    final ref = _db.collection('users').doc(uid);
    await _db.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (!snap.exists) {
        tx.set(ref, data);
      } else {
        tx.update(ref, {
          for (final e in data.entries)
            if (!snap.data()!.containsKey(e.key)) e.key: e.value,
        });
      }
    });
  }

  Future<void> seedSampleUsers() async {
    if (!kDebugMode) return;
    final samples = [
      {
        'email': 'test1@example.com',
        'password': 'password123',
        'name': 'Test User One',
        'phone': '1234567890',
      },
      {
        'email': 'barista@example.com',
        'password': 'coffee123',
        'name': 'Barista Demo',
        'phone': '0987654321',
      },
      // Requested sample user
      {
        'email': 'jahid@gmail.com',
        'password': '123456',
        'name': 'Jahid Hasan',
        'phone': '',
      },
    ];
    final original = _auth.currentUser;
    for (final u in samples) {
      try {
        await _auth.signInWithEmailAndPassword(
          email: u['email']!,
          password: u['password']!,
        );
        await _ensureUserDoc(
          uid: _auth.currentUser!.uid,
          data: {
            'name': u['name'],
            'email': u['email'],
            'phone': u['phone'],
            'createdAt': FieldValue.serverTimestamp(),
            'roles': ['user'],
            'ordersCount': 0,
            'points': 0,
            'rewardsCount': 0,
          },
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          final cred = await _auth.createUserWithEmailAndPassword(
            email: u['email']!,
            password: u['password']!,
          );
          await cred.user?.updateDisplayName(u['name']);
          await _ensureUserDoc(
            uid: cred.user!.uid,
            data: {
              'name': u['name'],
              'email': u['email'],
              'phone': u['phone'],
              'createdAt': FieldValue.serverTimestamp(),
              'roles': ['user'],
              'ordersCount': 0,
              'points': 0,
              'rewardsCount': 0,
            },
          );
        }
      } finally {
        await _auth.signOut();
      }
    }
    if (original != null) {
      // can't silently restore without password; leave signed out
    }
  }
}
