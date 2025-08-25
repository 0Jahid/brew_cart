// Backend removed: UI-only stubs for AuthService

class User {
  final String id;
  final String email;
  const User({required this.id, required this.email});
}

abstract class AuthService {
  Future<User> signInWithEmailAndPassword(String email, String password);
  Future<User> signUpWithEmailAndPassword(String email, String password, String fullName, String? phoneNumber);
  Future<void> signOut();
  Future<void> sendPasswordResetEmail(String email);
  User? get currentUser;
  Stream<User?> get authStateChanges;
}

/// Dummy implementation for UI-only runs
class DummyAuthService implements AuthService {
  User? _user;

  @override
  User? get currentUser => _user;

  @override
  Stream<User?> get authStateChanges async* {
    yield _user;
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _user = User(id: 'demo_user', email: email);
    return _user!;
  }

  @override
  Future<User> signUpWithEmailAndPassword(String email, String password, String fullName, String? phoneNumber) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _user = User(id: 'demo_user', email: email);
    return _user!;
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<void> signOut() async {
    _user = null;
  }
}
