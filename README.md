# ☕ Brew Cart - Premium Coffee Ordering Mobile Application

[![Flutter](https://img.shields.io/badge/Flutter-3.8.1-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev/)
[![Firebase](https://img.shields.io/badge/Firebase-DD2C00?style=for-the-badge&logo=firebase&logoColor=white)](https://firebase.google.com/)
[![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev/)
[![Stripe](https://img.shields.io/badge/Stripe-008CDD?style=for-the-badge&logo=stripe&logoColor=white)](https://stripe.com/)

> **A sophisticated, production-ready coffee ordering mobile application showcasing modern Flutter development practices, clean architecture, and seamless user experience.**

---

## 🎥 **Live Application Demo**

### 1. 🚀 **Splash Screen & Authentication**
<div align="center">
  <img src="assets/gif/1.gif" alt="Splash Screen and Login Demo" width="300"/>
  <p><em>Smooth splash screen animation with professional login/signup interface featuring custom animations and Firebase authentication</em></p>
</div>

### 2. 🏪 **Coffee Menu & Product Catalog**
<div align="center">
  <img src="assets/gif/2.gif" alt="Coffee Menu Showcase" width="300"/>
  <p><em>Dynamic coffee menu with smooth navigation, product filtering, and detailed coffee information display</em></p>
</div>

### 3. 🛒 **Order Process & Order History**
<div align="center">
  <img src="assets/gif/3.gif" alt="Ordering Process and Order History" width="300"/>
  <p><em>Complete ordering workflow with customization options, cart management, and order history tracking</em></p>
</div>

---

## 🚀 **Project Overview**

Brew Cart is a comprehensive coffee ordering application that demonstrates expertise in Flutter development, state management, backend integration, and modern mobile app architecture. Built with scalability and user experience in mind, this project showcases advanced Flutter concepts and industry best practices.

## ✨ **Key Features & Capabilities**

### 🔐 **Advanced Authentication System**

- **Firebase Authentication** with email/password
- **Custom Login UI** with flutter_login package
- **Animated form transitions** with morph effects
- **Real-time validation** and error handling
- **User profile management** with Firestore integration

### 🏪 **Coffee Shop Experience**

- **Dynamic product catalog** with real-time updates
- **Advanced filtering and search** functionality
- **Product categorization** and recommendations
- **High-quality image gallery** with smooth animations
- **Detailed product information** and nutritional data

### 🛒 **Smart Shopping Cart**

- **Real-time cart management** with BLoC state management
- **Quantity adjustments** with instant price updates
- **Persistent cart state** across app sessions
- **Smart recommendations** based on cart contents

### 🎨 **Coffee Customization Engine**

- **Interactive customization interface**
- **Size selection** (Small, Medium, Large)
- **Temperature preferences** (Hot, Iced, Cold Brew)
- **Milk alternatives** (Oat, Almond, Soy, etc.)
- **Sweetness levels** and flavor additions
- **Real-time price calculations**

### 💳 **Secure Payment Integration**

- **Stripe payment processing** for secure transactions
- **Multiple payment methods** support
- **Real-time payment status** tracking
- **Receipt generation** and order confirmation

### 📦 **Order Management System**

- **Real-time order tracking** with status updates
- **Order history** with detailed receipts
- **Reorder functionality** for quick purchases
- **Push notifications** for order updates

### 👤 **User Profile & Preferences**

- **Comprehensive user profiles** with Firebase integration
- **Order history** and favorite items
- **Delivery address management**
- **Preference settings** and customization

---

## 🏗️ **Technical Architecture**

### **Clean Architecture Implementation**

```
lib/
├── core/                    # Core utilities and configurations
│   ├── constants/          # App-wide constants and themes
│   ├── router/            # Navigation and routing logic
│   └── services/          # Shared services (Auth, Firebase)
├── features/              # Feature-based modular architecture
│   ├── auth/             # Authentication feature
│   │   ├── data/         # Data sources and repositories
│   │   ├── domain/       # Business logic and entities
│   │   └── presentation/ # UI components and state management
│   ├── coffee_shop/      # Main coffee browsing feature
│   ├── cart/             # Shopping cart functionality
│   ├── checkout/         # Payment and order completion
│   ├── customization/    # Coffee customization engine
│   └── profile/          # User profile management
└── shared/               # Shared widgets and utilities
```

### **State Management**

- **BLoC Pattern** for predictable state management
- **Event-driven architecture** for complex user interactions
- **Equatable** for efficient state comparisons
- **Repository pattern** for data abstraction

---

## 🛠️ **Technology Stack**

### **Frontend**
| Technology | Purpose | Version |
|------------|---------|---------|
| **Flutter** | Cross-platform mobile framework | 3.8.1 |
| **Dart** | Primary programming language | Latest |
| **BLoC** | State management solution | 8.1.6 |
| **Go Router** | Navigation and routing | 14.6.1 |
| **Flutter SVG** | Vector graphics support | 2.0.9 |

### **Backend & Services**
| Service | Purpose | Integration |
|---------|---------|-------------|
| **Firebase Auth** | User authentication | 5.3.1 |
| **Cloud Firestore** | NoSQL database | 5.4.4 |
| **Firebase Core** | Firebase SDK | 3.6.0 |
| **Stripe** | Payment processing | 11.1.0 |

### **UI/UX Libraries**
| Library | Purpose |
|---------|---------|
| **flutter_login** | Professional auth screens |
| **curved_navigation_bar** | Custom navigation |
| **Custom Fonts** | Inter & Montserrat typography |

---

## 🎯 **Development Highlights**

### **Code Quality & Best Practices**

- ✅ **Clean Architecture** with separation of concerns
- ✅ **SOLID Principles** implementation
- ✅ **Repository Pattern** for data management
- ✅ **Dependency Injection** for testability
- ✅ **Error Handling** with custom exceptions
- ✅ **Code Documentation** and inline comments

### **Performance Optimizations**

- ✅ **Lazy loading** for large product catalogs
- ✅ **Image caching** for smooth scrolling
- ✅ **State persistence** for seamless user experience
- ✅ **Efficient list rendering** with Flutter best practices

### **Security Implementation**

- ✅ **Firebase Security Rules** for data protection
- ✅ **Input validation** and sanitization
- ✅ **Secure payment processing** with Stripe
- ✅ **Authentication state management**

---

## 📊 **Business Logic Showcase**

### **Dynamic Pricing Engine**

```dart
// Smart pricing calculations with real-time updates
class PricingEngine {
  double calculatePrice(Coffee coffee, List<Customization> customizations) {
    // Base price calculation with size modifiers
    // Add-on pricing with dynamic adjustments
    // Promotional discounts and offers
  }
}
```

### **State Management Excellence**

```dart
// BLoC implementation for cart management
class CartBloc extends Bloc<CartEvent, CartState> {
  // Event handling for add, remove, update operations
  // Real-time price calculations
  // Persistent state management
}
```

---

## 🌟 **Professional Skills Demonstrated**

### **Flutter Development**

- Advanced widget composition and custom widgets
- Complex animations and micro-interactions
- Platform-specific optimizations
- Responsive design for multiple screen sizes

### **Backend Integration**

- RESTful API consumption with HTTP client
- Real-time database operations with Firestore
- Cloud function integration
- Third-party service integration (Stripe, Firebase)

### **Software Engineering**

- Modular architecture design
- Design patterns implementation
- Code reusability and maintainability
- Version control with Git

### **UI/UX Design**

- Material Design 3 principles
- Custom theming and branding
- Accessibility considerations
- User-centered design approach

---

## 🚀 **Getting Started**

### **Prerequisites**

- Flutter SDK 3.8.1+
- Dart SDK
- Android Studio / VS Code
- Firebase project setup
- Stripe account for payments

### **Installation**

```bash
# Clone the repository
git clone https://github.com/0Jahid/brew_cart.git

# Navigate to project directory
cd brew_cart

# Install dependencies
flutter pub get

# Run the application
flutter run
```

### **Configuration**

1. **Firebase Setup**: Add your `google-services.json` and Firebase configuration
2. **Stripe Integration**: Configure your Stripe publishable key
3. **Environment Variables**: Set up your API endpoints and keys

---

## 📈 **Project Metrics & Achievements**

- 🏗️ **10+ Feature Modules** with clean architecture
- 🎨 **50+ Custom Widgets** for reusable UI components
- 🔥 **Real-time Database** integration with Firestore
- 💳 **Secure Payment** processing with Stripe
- 📱 **Cross-platform** compatibility (iOS & Android)
- 🧪 **Comprehensive Testing** strategy implementation

---

## 🎓 **Learning Outcomes & Growth**

This project demonstrates proficiency in:

- **Modern Flutter Development** with latest SDK features
- **State Management** patterns and best practices
- **Firebase Ecosystem** for backend services
- **Payment Integration** for e-commerce applications
- **Clean Code Principles** and architecture design
- **User Experience Design** and interface development

---

## 🤝 **Connect & Collaborate**

💼 **LinkedIn**: [Your LinkedIn Profile](#)  
📧 **Email**: [your.email@example.com](#)  
🐙 **GitHub**: [@0Jahid](https://github.com/0Jahid)  
📱 **Portfolio**: [Your Portfolio Website](#)

---

## 📄 **License**

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

<div align="center">

### 🌟 **Built with passion for exceptional mobile experiences** 🌟

**Ready to discuss how this project demonstrates my Flutter development expertise?**  
**Let's connect and explore opportunities together!**

</div>
