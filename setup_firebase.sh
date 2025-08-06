#!/bin/bash

echo "🔥 Firebase Setup for BrewCart"
echo "================================"

echo "📋 Step 1: Installing dependencies..."
flutter pub get

echo "🛠️  Step 2: Setting up FlutterFire CLI..."
flutter pub global activate flutterfire_cli

echo "⚙️  Step 3: Configuring Firebase..."
echo "Please make sure you have:"
echo "1. Created a Firebase project at https://console.firebase.google.com"
echo "2. Enabled Authentication (Email/Password)"
echo "3. Created Firestore Database in test mode"
echo "4. Enabled Storage in test mode"
echo ""
echo "Now run: flutterfire configure"
echo "This will:"
echo "- Connect your Flutter app to Firebase"
echo "- Generate firebase_options.dart"
echo "- Download configuration files"

echo ""
echo "🎯 Step 4: Next steps after running flutterfire configure:"
echo "1. Add sample data to Firestore (see FIREBASE_SETUP.md)"
echo "2. Update security rules"
echo "3. Test authentication flow"
echo "4. Run the app: flutter run"

echo ""
echo "📚 For detailed setup instructions, check FIREBASE_SETUP.md"
