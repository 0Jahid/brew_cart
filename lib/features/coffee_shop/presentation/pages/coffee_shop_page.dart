import 'package:flutter/material.dart';
import '../../../../shared/widgets/custom_app_bar.dart';
import '../../../../shared/widgets/custom_bottom_nav_bar.dart';
import '../tabs/home_tab.dart';
import '../tabs/orders_tab.dart';
import '../tabs/history_tab.dart';
import '../tabs/profile_tab.dart';

// Thin orchestrator page: delegates actual UI to individual tab widgets.
class CoffeeShopPage extends StatefulWidget {
  const CoffeeShopPage({super.key});
  @override
  State<CoffeeShopPage> createState() => _CoffeeShopPageState();
}

class _CoffeeShopPageState extends State<CoffeeShopPage> {
  int _selectedIndex = 0;
  void _setIndex(int i) => setState(() => _selectedIndex = i);

  Widget _body() => switch (_selectedIndex) {
    0 => const HomeTab(),
    1 => OrdersTab(onBack: () => _setIndex(0)),
    2 => HistoryTab(onBack: () => _setIndex(0)),
    3 => ProfileTab(onBack: () => _setIndex(0)),
    _ => const SizedBox.shrink(),
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _selectedIndex == 0
          ? CustomAppBar(
              userName: 'Jahid',
              location: 'Dhaka, Bangladesh',
              onNotificationPressed: () {},
              onLocationPressed: () {},
            )
          : null,
      body: _body(),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _setIndex,
      ),
      extendBody: true,
    );
  }
}
