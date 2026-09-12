# ConnectCall

A Flutter 1-to-1 audio and video calling app with real-time communication using Agora RTC Engine and Firebase backend.

## Features

- **Real-time Audio/Video Calls**: High-quality calls using Agora RTC Engine
- **User Authentication**: Firebase Auth with email/password
- **User Presence**: Online/offline status tracking
- **Call History**: Complete call logs with duration and status
- **Push Notifications**: FCM notifications for incoming calls
- **Call Controls**: Mute, speaker, camera toggle, camera switch
- **Call Status**: Calling, ringing, connected, ended, rejected, missed states

## Tech Stack

- **Frontend**: Flutter
- **Backend**: Firebase (Auth + Cloud Firestore)
- **Real-time Communication**: Agora RTC Engine
- **Push Notifications**: Firebase Cloud Messaging + flutter_local_notifications
- **State Management**: Riverpod
- **Permissions**: permission_handler

## Prerequisites

Before you begin, ensure you have the following:

- Flutter SDK (3.13.2 or higher)
- Android Studio / Xcode
- Firebase account
- Agora.io account (free tier)

## Setup Instructions

### 1. Firebase Setup

1. Create a new Firebase project at [https://console.firebase.google.com/](https://console.firebase.google.com/)
2. Enable **Email/Password Authentication**:
   - Go to Authentication → Sign-in method
   - Enable Email/Password provider
3. Create **Firestore Database**:
   - Go to Firestore Database → Create Database
   - Choose production mode (or test mode for development)
4. Add Android app:
   - Go to Project Settings → Add app → Android
   - Package name: `com.connectcall.connectcall`
   - Download `google-services.json`
   - Place it in `android/app/`
5. Add iOS app (if testing on iOS):
   - Go to Project Settings → Add app → iOS
   - Bundle ID: `com.connectcall.connectcall`
   - Download `GoogleService-Info.plist`
   - Place it in `ios/Runner/`

### 2. Firestore Security Rules

Apply the following security rules in Firestore → Rules:

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    
    // Users collection rules
    match /users/{userId} {
      allow read: if request.auth != null && request.auth.uid == userId;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Calls collection rules
    match /calls/{callId} {
      allow read: if request.auth != null && 
        (resource.data.callerId == request.auth.uid || 
         resource.data.calleeId == request.auth.uid);
      allow create: if request.auth != null && 
        request.resource.data.callerId == request.auth.uid;
      allow update: if request.auth != null && 
        (resource.data.callerId == request.auth.uid || 
         resource.data.calleeId == request.auth.uid);
    }
  }
}
```

### 3. Agora Setup

1. Create a free Agora account at [https://console.agora.io/](https://console.agora.io/)
2. Create a new project
3. Copy your **App ID** from the project dashboard
4. Set the Agora App ID as an environment variable:

**For development:**
```bash
flutter run --dart-define=AGORA_APP_ID=your_app_id_here
```

**For production builds:**
```bash
flutter build apk --dart-define=AGORA_APP_ID=your_app_id_here
flutter build appbundle --dart-define=AGORA_APP_ID=your_app_id_here
```

### 4. Install Dependencies

```bash
cd connectcall
flutter pub get
```

### 5. Android Configuration

The following permissions are already configured in `android/app/src/main/AndroidManifest.xml`:
- INTERNET
- RECORD_AUDIO
- CAMERA
- MODIFY_AUDIO_SETTINGS
- ACCESS_NETWORK_STATE
- BLUETOOTH
- POST_NOTIFICATIONS
- VIBRATE

### 6. Run the App

```bash
flutter run --dart-define=AGORA_APP_ID=your_app_id_here
```

## Testing Protocol

### Step 1: Build APKs

```bash
flutter build apk --dart-define=AGORA_APP_ID=your_app_id_here --release
```

### Step 2: Install on Two Devices

1. Install the APK on two different physical Android phones
2. Or use one phone + one emulator

### Step 3: Test Complete Call Flow

1. **User Registration**:
   - Register User A on Phone 1
   - Register User B on Phone 2

2. **Audio Call Test**:
   - User A taps "phone" icon on User B
   - User B receives incoming call screen
   - User B accepts
   - Verify audio works both ways
   - Test mute/unmute
   - Test speaker toggle
   - End call from User A's side
   - Verify User B's screen closes automatically
   - Check call history on both devices

3. **Video Call Test**:
   - User A taps "video" icon on User B
   - User B receives incoming call screen
   - User B accepts
   - Verify video works both ways
   - Test camera toggle
   - Test camera switch
   - End call from User B's side
   - Verify User A's screen closes automatically
   - Check call history on both devices

4. **Edge Cases**:
   - Let a call ring for 30 seconds (should auto-miss)
   - Reject a call
   - Call when user is offline
   - Test with WiFi on one device, mobile data on another
   - Turn off WiFi mid-call to test reconnection

## Project Structure

```
lib/
├── main.dart                 # App entry point with Firebase init
├── models/
│   ├── user.dart            # User data model
│   └── call.dart            # Call data model
├── services/
│   ├── auth_service.dart    # Firebase Auth operations
│   ├── user_service.dart    # User presence and data
│   ├── calling_service.dart # Agora RTC engine and call logic
│   ├── permission_service.dart # Permission handling
│   └── notification_service.dart # FCM notifications
├── providers/
│   └── providers.dart       # Riverpod state management
├── screens/
│   ├── splash_screen.dart   # Splash with auth state listener
│   ├── login_screen.dart    # Login UI
│   ├── signup_screen.dart   # Signup UI
│   ├── home_screen.dart     # Contacts list and navigation
│   ├── incoming_call_screen.dart # Incoming call UI
│   ├── call_screen.dart     # Active call UI with controls
│   └── call_history_screen.dart # Call history list
└── widgets/                 # Reusable widgets (if needed)
```

## Troubleshooting

### Build Issues

**Error: "google-services.json not found"**
- Ensure you've downloaded `google-services.json` from Firebase Console
- Place it in `android/app/` directory

**Error: "Agora App ID not configured"**
- Make sure you're running with `--dart-define=AGORA_APP_ID=your_id`
- Check that your Agora App ID is correct

### Runtime Issues

**Permissions denied**
- Ensure all permissions are granted in Android settings
- Check `AndroidManifest.xml` has all required permissions

**Call not connecting**
- Verify both users have internet connection
- Check Firebase Firestore rules are correctly configured
- Ensure Agora App ID is valid

**No audio/video**
- Check microphone/camera permissions
- Verify Agora project has video enabled
- Test with different devices

## Production Deployment

### 1. Update `google-services.json`

Use the production Firebase project's configuration file.

### 2. Configure Agora for Production

- Get production App ID from Agora Console
- Configure token authentication (recommended for production)
- Update build commands with production App ID

### 3. Build Release APK

```bash
flutter build apk --dart-define=AGORA_APP_ID=production_app_id --release
```

### 4. Build App Bundle (for Play Store)

```bash
flutter build appbundle --dart-define=AGORA_APP_ID=production_app_id --release
```

## License

This project is for educational purposes.

## Support

For issues or questions, please refer to:
- [Flutter Documentation](https://docs.flutter.dev/)
- [Firebase Documentation](https://firebase.google.com/docs)
- [Aora Documentation](https://docs.agora.io/en/)
