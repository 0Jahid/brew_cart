import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  static const String _publishableKey =
      'pk_test_51S98W9FDsIpVdvUpyNmQcqfHaJgMNsEOzAE9F0VINxIU0LpLnLIhDTlHlxwlAQ3y7b3VwajkLLF8sTrD3LGqwc3l00jJ4O7Q7J';

  static Future<void> init() async {
    Stripe.publishableKey = _publishableKey;
    await Stripe.instance.applySettings();
  }

  /// Create a payment intent on your backend
  static Future<Map<String, dynamic>> createPaymentIntent({
    required String amount, // Amount in cents (e.g., 1000 = $10.00)
    required String currency,
    List<String>? paymentMethodTypes,
  }) async {
    try {
      // In a real app, this would be your backend endpoint
      // For testing, we'll simulate the backend call

      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types': paymentMethodTypes ?? ['card'],
      };

      // This is a mock response - in real implementation,
      // you would call your backend which creates the payment intent
      final response = await _createMockPaymentIntent(body);

      return response;
    } catch (err) {
      throw Exception('Error creating payment intent: $err');
    }
  }

  /// Mock backend response for payment intent creation
  /// In production, replace this with actual backend call
  static Future<Map<String, dynamic>> _createMockPaymentIntent(
    Map<String, dynamic> body,
  ) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock payment intent response
    return {
      'id': 'pi_mock_${DateTime.now().millisecondsSinceEpoch}',
      'client_secret':
          'pi_mock_${DateTime.now().millisecondsSinceEpoch}_secret_mock',
      'amount': body['amount'],
      'currency': body['currency'],
      'status': 'requires_payment_method',
    };
  }

  /// Process payment using Stripe Payment Sheet
  static Future<Map<String, dynamic>> processPayment({
    required String clientSecret,
    required String merchantDisplayName,
  }) async {
    try {
      // Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: merchantDisplayName,
          style: ThemeMode.system,
          billingDetails: const BillingDetails(
            name: 'Brew Cart Customer',
            email: 'customer@brewcart.com',
          ),
        ),
      );

      // Present the payment sheet
      await Stripe.instance.presentPaymentSheet();

      return {'status': 'success', 'message': 'Payment completed successfully'};
    } on StripeException catch (e) {
      return {
        'status': 'error',
        'message': e.error.localizedMessage ?? 'Payment failed',
        'code': e.error.code,
      };
    } catch (e) {
      return {'status': 'error', 'message': 'An unexpected error occurred: $e'};
    }
  }

  /// Convert amount to cents for Stripe
  static String amountToCents(double amount) {
    return (amount * 100).round().toString();
  }

  /// Convert cents back to readable amount
  static double centsToAmount(String cents) {
    return int.parse(cents) / 100;
  }

  /// Get test card numbers for testing
  static Map<String, String> getTestCards() {
    return {
      'Visa': '4242424242424242',
      'Visa (debit)': '4000056655665556',
      'Mastercard': '5555555555554444',
      'Mastercard (debit)': '5200828282828210',
      'American Express': '378282246310005',
      'Declined': '4000000000000002',
      'Insufficient funds': '4000000000009995',
    };
  }
}
