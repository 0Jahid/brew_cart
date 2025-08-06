# BrewCart - Coffee Ordering App

A Flutter coffee ordering app with Firebase backend, implementing clean architecture principles.

## 🏗️ Project Structure

```
lib/
├── core/                           # Core functionality
│   ├── constants/                  # App constants (colors, strings, etc.)
│   ├── errors/                     # Error handling (exceptions, failures)
│   ├── network/                    # Network configuration
│   ├── router/                     # App routing configuration
│   ├── usecases/                   # Base use case classes
│   └── utils/                      # Utility functions (validators, helpers)
├── features/                       # Feature modules
│   ├── splash/                     # Splash screen
│   ├── auth/                       # Authentication (login/register)
│   ├── coffee_shop/                # Main coffee shop screen
│   ├── coffee_details/             # Coffee details screen
│   ├── customization/              # Order customization
│   ├── checkout/                   # Checkout process
│   ├── order_tracking/             # Order tracking
│   └── profile/                    # User profile
└── shared/                         # Shared components
    ├── theme/                      # App theme configuration
    ├── widgets/                    # Reusable widgets
    └── services/                   # Shared services
```

## 🎯 Features

### ✅ Implemented
- [x] Clean Architecture structure
- [x] Splash screen with app branding
- [x] Login/Register screens with validation
- [x] App routing with GoRouter
- [x] Custom theme with coffee-inspired colors
- [x] Reusable custom widgets (buttons, text fields)
- [x] Project structure following clean architecture

### 🚧 In Progress
- [ ] Firebase Authentication integration
- [ ] Coffee shop main screen with categories
- [ ] Coffee details screen with customization options
- [ ] Shopping cart functionality
- [ ] Order checkout process
- [ ] Order tracking system
- [ ] User profile management

### 📋 Planned
- [ ] Firebase Firestore integration for coffee data
- [ ] Image caching and optimization
- [ ] Push notifications for order updates
- [ ] Payment integration
- [ ] Order history
- [ ] User preferences and favorites
- [ ] Search and filter functionality
- [ ] Reviews and ratings system

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **State Management**: Flutter Bloc
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Routing**: GoRouter
- **Architecture**: Clean Architecture
- **UI**: Material Design 3
- **Dependencies**: 
  - `flutter_bloc` - State management
  - `firebase_core`, `firebase_auth`, `cloud_firestore` - Firebase services
  - `go_router` - Navigation
  - `dartz` - Functional programming
  - `get_it`, `injectable` - Dependency injection
  - `cached_network_image` - Image caching
  - `shared_preferences` - Local storage

## 🎨 Design

The app follows a coffee-themed design with:
- **Primary Color**: Coffee Brown (#8B4513)
- **Secondary Color**: Burlywood (#DEB887)
- **Accent Color**: Orange (#D2691E)
- **Background**: Ivory (#FFFFF8)

## 🚀 Getting Started

1. **Install Dependencies**:
   ```bash
   flutter pub get
   ```

2. **Run the App**:
   ```bash
   flutter run
   ```

3. **Firebase Setup** (Next Steps):
   - Create a Firebase project
   - Add Android/iOS apps to Firebase
   - Download configuration files
   - Enable Authentication and Firestore

## 📱 Screens Flow

1. **Splash Screen** → Auto-navigates to Login
2. **Login/Register** → Navigate to Coffee Shop
3. **Coffee Shop** → Browse coffee with bottom navigation
4. **Coffee Details** → View coffee details and customize
5. **Customization** → Select size, sugar, temperature
6. **Checkout** → Review order and payment
7. **Order Tracking** → Track order status
8. **Profile** → User account management

## 🏛️ Architecture Layers

### Domain Layer
- **Entities**: Core business objects (User, Coffee, Order, OrderItem)
- **Repositories**: Abstract interfaces for data operations
- **Use Cases**: Business logic implementation

### Data Layer
- **Models**: Data transfer objects with JSON serialization
- **Data Sources**: Remote (Firebase) and local data sources
- **Repository Implementation**: Concrete repository implementations

### Presentation Layer
- **Pages**: UI screens
- **Bloc**: State management for each feature
- **Widgets**: Reusable UI components

## 🔄 Next Development Steps

1. **Firebase Integration**:
   - Setup Firebase project
   - Implement authentication services
   - Create Firestore collections for coffee data

2. **Coffee Shop Screen**:
   - Implement coffee list with categories
   - Add search and filter functionality
   - Create coffee cards with images

3. **State Management**:
   - Create Bloc classes for each feature
   - Implement proper state management patterns

4. **API Integration**:
   - Create repository implementations
   - Implement data sources for Firebase

5. **UI Enhancement**:
   - Add animations and micro-interactions
   - Implement proper loading states
   - Add error handling UI

## 📝 Code Standards

- Follow Flutter best practices
- Use meaningful variable and function names
- Implement proper error handling
- Write documentation for complex functions
- Follow clean architecture principles
- Use dependency injection pattern

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Follow the existing code structure
4. Write tests for new features
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.
