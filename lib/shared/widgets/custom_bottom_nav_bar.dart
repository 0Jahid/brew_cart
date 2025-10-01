import 'package:brew_cart/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: currentIndex,
      backgroundColor: AppColors.primary,
      color: AppColors.secondaryLight,
      buttonBackgroundColor: AppColors.secondary,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 600),
      height: 60,
      items: <Widget>[
        _buildNavIcon('assets/icons/home.svg'),
        _buildNavIcon('assets/icons/shopping_bag.svg'),
        _buildNavIcon('assets/icons/poi.svg'),
        _buildNavIcon('assets/icons/person.svg'),
      ],
      onTap: onTap,
    );
  }

  Widget _buildNavIcon(String iconPath) {
    return SvgPicture.asset(
      iconPath,
      width: 26,
      height: 26,
      colorFilter: const ColorFilter.mode(Colors.black87, BlendMode.srcIn),
    );
  }
}
