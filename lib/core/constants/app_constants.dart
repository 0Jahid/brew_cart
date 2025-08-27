class AppConstants {
  // App Info
  static const String appName = 'BrewCart';
  static const String appVersion = '1.0.0';

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String coffeeCollection = 'coffees';
  static const String ordersCollection = 'orders';
  static const String categoriesCollection = 'categories';

  // Storage Paths
  static const String coffeeImagesPath = 'coffee_images';
  static const String userAvatarsPath = 'user_avatars';

  // Shared Preferences Keys
  static const String userIdKey = 'user_id';
  static const String isLoggedInKey = 'is_logged_in';
  static const String themeKey = 'theme';

  // Order Status
  static const String orderPending = 'pending';
  static const String orderConfirmed = 'confirmed';
  static const String orderPreparing = 'preparing';
  static const String orderReady = 'ready';
  static const String orderCompleted = 'completed';
  static const String orderCancelled = 'cancelled';

  // Coffee Sizes
  static const String sizeSmall = 'Small';
  static const String sizeMedium = 'Medium';
  static const String sizeLarge = 'Large';

  // Sugar Levels
  static const String sugarNone = 'No Sugar';
  static const String sugarLow = 'Low Sugar';
  static const String sugarMedium = 'Medium Sugar';
  static const String sugarHigh = 'High Sugar';

  // Temperature
  static const String tempHot = 'Hot';
  static const String tempIced = 'Iced';
}
