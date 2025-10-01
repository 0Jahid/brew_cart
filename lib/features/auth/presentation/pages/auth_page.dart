import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/services/auth_service.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Duration get _loginTime => const Duration(milliseconds: 1500);

  Future<String?> _authUser(LoginData data) async {
    try {
      await Future.delayed(_loginTime);
      await AuthService.instance.signIn(data.name, data.password);
      return null; // Success
    } catch (e) {
      final errorMessage = _mapError(e);
      // Show error dialog after a short delay to ensure UI is ready
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _showErrorDialog(errorMessage);
        }
      });
      return null; // Return null to prevent flutter_login from showing its own error
    }
  }

  Future<String?> _signupUser(SignupData data) async {
    try {
      await Future.delayed(_loginTime);

      // Debug print to see what data we're getting
      print('Signup data: ${data.additionalSignupData}');

      final name = data.additionalSignupData?['name'] ?? '';
      final phone = data.additionalSignupData?['phone'] ?? '';

      if (name.isEmpty) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _showErrorDialog('Full name is required');
          }
        });
        return null;
      }
      if (phone.isEmpty) {
        Future.delayed(const Duration(milliseconds: 100), () {
          if (mounted) {
            _showErrorDialog('Phone number is required');
          }
        });
        return null;
      }

      await AuthService.instance.signUp(
        name: name,
        email: data.name!,
        password: data.password!,
        phone: phone,
      );
      return null; // Success
    } catch (e) {
      final errorMessage = _mapError(e);
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _showErrorDialog(errorMessage);
        }
      });
      return null; // Return null to prevent flutter_login from showing its own error
    }
  }

  Future<String?> _recoverPassword(String email) async {
    try {
      await Future.delayed(_loginTime);
      // TODO: Implement password recovery
      return null; // Success - will show success message
    } catch (e) {
      final errorMessage = _mapError(e);
      Future.delayed(const Duration(milliseconds: 100), () {
        if (mounted) {
          _showErrorDialog(errorMessage);
        }
      });
      return null; // Return null to prevent flutter_login from showing its own error
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.error_outline, color: Colors.red[600], size: 28),
              const SizedBox(width: 12),
              const Text(
                'Authentication Error',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          ),
          content: Text(message, style: const TextStyle(fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        );
      },
    );
  }

  String _mapError(Object e) {
    final s = e.toString();
    if (s.contains('user-not-found')) return 'User not found';
    if (s.contains('wrong-password')) return 'Wrong password';
    if (s.contains('email-already-in-use')) return 'Email already in use';
    if (s.contains('weak-password')) return 'Password too weak';
    if (s.contains('invalid-email')) return 'Invalid email format';
    return 'Authentication failed. Please try again.';
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'Brew Cart',
      onLogin: _authUser,
      onSignup: _signupUser,
      onRecoverPassword: _recoverPassword,
      onSubmitAnimationCompleted: () {
        context.go(AppRouter.home);
      },
      // Enable morph transition animation
      navigateBackAfterRecovery: true,
      hideForgotPasswordButton: false,
      loginAfterSignUp: true,
      scrollable: true,
      // Additional configuration for better animations
      termsOfService: [],
      savedEmail: '',
      savedPassword: '',
      userType: LoginUserType.name,
      additionalSignupFields: [
        UserFormField(
          keyName: 'name',
          displayName: 'Full Name',
          fieldValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your full name';
            }
            return null;
          },
          icon: const Icon(Icons.person),
        ),
        UserFormField(
          keyName: 'phone',
          displayName: 'Phone Number',
          fieldValidator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter your phone number';
            }
            return null;
          },
          icon: const Icon(Icons.phone),
        ),
      ],
      theme: LoginTheme(
        primaryColor: AppColors.primary,
        accentColor: AppColors.accent,
        pageColorLight: const Color(0xFFF5F5F5),
        titleStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.bold,
          fontSize: 28,
        ),
        bodyStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 16,
        ),
        buttonTheme: LoginButtonTheme(
          backgroundColor: AppColors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        // Card styling for better morph animation visibility
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          clipBehavior: Clip.antiAlias,
        ),
        // Input styling
        inputTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8F9FA),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
      messages: LoginMessages(
        userHint: 'Email',
        passwordHint: 'Password',
        confirmPasswordHint: 'Confirm Password',
        loginButton: 'LOGIN',
        signupButton: 'SIGN UP',
        forgotPasswordButton: 'Forgot Password?',
        recoverPasswordButton: 'RECOVER',
        goBackButton: 'BACK',
        confirmPasswordError: 'Passwords do not match',
        additionalSignUpFormDescription: 'Please complete your profile',
        additionalSignUpSubmitButton: 'CREATE ACCOUNT',
      ),
      // Add a centered header widget for better visual appeal
      headerWidget: Container(
        height: 120,
        child: Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(Icons.coffee, size: 40, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
