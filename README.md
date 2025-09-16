# Virtual Card - Contact Management App

A modern Flutter application for managing contacts with advanced features like business card scanning, OCR text recognition, and comprehensive contact management capabilities.

## Features

### 📱 Core Functionality
- **Contact Management**: Add, view, edit, and delete contacts
- **Business Card Scanning**: Capture business cards using camera or gallery
- **OCR Text Recognition**: Automatically extract text from business card images
- **Drag & Drop Interface**: Intuitive drag-and-drop system for organizing scanned information
- **Favorites System**: Mark contacts as favorites for quick access
- **Contact Actions**: Direct integration with phone, SMS, email, maps, and web browser

### 🎯 Smart Features
- **Image Processing**: ML Kit integration for text recognition from business cards
- **Contact Validation**: Form validation for required fields
- **Swipe to Delete**: Gesture-based contact deletion with confirmation
- **Responsive Design**: Adaptive UI using ScreenUtil for different screen sizes
- **State Management**: Robust state management using Riverpod

## Technical Stack

### 🛠 Technologies Used
- **Flutter**: Cross-platform mobile development framework
- **Dart**: Programming language
- **SQLite**: Local database for contact storage
- **Riverpod**: State management solution
- **Go Router**: Declarative routing
- **ML Kit**: Google's machine learning SDK for text recognition

### 📦 Key Dependencies
```yaml
dependencies:
  flutter: sdk
  flutter_riverpod: ^2.6.1          # State management
  sqflite: ^2.4.0                   # SQLite database
  go_router: ^14.3.0                # Navigation
  google_mlkit_text_recognition: ^0.14.0  # OCR functionality
  image_picker: ^1.1.2              # Camera/gallery access
  url_launcher: ^6.3.1              # External app integration
  flutter_screenutil: ^5.9.3        # Responsive design
  flutter_easyloading: ^3.0.5       # Loading indicators
```

## Architecture

### 📁 Project Structure
```
lib/
├── models/
│   └── contact_model.dart         # Contact data model
├── pages/
│   ├── home_page.dart             # Main contact list
│   ├── contact_details_page.dart  # Contact details view
│   ├── form_page.dart             # Contact form
│   └── scan_page.dart             # Business card scanning
├── providers/
│   ├── contact_provider.dart      # Contact state management
│   └── barnav_riv.dart           # Bottom navigation state
└── utils/
    ├── constants.dart             # App constants
    └── helper_functions.dart      # Utility functions
```

### 🗄 Database Schema
```sql
CREATE TABLE tbl_contact (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  mobile TEXT NOT NULL,
  email TEXT,
  address TEXT,
  company TEXT,
  desgnation TEXT,
  website TEXT,
  image TEXT,
  favorite INTEGER NOT NULL
);
```

## Contact Model

### 📋 Contact Properties
- **id**: Unique identifier (auto-generated)
- **name**: Contact name (required)
- **mobile**: Phone number (required)
- **email**: Email address (optional)
- **address**: Physical address (optional)
- **company**: Company name (optional)
- **desgnation**: Job designation (optional)
- **website**: Website URL (optional)
- **image**: Profile/business card image path (optional)
- **favorite**: Favorite status (boolean)

### 🔄 Data Conversion
```dart
// Convert to Map for database storage
Map<String, dynamic> toMap()

// Create from database Map
factory ContactModel.fromMap(Map<String, dynamic> map)
```

## Key Features Deep Dive

### 🔍 Business Card Scanning
1. **Image Capture**: Take photo or select from gallery
2. **OCR Processing**: Google ML Kit extracts text from image
3. **Smart Parsing**: Text is broken into draggable chunks
4. **Drag & Drop**: Users drag text pieces to appropriate contact fields
5. **Form Completion**: Pre-filled form ready for saving

### 📞 Contact Actions
- **Call**: Direct phone dialing
- **SMS**: Text message composition
- **Email**: Email client integration
- **Maps**: Location opening in maps app
- **Web**: Website opening in browser

### ⭐ Favorites Management
- Toggle favorite status with heart icon
- Dedicated favorites view in bottom navigation
- Persistent favorite status in database

### 🗑 Contact Management
- Swipe-to-delete with confirmation dialog
- Edit existing contacts through form
- Comprehensive contact details view

## Installation & Setup

### 📋 Prerequisites
- Flutter SDK (3.0+)
- Dart SDK
- Android Studio / VS Code
- Android/iOS device or emulator

### 🚀 Getting Started
1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

### 🔧 Configuration
- Ensure camera permissions are granted for business card scanning
- ML Kit will download models on first use (requires internet)

## Usage Guide

### ➕ Adding Contacts
1. Tap the floating action button (+)
2. Choose to scan a business card or enter manually
3. For scanning: capture/select image, drag text to fields
4. Fill in the contact form
5. Save the contact

### 📋 Managing Contacts
- **View**: Tap any contact to see full details
- **Favorite**: Tap the heart icon to mark as favorite
- **Delete**: Swipe left on contact and confirm deletion
- **Edit**: Access through contact details (implementation ready)

### 🔍 Viewing Contacts
- **All Contacts**: Default view showing all saved contacts
- **Favorites**: Switch to favorites tab to see starred contacts
- **Contact Details**: Tap contact for full information and action buttons

## State Management

The app uses **Riverpod** for state management with the following providers:
- `contactProvider`: Manages contact list state and database operations
- `bottomNavProvider`: Handles bottom navigation tab switching


## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

---

**Virtual Card** - Simplifying contact management through intelligent business card scanning and intuitive mobile interface.