import 'package:flutter/material.dart';

class PaymentResultDialog extends StatelessWidget {
  final bool isSuccess;
  final double amount;
  final Map<String, String>? cardDetails;
  final String? errorMessage;
  final VoidCallback onDismiss;

  const PaymentResultDialog({
    super.key,
    required this.isSuccess,
    required this.amount,
    this.cardDetails,
    this.errorMessage,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Success/Failure Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSuccess ? Colors.green[100] : Colors.red[100],
            ),
            child: Icon(
              isSuccess ? Icons.check_circle : Icons.error,
              size: 50,
              color: isSuccess ? Colors.green : Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          
          // Title
          Text(
            isSuccess ? 'Payment Successful!' : 'Payment Failed',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isSuccess ? Colors.green : Colors.red,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // Amount
          Text(
            '৳${amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFFC67C4E),
            ),
          ),
          const SizedBox(height: 16),
          
          if (isSuccess && cardDetails != null) ...[
            // Success details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green[200]!),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Card:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text('${cardDetails!['brand']} •••• ${cardDetails!['last4']}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Cardholder:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(cardDetails!['name'] ?? ''),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Transaction ID:',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      Text(
                        'txn_${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
                        style: const TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Your order has been placed successfully!\nYou will receive a confirmation email shortly.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ] else if (!isSuccess) ...[
            // Error details
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.warning_amber,
                    color: Colors.red[600],
                    size: 32,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    errorMessage ?? 'An unknown error occurred',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.red[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Please check your card details and try again.\nIf the problem persists, contact your bank.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ],
      ),
      actions: [
        if (!isSuccess) ...[
          TextButton(
            onPressed: onDismiss,
            child: const Text('Try Again'),
          ),
          const SizedBox(width: 8),
        ],
        ElevatedButton(
          onPressed: onDismiss,
          style: ElevatedButton.styleFrom(
            backgroundColor: isSuccess ? Colors.green : const Color(0xFFC67C4E),
            foregroundColor: Colors.white,
            minimumSize: const Size(120, 40),
          ),
          child: Text(isSuccess ? 'Continue' : 'Close'),
        ),
      ],
    );
  }
}