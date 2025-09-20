import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CardDetailsDialog extends StatefulWidget {
  final double amount;
  final Function(bool success, Map<String, String>? cardDetails, String? errorMessage) onComplete;

  const CardDetailsDialog({
    super.key,
    required this.amount,
    required this.onComplete,
  });

  @override
  State<CardDetailsDialog> createState() => _CardDetailsDialogState();
}

class _CardDetailsDialogState extends State<CardDetailsDialog> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvcController = TextEditingController();
  final _nameController = TextEditingController();
  
  bool _isProcessing = false;

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvcController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  String _formatCardNumber(String value) {
    value = value.replaceAll(' ', '');
    String formatted = '';
    for (int i = 0; i < value.length; i++) {
      if (i > 0 && i % 4 == 0) {
        formatted += ' ';
      }
      formatted += value[i];
    }
    return formatted;
  }

  String _formatExpiry(String value) {
    value = value.replaceAll('/', '');
    if (value.length >= 2) {
      return '${value.substring(0, 2)}/${value.substring(2)}';
    }
    return value;
  }

  bool _validateCard() {
    final cardNumber = _cardNumberController.text.replaceAll(' ', '');
    final expiry = _expiryController.text;
    final cvc = _cvcController.text;
    final name = _nameController.text.trim();

    if (cardNumber.length < 13 || cardNumber.length > 19) {
      _showError('Please enter a valid card number');
      return false;
    }

    if (!expiry.contains('/') || expiry.length != 5) {
      _showError('Please enter a valid expiry date (MM/YY)');
      return false;
    }

    final parts = expiry.split('/');
    final month = int.tryParse(parts[0]) ?? 0;
    final year = int.tryParse(parts[1]) ?? 0;
    
    if (month < 1 || month > 12) {
      _showError('Please enter a valid month (01-12)');
      return false;
    }

    final now = DateTime.now();
    final currentYear = now.year % 100;
    final currentMonth = now.month;
    
    if (year < currentYear || (year == currentYear && month < currentMonth)) {
      _showError('Card has expired');
      return false;
    }

    if (cvc.length < 3 || cvc.length > 4) {
      _showError('Please enter a valid CVC');
      return false;
    }

    if (name.isEmpty) {
      _showError('Please enter the cardholder name');
      return false;
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Future<void> _processPayment() async {
    if (!_validateCard()) return;

    setState(() => _isProcessing = true);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      final cardNumber = _cardNumberController.text.replaceAll(' ', '');
      
      // Simulate success/failure based on test card numbers
      bool isSuccess = false;
      String? errorMessage;

      if (cardNumber == '4242424242424242') {
        // Stripe test card - success
        isSuccess = true;
      } else if (cardNumber == '4000000000000002') {
        // Stripe test card - declined
        errorMessage = 'Your card was declined';
      } else if (cardNumber == '4000000000009995') {
        // Stripe test card - insufficient funds
        errorMessage = 'Your card has insufficient funds';
      } else if (cardNumber == '4000000000000069') {
        // Stripe test card - expired
        errorMessage = 'Your card has expired';
      } else if (cardNumber == '4000000000000127') {
        // Stripe test card - incorrect CVC
        errorMessage = 'Your card\'s security code is incorrect';
      } else {
        // For other cards, simulate random success/failure
        isSuccess = DateTime.now().millisecondsSinceEpoch % 2 == 0;
        if (!isSuccess) {
          errorMessage = 'Payment failed. Please try again.';
        }
      }

      final cardDetails = isSuccess ? {
        'last4': cardNumber.substring(cardNumber.length - 4),
        'brand': _getCardBrand(cardNumber),
        'expiry': _expiryController.text,
        'name': _nameController.text,
      } : null;

      widget.onComplete(isSuccess, cardDetails, errorMessage);
      
    } catch (e) {
      widget.onComplete(false, null, 'An error occurred: $e');
    }

    setState(() => _isProcessing = false);
  }

  String _getCardBrand(String cardNumber) {
    if (cardNumber.startsWith('4')) return 'Visa';
    if (cardNumber.startsWith('5')) return 'Mastercard';
    if (cardNumber.startsWith('3')) return 'American Express';
    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Enter Card Details'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Amount: ৳${widget.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFC67C4E),
                ),
              ),
              const SizedBox(height: 20),
              
              // Card Number
              TextFormField(
                controller: _cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  hintText: '1234 5678 9012 3456',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.credit_card),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(19),
                  TextInputFormatter.withFunction((oldValue, newValue) {
                    return TextEditingValue(
                      text: _formatCardNumber(newValue.text),
                      selection: TextSelection.collapsed(
                        offset: _formatCardNumber(newValue.text).length,
                      ),
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),
              
              Row(
                children: [
                  // Expiry Date
                  Expanded(
                    child: TextFormField(
                      controller: _expiryController,
                      decoration: const InputDecoration(
                        labelText: 'MM/YY',
                        hintText: '12/28',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        TextInputFormatter.withFunction((oldValue, newValue) {
                          return TextEditingValue(
                            text: _formatExpiry(newValue.text),
                            selection: TextSelection.collapsed(
                              offset: _formatExpiry(newValue.text).length,
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  
                  // CVC
                  Expanded(
                    child: TextFormField(
                      controller: _cvcController,
                      decoration: const InputDecoration(
                        labelText: 'CVC',
                        hintText: '123',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.lock),
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      obscureText: true,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Cardholder Name
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                  hintText: 'John Doe',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 20),
              
              // Test Cards Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue[200]!),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Test Cards:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text('4242 4242 4242 4242 - Success', style: TextStyle(fontSize: 12)),
                    Text('4000 0000 0000 0002 - Declined', style: TextStyle(fontSize: 12)),
                    Text('4000 0000 0000 9995 - Insufficient funds', style: TextStyle(fontSize: 12)),
                    Text('Use any future date and any 3-digit CVC', style: TextStyle(fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isProcessing ? null : () {
            widget.onComplete(false, null, 'Payment cancelled');
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isProcessing ? null : _processPayment,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC67C4E),
            foregroundColor: Colors.white,
          ),
          child: _isProcessing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text('Pay Now'),
        ),
      ],
    );
  }
}