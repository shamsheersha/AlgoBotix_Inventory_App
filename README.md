# 📦 AlgoBotix Inventory Manager

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.2+-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.2+-0175C2?style=for-the-badge&logo=dart)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**A modern, feature-rich inventory management application built with Flutter**

[Features](#-features) • [Installation](#-installation) • [Usage](#-usage) • [Screenshots](#-screenshots) • [Tech Stack](#-tech-stack)

</div>

---

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Tech Stack](#-tech-stack)
- [Requirements](#-requirements)
- [Installation](#-installation)
- [Project Structure](#-project-structure)
- [Usage Guide](#-usage-guide)
- [Building APK](#-building-apk)
- [Packages Used](#-packages-used)
- [Screenshots](#-screenshots)
- [Troubleshooting](#-troubleshooting)
- [License](#-license)

---

## 🎯 Overview

AlgoBotix Inventory Manager is a comprehensive Android application designed for efficient product and inventory management. Built with Flutter and featuring a modern Material Design 3 UI, it provides seamless CRUD operations, real-time stock tracking, QR code integration, and persistent local storage.

### 🎓 Developed For
**Assignment**: Flutter Development – AlgoBotix  
**Deadline**: January 16, 2026, 10:00 AM

---

## ✨ Features

### 🔹 Mandatory Features

#### Product Management
- ✅ **Unique Product IDs**: 5-character alphanumeric validation (e.g., ABC12, XY789)
- ✅ **Complete Product Data**: Name, Description, Current Stock
- ✅ **Image Support**: Select from Gallery or capture with Camera
- ✅ **Metadata Tracking**: Automatic timestamps and "Admin User" attribution
- ✅ **Persistent Storage**: Hive local database for offline data persistence

#### Core Functionality
- ✅ **Modern Home Screen**: Beautiful card-based product grid
- ✅ **Smart Search**: Filter products by Product ID in real-time
- ✅ **Full CRUD Operations**: 
  - ➕ Create new products
  - 👁️ View product details
  - ✏️ Edit product information
  - 🗑️ Delete products with confirmation
- ✅ **Stock Management**: Intuitive increment/decrement controls

### 🎁 Bonus Features

#### QR Code Integration
- 📷 **QR Code Scanner**: Scan product QR codes with camera
- 🔦 **Torch Support**: Toggle flashlight for low-light scanning
- 🎨 **Custom Overlay**: Beautiful scanning interface with corner indicators
- 🔍 **Instant Product Lookup**: Navigate directly to product details

#### Stock History Tracking
- 📊 **Complete Audit Trail**: Chronological log of all stock changes
- ➕➖ **Change Tracking**: Visual indicators for additions and removals
- ⏰ **Timestamps**: Precise date and time for each transaction
- 📝 **Reason Logging**: Track why stock was adjusted
- 🎯 **Stock Flow**: See previous → new stock values

### 🎨 Modern UI/UX Features
- 🌈 **Material Design 3**: Latest design system implementation
- 🎭 **Custom Theme**: Professional indigo color scheme (#6366F1)
- 🔤 **Google Fonts**: Inter font family for clean typography
- 💳 **Card Layouts**: Elevated cards with rounded corners
- 🎨 **Color-Coded Stock Levels**:
  - 🟢 Green: Stock > 50
  - 🟠 Orange: Stock 20-50
  - 🔴 Red: Stock < 20
- 🖼️ **Image Handling**: Fallback icons for products without images
- ⚡ **Smooth Animations**: Seamless page transitions
- 📱 **Responsive Design**: Adapts to different screen sizes

---

## 🛠 Tech Stack

| Category | Technology |
|----------|-----------|
| **Framework** | Flutter 3.2+ |
| **Language** | Dart 3.2+ |
| **State Management** | Provider |
| **Local Database** | Hive + Hive Flutter |
| **Image Handling** | Image Picker |
| **QR Features** | Mobile Scanner, QR Flutter |
| **Typography** | Google Fonts |
| **UI Components** | Material Design 3 |

---

## 📋 Requirements

### System Requirements
- **Flutter SDK**: 3.2.0 or higher
- **Dart SDK**: 3.2.0 or higher
- **Android Studio**: 2022.1+ (or VS Code with Flutter extension)
- **Android SDK**: API Level 21+ (Android 5.0+)
- **Gradle**: 8.0+

### Device Requirements
- **Minimum Android Version**: 5.0 (API 21)
- **Target Android Version**: 14 (API 34)
- **Camera**: Required for QR scanning and image capture
- **Storage**: ~50MB for app + data

---

## 📥 Installation

### 1. Clone or Download the Project

```bash
# If using Git
git clone https://github.com/shamsheersha/algobotix-inventory.git
cd algobotix-inventory

# Or extract the ZIP file to your desired location
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

### 3. Generate Hive Adapters

```bash
flutter pub run build_runner build
```

If you encounter conflicts:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 4. Configure Android

Update `android/app/build.gradle`:

```gradle
android {
    namespace "com.algobotix.inventory"
    compileSdkVersion 34
    
    defaultConfig {
        applicationId "com.algobotix.inventory"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

### 5. Run the Application

```bash
# Run in debug mode
flutter run

# Run on specific device
flutter run -d <device_id>

# List available devices
flutter devices
```

---

## 📁 Project Structure

```
algobotix_inventory/
├── lib/
│   ├── main.dart                      # App entry point
│   ├── models/
│   │   ├── product.dart               # Product model
│   │   ├── product.g.dart             # Generated Hive adapter
│   │   ├── stock_history.dart         # Stock history model
│   │   └── stock_history.g.dart       # Generated Hive adapter
│   ├── providers/
│   │   └── product_provider.dart      # State management
│   └── screens/
│       ├── home_screen.dart           # Main product list
│       ├── add_product_screen.dart    # Add/Edit products
│       ├── product_detail_screen.dart # Product details & stock
│       └── qr_scanner_screen.dart     # QR code scanner
├── android/
│   └── app/
│       ├── build.gradle               # Android config
│       └── src/main/AndroidManifest.xml
├── pubspec.yaml                       # Dependencies
└── README.md                          # This file
```

---

## 📖 Usage Guide

### Adding a New Product

1. **Tap** the floating "Add Product" button on the home screen
2. **Tap** the image placeholder to select/capture a product image
3. **Enter** a unique 5-character Product ID (e.g., PROD1, ABC12)
4. **Fill in** product name and description
5. **Set** initial stock quantity
6. **Tap** "Add Product" to save

### Viewing Product Details

1. **Tap** any product card on the home screen
2. View complete product information
3. See current stock level with color indicator
4. Review complete stock history

### Updating Stock

1. **Navigate** to product details
2. **Tap** "Add" to increase stock or "Remove" to decrease
3. **Enter** the quantity to adjust
4. **Confirm** the change
5. View updated stock in history log

### Editing Product Information

1. **Open** product details
2. **Tap** the edit icon (✏️) in the app bar
3. **Modify** product name, description, or image
4. **Note**: Product ID cannot be changed
5. **Tap** "Update Product" to save

### Deleting a Product

1. **Open** product details
2. **Tap** the delete icon (🗑️) in the app bar
3. **Confirm** deletion in the dialog
4. Product and all history will be permanently removed

### Searching Products

1. **Tap** the search bar on home screen
2. **Type** the Product ID (partial or complete)
3. Results filter in real-time
4. **Tap** ❌ to clear search

### Scanning QR Codes

1. **Tap** the QR scanner icon (📷) on home screen
2. **Allow** camera permission if prompted
3. **Position** QR code within the frame
4. **Wait** for automatic detection
5. **Navigate** to product details if found
6. **Tap** 🔦 to toggle flashlight

### Generating QR Codes

1. **Navigate** to any product detail screen
2. **Tap** the QR code icon in the app bar
3. **View** or share the generated QR code

---

## 📦 Building APK

### Debug APK

```bash
flutter build apk --debug
```

Output: `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Split APKs (Smaller size)

```bash
flutter build apk --split-per-abi --release
```

Generates separate APKs for:
- `app-armeabi-v7a-release.apk` (32-bit ARM)
- `app-arm64-v8a-release.apk` (64-bit ARM)
- `app-x86_64-release.apk` (64-bit x86)

### App Bundle (For Google Play)

```bash
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

---

## 📚 Packages Used

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `provider` | ^6.1.1 | State management solution |
| `hive` | ^2.2.3 | Lightweight NoSQL database |
| `hive_flutter` | ^1.1.0 | Flutter integration for Hive |
| `image_picker` | ^1.0.7 | Camera and gallery access |
| `path_provider` | ^2.1.2 | File system path handling |
| `mobile_scanner` | ^5.2.3 | QR code scanning |
| `qr_flutter` | ^4.1.0 | QR code generation |
| `google_fonts` | ^6.1.0 | Custom font integration |
| `intl` | ^0.19.0 | Date formatting |
| `uuid` | ^4.3.3 | Unique ID generation |

### Dev Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `flutter_lints` | ^3.0.1 | Code quality checks |
| `hive_generator` | ^2.0.1 | Generate type adapters |
| `build_runner` | ^2.4.8 | Code generation tool |

---

## 📸 Screenshots
![alt text](<WhatsApp Image 2026-01-15 at 9.20.24 PM.jpeg>)
![alt text](<WhatsApp Image 2026-01-15 at 9.20.24 PM-1.jpeg>)
![alt text](<WhatsApp Image 2026-01-15 at 9.20.25 PM (1).jpeg>)
![alt text](<WhatsApp Image 2026-01-15 at 9.20.25 PM (1)-1.jpeg>)

### Home Screen
- Modern card-based layout
- Search functionality
- Product count indicator
- Floating action button

### Add/Edit Product
- Image picker with camera/gallery
- 5-character ID validation
- Real-time form validation
- QR code generation for existing products

### Product Details
- Hero image display
- Stock level indicators
- Add/Remove stock buttons
- Complete stock history
- Edit and delete options

### QR Scanner
- Custom overlay design
- Flashlight toggle
- Real-time scanning
- Error handling

### Stock History
- Chronological log
- Visual +/- indicators
- Timestamps for each change
- Stock flow tracking (before → after)

---

## 🐛 Troubleshooting

### Build Errors

**Problem**: Namespace error in Gradle
```
Namespace not specified
```

**Solution**:
```gradle
// In android/app/build.gradle, add:
android {
    namespace "com.algobotix.inventory"
    // ...
}
```

---

**Problem**: Hive adapter not found
```
Cannot find type adapter for Product
```

**Solution**:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

---

**Problem**: Camera permission denied

**Solution**:
- Check `AndroidManifest.xml` has camera permissions
- Grant camera permission in device settings
- Restart the app

---

**Problem**: QR scanner not working

**Solution**:
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

---

### Runtime Issues

**Problem**: Images not displaying

**Solution**:
- Verify storage permissions
- Check if image file exists at path
- Try capturing a new image

---

**Problem**: Duplicate Product ID error

**Solution**:
- Each Product ID must be unique
- Use search to check existing IDs
- Choose a different 5-character ID

---

**Problem**: Stock history not showing

**Solution**:
- Perform at least one stock adjustment
- History is created automatically
- Check if product has been saved

---

## 🔐 Permissions

The app requires the following permissions:

```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.CAMERA"/>
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE"/>
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES"/>
```

---

## 🎨 Color Scheme

| Element | Color | Hex Code |
|---------|-------|----------|
| Primary | Indigo | #6366F1 |
| Success | Green | #22C55E |
| Warning | Orange | #F59E0B |
| Danger | Red | #EF4444 |
| Background | Light Gray | #F9FAFB |
| Text Primary | Dark Gray | #111827 |
| Text Secondary | Medium Gray | #6B7280 |

---

## 📝 Features Checklist

### ✅ Mandatory Features (All Implemented)
- [x] Product ID (5 alphanumeric, unique)
- [x] Product attributes (Name, Description, Stock)
- [x] Image selection (Gallery/Camera)
- [x] Metadata (Timestamp, Added By)
- [x] Persistent local storage (Hive)
- [x] Home screen with product list
- [x] Search by Product ID
- [x] Full CRUD operations
- [x] Stock increment/decrement

### ✅ Bonus Features (All Implemented)
- [x] QR code scanning
- [x] QR code generation
- [x] Stock history tracking
- [x] Chronological stock log
- [x] Change amounts with timestamps

### ✨ Additional Enhancements
- [x] Material Design 3
- [x] Google Fonts integration
- [x] Color-coded stock levels
- [x] Custom scanner overlay
- [x] Image fallback handling
- [x] Confirmation dialogs
- [x] Error handling
- [x] Loading states
- [x] Responsive layouts

---

## 📄 License

This project is developed as an assignment for AlgoBotix. All rights to the source code remain solely with the applicant.

**Usage Rights**: Team AlgoBotix will not use the framework developed in this assignment in any commercialized solutions.

---

## 👨‍💻 Development

### Code Generation

When modifying models, regenerate adapters:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Hot Reload

During development, use hot reload for faster iteration:
- Press `r` in terminal
- Or save files in IDE (if hot reload is enabled)

### Debugging

Enable debug logging:
```dart
// In main.dart
debugPrint('Your debug message');
```

View logs:
```bash
flutter logs
```

---

## 🚀 Future Enhancements

Potential features for future versions:

- [ ] Cloud sync with Firebase
- [ ] Multi-user support with authentication
- [ ] Export data to CSV/Excel
- [ ] Import products from files
- [ ] Barcode scanning (in addition to QR)
- [ ] Low stock alerts/notifications
- [ ] Product categories
- [ ] Analytics dashboard
- [ ] Print QR code labels
- [ ] Dark mode support
- [ ] Multi-language support

---

## 📞 Support

For issues or questions:

1. Check the [Troubleshooting](#-troubleshooting) section
2. Review the [Usage Guide](#-usage-guide)
3. Verify all [Requirements](#-requirements) are met
4. Contact the developer

---

## 🙏 Acknowledgments

- **Flutter Team** - For the amazing framework
- **Hive** - For lightweight local storage
- **Mobile Scanner** - For modern QR scanning
- **Material Design** - For beautiful UI guidelines
- **AlgoBotix Team** - For the opportunity

---

<div align="center">

**Built with ❤️ using Flutter**

![Flutter](https://img.shields.io/badge/Made%20with-Flutter-02569B?style=flat&logo=flutter)

</div>