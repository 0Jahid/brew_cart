import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class PopularCoffeeItem extends StatefulWidget {
  final String name;
  final String size;
  final double price;
  final VoidCallback? onAddPressed;
  final VoidCallback? onRemovePressed;
  final VoidCallback? onTap;

  const PopularCoffeeItem({
    super.key,
    required this.name,
    required this.size,
    required this.price,
    this.onAddPressed,
    this.onRemovePressed,
    this.onTap,
  });

  @override
  State<PopularCoffeeItem> createState() => _PopularCoffeeItemState();
}

class _PopularCoffeeItemState extends State<PopularCoffeeItem> {
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            // Coffee Image Placeholder
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.coffee, color: Colors.grey, size: 30),
            ),

            const SizedBox(width: 16),

            // Coffee Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Size : ${widget.size}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '৳${widget.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),

            // Quantity Controls
            Row(
              children: [
                // Remove Button
                GestureDetector(
                  onTap: () {
                    if (quantity > 0) {
                      setState(() {
                        quantity--;
                      });
                      widget.onRemovePressed?.call();
                    }
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: quantity > 0 ? Colors.grey[400] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.remove,
                      color: quantity > 0 ? Colors.white : Colors.grey[500],
                      size: 18,
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Add Button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      quantity++;
                    });
                    widget.onAddPressed?.call();
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
