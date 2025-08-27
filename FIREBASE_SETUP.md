# Firebase Setup Guide for BrewCart

## 1. Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Create a project"
3. Enter project name: `brew-cart` or `brewcart`
4. Enable Google Analytics (recommended)
5. Select or create Analytics account
6. Click "Create project"

## 2. Add Apps to Firebase Project

### For Android:
1. Click "Add app" → Select Android
2. Enter package name: `com.example.brew_cart` (from android/app/build.gradle)
3. Enter app nickname: `BrewCart Android`
4. Download `google-services.json`
5. Place it in `android/app/` folder

### For iOS:
1. Click "Add app" → Select iOS
2. Enter iOS bundle ID: `com.example.brewCart` (from ios/Runner/Info.plist)
3. Enter app nickname: `BrewCart iOS`
4. Download `GoogleService-Info.plist`
5. Place it in `ios/Runner/` folder

### For Web:
1. Click "Add app" → Select Web
2. Enter app nickname: `BrewCart Web`
3. Copy the Firebase configuration object

## 3. Enable Firebase Services

### Authentication:
1. Go to "Authentication" → "Sign-in method"
2. Enable these providers:
   - Email/Password ✅
   - Google (optional) ✅
   - Phone (optional) ✅

### Firestore Database:
1. Go to "Firestore Database"
2. Click "Create database"
3. Start in "Test mode" (for development)
4. Choose location (closest to your users)

### Storage:
1. Go to "Storage"
2. Click "Get started"
3. Start in "Test mode"
4. Use default location

## 4. Firestore Database Structure

Create these collections in Firestore:

### Users Collection (`users`)
```
users/
  {userId}/
    - email: string
    - fullName: string
    - phoneNumber: string (optional)
    - photoUrl: string (optional)
    - createdAt: timestamp
    - updatedAt: timestamp
    - isEmailVerified: boolean
```

### Categories Collection (`categories`)
```
categories/
  {categoryId}/
    - name: string (e.g., "Espresso", "Latte", "Cappuccino")
    - description: string
    - imageUrl: string
    - isActive: boolean
    - order: number
    - createdAt: timestamp
```

### Coffees Collection (`coffees`)
```
coffees/
  {coffeeId}/
    - name: string
    - description: string
    - category: string (categoryId)
    - basePrice: number
    - imageUrl: string
    - ingredients: array of strings
    - rating: number (0.0-5.0)
    - reviewCount: number
    - isPopular: boolean
    - isFeatured: boolean
    - sizePrices: map
      - Small: number
      - Medium: number
      - Large: number
    - availableSizes: array of strings
    - isActive: boolean
    - createdAt: timestamp
    - updatedAt: timestamp
```

### Orders Collection (`orders`)
```
orders/
  {orderId}/
    - userId: string
    - items: array of maps
      - coffeeId: string
      - coffeeName: string
      - coffeeImageUrl: string
      - size: string
      - sugarLevel: string
      - temperature: string
      - quantity: number
      - unitPrice: number
      - totalPrice: number
      - customizations: map
    - subtotal: number
    - deliveryFee: number
    - tax: number
    - total: number
    - status: string (pending, confirmed, preparing, ready, completed, cancelled)
    - paymentMethod: string
    - deliveryAddress: string
    - orderDate: timestamp
    - estimatedDeliveryTime: timestamp (optional)
    - completedAt: timestamp (optional)
    - notes: string (optional)
```

## 5. Security Rules

### Firestore Rules:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Anyone can read categories and coffees
    match /categories/{categoryId} {
      allow read: if true;
      allow write: if false; // Only admin can write
    }
    
    match /coffees/{coffeeId} {
      allow read: if true;
      allow write: if false; // Only admin can write
    }
    
    // Users can only access their own orders
    match /orders/{orderId} {
      allow read, write: if request.auth != null && 
        request.auth.uid == resource.data.userId;
      allow create: if request.auth != null && 
        request.auth.uid == request.resource.data.userId;
    }
  }
}
```

### Storage Rules:
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Coffee images - read by anyone, write by admin only
    match /coffee_images/{allPaths=**} {
      allow read: if true;
      allow write: if false;
    }
    
    // User avatars - read/write by authenticated user
    match /user_avatars/{userId}/{allPaths=**} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

## 6. Sample Data to Add

### Sample Categories:
```json
[
  {
    "name": "Espresso",
    "description": "Rich and bold coffee shots",
    "imageUrl": "https://example.com/espresso.jpg",
    "isActive": true,
    "order": 1
  },
  {
    "name": "Latte",
    "description": "Smooth coffee with steamed milk",
    "imageUrl": "https://example.com/latte.jpg",
    "isActive": true,
    "order": 2
  },
  {
    "name": "Cappuccino",
    "description": "Coffee with frothy milk foam",
    "imageUrl": "https://example.com/cappuccino.jpg",
    "isActive": true,
    "order": 3
  }
]
```

### Sample Coffees:
```json
[
  {
    "name": "Classic Americano",
    "description": "Rich espresso with hot water",
    "category": "americano",
    "basePrice": 3.50,
    "imageUrl": "https://example.com/americano.jpg",
    "ingredients": ["Espresso", "Hot Water"],
    "rating": 4.5,
    "reviewCount": 128,
    "isPopular": true,
    "isFeatured": false,
    "sizePrices": {
      "Small": 3.50,
      "Medium": 4.00,
      "Large": 4.50
    },
    "availableSizes": ["Small", "Medium", "Large"],
    "isActive": true
  }
]
```

## 7. Environment Configuration

Create different Firebase projects for different environments:
- `brew-cart-dev` (Development)
- `brew-cart-staging` (Staging)
- `brew-cart-prod` (Production)

## 8. Next Steps After Setup

1. Run `flutterfire configure` to generate firebase_options.dart
2. Test authentication flow
3. Add sample data to Firestore
4. Test data reading/writing
5. Configure push notifications (optional)
6. Set up Firebase Analytics
7. Configure Crashlytics for error tracking
