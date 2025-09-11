import 'package:flutter/foundation.dart';

/// Global tab index controller for CoffeeShopPage so deep routes (e.g. custom order)
/// can switch tabs (e.g. jump to Orders) before popping back.
final ValueNotifier<int> coffeeShopTabIndex = ValueNotifier<int>(0);

void setCoffeeShopTab(int index) {
  if (index < 0) return;
  if (coffeeShopTabIndex.value != index) {
    coffeeShopTabIndex.value = index;
  }
}
