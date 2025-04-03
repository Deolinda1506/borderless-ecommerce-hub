# Borderless E-commerce App

Borderless is a modern, cross-platform e-commerce application built with Flutter and Firebase. It provides a seamless shopping experience with features like product browsing, cart management, wishlists, and secure checkout.

## Features

- 🛍️ **Product Browsing**
  - Category-based navigation
  - Product search
  - Detailed product views
  - Product filtering and sorting

- 🛒 **Shopping Cart**
  - Add/remove items
  - Update quantities
  - Save items for later
  - Persistent cart data

- ❤️ **Wishlist**
  - Add/remove favorite items
  - Quick add to cart
  - Persistent wishlist data

- 👤 **User Authentication**
  - Email/Password login
  - Google Sign-in
  - Password recovery
  - Email verification

- 💳 **Checkout Process**
  - Shipping address management
  - Payment method selection
  - Order review
  - Order confirmation

- 🌓 **Theme Support**
  - Light/Dark mode
  - Persistent theme preference

## Tech Stack

- **Frontend**: Flutter
- **Backend**: Firebase
  - Authentication
  - Cloud Firestore
  - Cloud Functions
- **State Management**: BLoC Pattern
- **Local Storage**: SharedPreferences
- **Payment Integration**: PayPal

## Getting Started

### Prerequisites

- Flutter SDK (>=3.1.0)
- Dart SDK (>=3.1.0)
- Firebase account
- Android Studio / VS Code
- iOS development tools (for iOS build)

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/Deolinda1506/borderless-ecommerce-hub.git
   cd borderless
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Configure Firebase:
   - Create a new Firebase project
   - Add Android/iOS apps in Firebase console
   - Download and add configuration files:
     - `google-services.json` for Android
     - `GoogleService-Info.plist` for iOS
   - Enable Authentication, Firestore, and Cloud Functions

4. Run the app:
   ```bash
   flutter run
   ```

## Database Architecture

### Firestore Collections

1. **users**
   ```json
   {
     "uid": "string",
     "email": "string",
     "name": "string",
     "phone": "string",
     "addresses": [{
       "id": "string",
       "street": "string",
       "city": "string",
       "state": "string",
       "zipCode": "string",
       "isDefault": boolean
     }],
     "paymentMethods": [{
       "id": "string",
       "type": "string",
       "last4": "string",
       "isDefault": boolean
     }]
   }
   ```

2. **products**
   ```json
   {
     "id": "string",
     "name": "string",
     "description": "string",
     "price": number,
     "category": "string",
     "subcategory": "string",
     "images": ["string"],
     "colors": ["string"],
     "specifications": ["string"],
     "rating": number,
     "reviews": number,
     "stock": number
   }
   ```

3. **orders**
   ```json
   {
     "id": "string",
     "userId": "string",
     "items": [{
       "productId": "string",
       "quantity": number,
       "price": number
     }],
     "total": number,
     "status": "string",
     "shippingAddress": {
       "street": "string",
       "city": "string",
       "state": "string",
       "zipCode": "string"
     },
     "paymentMethod": {
       "type": "string",
       "last4": "string"
     },
     "createdAt": timestamp
   }
   ```

## Local Storage

The app uses SharedPreferences for local data persistence:

- Cart items
- Wishlist items
- Theme preference
- User preferences

## Project Structure

```
lib/
├── blocs/           # Business logic components
├── models/          # Data models
├── screens/         # UI screens
├── services/        # API and service classes
├── widgets/         # Reusable UI components
└── main.dart        # App entry point
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request


## Acknowledgments

- Flutter team for the amazing framework
- Firebase for the backend services
- All contributors who have helped shape this project
