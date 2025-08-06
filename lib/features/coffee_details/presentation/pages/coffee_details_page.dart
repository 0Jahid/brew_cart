import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class CoffeeDetailsPage extends StatelessWidget {
  final String coffeeId;

  const CoffeeDetailsPage({
    super.key,
    required this.coffeeId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.coffee,
              size: 100,
              color: AppColors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Coffee Details Page',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Coffee ID: $coffeeId',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Coming Soon...',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
