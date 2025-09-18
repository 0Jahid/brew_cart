import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  String selectedSize = 'Regular';
  String selectedSugar = 'Normal Sugar';
  String selectedIce = 'No Ice';
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F8F8),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Custom orders',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 37),

                    // Coffee Item Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 4,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          // Coffee Image
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.coffee,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),

                          // Coffee Name
                          const Expanded(
                            child: Text(
                              'Cappuccino',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1C1310),
                                fontFamily: 'Inter',
                              ),
                            ),
                          ),

                          // Price
                          const Text(
                            '৳5.20',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFC67C4E),
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 22),

                    // Size Selection
                    _buildOptionCard(
                      title: 'Size',
                      options: ['Small', 'Regular', 'Large'],
                      selectedOption: selectedSize,
                      onOptionSelected: (option) {
                        setState(() {
                          selectedSize = option;
                        });
                      },
                    ),

                    const SizedBox(height: 22),

                    // Sugar Selection
                    _buildOptionCard(
                      title: 'Sugar',
                      options: ['Normal Sugar', 'Less Sugar', 'No Sugar'],
                      selectedOption: selectedSugar,
                      onOptionSelected: (option) {
                        setState(() {
                          selectedSugar = option;
                        });
                      },
                    ),

                    const SizedBox(height: 22),

                    // Ice Selection
                    _buildOptionCard(
                      title: 'Ice',
                      options: ['Normal Ice', 'Less Ice', 'No Ice'],
                      selectedOption: selectedIce,
                      onOptionSelected: (option) {
                        setState(() {
                          selectedIce = option;
                        });
                      },
                    ),

                    const SizedBox(height: 37),
                  ],
                ),
              ),
            ),

            // Bottom Section with Quantity and Add Order Button
            Container(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                children: [
                  // Quantity Control
                  Container(
                    height: 69,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 20,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 4,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },
                          child: Container(
                            width: 29,
                            height: 28,
                            decoration: BoxDecoration(
                              color: quantity > 1
                                  ? const Color(0xFFC67C4E)
                                  : Colors.grey[300],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.remove,
                              color: quantity > 1
                                  ? Colors.white
                                  : Colors.grey[600],
                              size: 16,
                            ),
                          ),
                        ),
                        const SizedBox(width: 19),
                        Text(
                          quantity.toString(),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                        const SizedBox(width: 19),
                        GestureDetector(
                          onTap: () {
                            setState(() {
                              quantity++;
                            });
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: const BoxDecoration(
                              color: Color(0xFFC67C4E),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Add Order Button
                  Expanded(
                    child: Container(
                      height: 69,
                      decoration: BoxDecoration(
                        color: const Color(0xFFC67C4E),
                        borderRadius: BorderRadius.circular(46),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            // Handle add to cart
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Added $quantity Cappuccino ($selectedSize, $selectedSugar, $selectedIce) to cart!',
                                ),
                                backgroundColor: const Color(0xFFC67C4E),
                                duration: const Duration(seconds: 3),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(46),
                          child: const Center(
                            child: Text(
                              'Add Order',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                                letterSpacing: 0.8,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard({
    required String title,
    required List<String> options,
    required String selectedOption,
    required Function(String) onOptionSelected,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFB9B9B9),
                  fontFamily: 'Montserrat',
                ),
              ),
              const Text(
                'Mandatory Select one',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFC67C4E),
                  fontFamily: 'Montserrat',
                ),
              ),
            ],
          ),

          const SizedBox(height: 23),

          // Options
          Column(
            children: options.asMap().entries.map((entry) {
              int index = entry.key;
              String option = entry.value;
              bool isSelected = option == selectedOption;

              return Column(
                children: [
                  GestureDetector(
                    onTap: () => onOptionSelected(option),
                    child: Container(
                      width: double.infinity,
                      height: 17,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            option,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.black,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                          Container(
                            width: 16,
                            height: 16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? const Color(0xFFC67C4E)
                                  : Colors.transparent,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFFC67C4E)
                                    : Colors.grey[400]!,
                                width: 2,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.circle,
                                    size: 8,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (index < options.length - 1) ...[
                    const SizedBox(height: 9),
                    Container(
                      height: 1,
                      width: double.infinity,
                      color: Colors.grey[200],
                    ),
                    const SizedBox(height: 14),
                  ],
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
