# Kigali City Services & Places Directory

A Flutter mobile application that helps Kigali residents locate and navigate to essential public services and leisure locations, including hospitals, police stations, restaurants, cafes, parks, and tourist attractions.

---

## 📱 Features

- **Authentication**
  - Sign up with email and password
  - Secure login/logout
  - Email verification before accessing the app
  - User profile stored in Firebase Realtime Database

- **Location Listings (CRUD)**
  - Fields: name, category, address, contact number, description, coordinates, createdBy, timestamp
  - Create, Read, Update, Delete listings
  - Real-time updates using Riverpod state management

- **Directory Search & Filtering**
  - Search listings by name
  - Filter by category
  - Dynamic updates as data changes in Firebase

- **Detail Page & Map Integration**
  - Listing details with embedded Google Map
  - Navigation button for turn-by-turn directions

- **Navigation**
  - BottomNavigationBar with 5 screens: Directory, My Listings, Map View, Bookmarks, Profile, Settings

- **Profile & Settings**
  - View and edit profile
  - Change password with reauthentication
  - Notification toggle simulation

---

## 🏗️ Architecture

- **State Management:** Riverpod
- **Project Structure:**
```text
lib/
  models/     # Data models
  services/   # Firebase services
  providers/  # Riverpod providers
  screens/    # UI screens
  widgets/    # Reusable widgets
  utils/      # Utilities
🔥 Firebase Configuration
Users Collection
/users/{userId}/
- uid: string
- email: string
- displayName: string
- emailVerified: boolean
- createdAt: timestamp
- notificationsEnabled: boolean
Listings Collection
/listings/{listingId}/
- name: string
- category: string
- address: string
- contactNumber: string
- description: string
- latitude: number
- longitude: number
- createdBy: string
- timestamp: string
- rating: number
- reviewCount: number
Bookmarks Collection
/bookmarks/{userId}/{listingId}/
- value: listingId
Security Rules
{
  "rules": {
    ".read": "auth != null",
    ".write": "auth != null",
    "users": {
      "$uid": { ".read": "$uid === auth.uid", ".write": "$uid === auth.uid" }
    },
    "listings": {
      ".indexOn": ["createdBy", "category"],
      "$listingId": {
        ".read": "auth != null",
        ".write": "auth != null && (data.child('createdBy').val() === auth.uid || newData.child('createdBy').val() === auth.uid)"
      }
    }
  }
}
🚀 Getting Started
Prerequisites

Flutter SDK >= 3.0.0

Dart SDK >= 3.0.0 < 4.0.0

Android Studio or VS Code

Firebase account

Clone Repository
git clone https://github.com/kellynshuti9/kigali-city-directory.git
cd kigali-city-directory
Install Dependencies
flutter pub get
Firebase Setup

Create a Firebase project

Enable Email/Password authentication

Create a Realtime Database

Download google-services.json (Android) & GoogleService-Info.plist (iOS)

Place files in respective platform folders

Configure Firebase CLI:

npm install -g firebase-tools
firebase login
flutterfire configure
Add Google Maps API Key

Android: android/app/src/main/AndroidManifest.xml

<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="AIzaSyDOj8grTSbx92XS8fhrcxvV3brVvFiee1k"/>

iOS: ios/Runner/AppDelegate.swift

GMSServices.provideAPIKey("AIzaSyDOj8grTSbx92XS8fhrcxvV3brVvFiee1k")
Run the App
flutter run
🛠️ Built With

Flutter - UI framework

Firebase - Backend services, Authentication, Realtime Database

Riverpod - State management

Google Maps Flutter - Map integration



👤 Author
Name	Email	GitHub
Kelly Nshuti Dushimimana	k.dushimima@alustudent.com

🙏 Acknowledgments

Course instructors and teaching assistants

Flutter and Firebase documentation

Riverpod documentation

Demo Video: https://www.youtube.com/watch?v=5U4foy-UYFM