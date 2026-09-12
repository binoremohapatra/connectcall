# ConnectCall 📞

> **"Connect with anyone, anywhere."**

ConnectCall is a fully functional, real-time 1-to-1 audio and video calling application built with Flutter. It features a premium, glassmorphic UI, robust state management, and real-time backend integration. This project was developed as part of a Flutter Development Intern Assignment to demonstrate proficiency in UI/UX, state management, API integration, and real-time communication technologies.

---

## 🌟 Features (All Assignment Requirements Met)

### Core Features (Mandatory)
- **Authentication**: Secure Email/Password registration and login, plus Google Sign-In integration.
- **Home & Contacts**: Real-time list of registered users indicating whether they are Online or Offline.
- **Audio Calling**: 1-to-1 high-quality voice calls with mute, speakerphone, and end call controls.
- **Video Calling**: 1-to-1 HD video calling with local preview, remote video rendering, mute, camera toggle, and front/rear camera switching.
- **Call States & UI**: Graceful handling of Incoming, Ringing, Connected, Missed, and Rejected call states with appropriate full-screen UI.
- **Call History**: Detailed history of all past calls including caller/callee names, call type (Audio/Video), timestamps, duration, and missed call indicators.
- **Permissions Handling**: Automatic and graceful requests for Microphone and Camera permissions before initiating or accepting calls.
- **Error Handling**: Comprehensive snackbar alerts for network issues, denied permissions, and rejected calls.

### Bonus Features Implemented ⭐
- **Bonus 1 — Push Notifications**: Integrated Firebase Cloud Messaging (FCM) to trigger local ringing UI when a call is received.
- **Bonus 2 — Call Notifications (Background)**: Uses `flutter_local_notifications` with full-screen intents to wake up the device and show the incoming call screen even when the app is in the background or the screen is locked.
- **Bonus 3 — Dark Mode**: The app utilizes a premium, dark-themed glassmorphic design language natively, acting as a permanent and beautiful Dark Mode.
- **Bonus 9 — Network Quality**: Real-time network quality monitoring using Agora's event handlers, displaying a "HD Video" or "HD Audio" pill that updates dynamically.

---

## 🏗️ Architecture

The project follows a **Feature-First / Layered Architecture** to ensure high scalability, maintainability, and clear separation of concerns.

```text
lib/
├── components/      # Reusable, stateless UI widgets (AppButton, GlassmorphicContainer, Tiles)
├── l10n/            # Localization and string resources
├── models/          # Data models (UserModel, CallModel) with serialization logic
├── providers/       # Riverpod providers for global state, dependency injection, and streams
├── screens/         # Stateful UI screens (Auth, Home, Call, Profile, Splash)
├── services/        # Core business logic (AuthService, CallingService, PushService)
└── main.dart        # Application entry point, Firebase init, and routing
```

### 🧠 State Management: `flutter_riverpod`
**Riverpod** was chosen as the state management solution because:
1. **Compile-time safety**: Prevents `ProviderNotFoundException` issues common with standard Provider.
2. **Reactive Streams**: Easily consumes Firebase Firestore streams (`StreamProvider`) to rebuild the UI instantly when a user comes online or a call is initiated.
3. **Dependency Injection**: Services (`AuthService`, `CallingService`) are injected via providers, making them globally accessible without passing them down the widget tree.

---

## 💻 Tech Stack & Configuration

- **Flutter Version**: Flutter 3.24+ (Dart 3.5+)
- **Backend**: **Firebase** (Authentication, Firestore Realtime Database, Cloud Messaging)
- **Calling SDK**: **Agora RTC Engine** (Selected for its ultra-low latency, excellent Flutter support, and built-in network quality listeners).

### Key Packages Used
- `agora_rtc_engine` & `agora_token_service`: Real-time audio/video communication and dynamic token generation.
- `firebase_core`, `firebase_auth`, `cloud_firestore`: Backend infrastructure.
- `firebase_messaging` & `flutter_local_notifications`: Push notifications and background wake-up.
- `flutter_riverpod`: State management.
- `google_sign_in`: OAuth authentication.
- `permission_handler`: Device hardware permissions.
- `shared_preferences`: Local caching for last-dialed numbers and UI state.

---

## 🚀 Setup Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/connectcall.git
   cd connectcall
   ```

2. **Install Dependencies**
   ```bash
   flutter pub get
   ```

3. **Environment Variables**
   Create a `.env` file in the root of the project to configure Agora (Using App ID and App Certificate for dynamic token generation):
   ```env
   AGORA_APP_ID=your_agora_app_id
   AGORA_APP_CERT=your_agora_app_certificate
   FIREBASE_PROJECT_ID=your_firebase_project_id
   ```
   *(Note: The `CallingService` uses the `agora_token_service` package to generate permanent, dynamic tokens on the fly using your App ID and Cert. No separate token server is required for this build!)*

4. **Firebase Configuration**
   - Add your `google-services.json` to `android/app/` and `GoogleService-Info.plist` to `ios/Runner/`.
   - Ensure **Email/Password** and **Google Sign-In** are enabled in Firebase Authentication.
   - Deploy the required Firestore Rules.

5. **Run the App**
   ```bash
   flutter run
   ```

---

## ⚠️ Known Limitations
- **Group Calling & Screen Sharing**: Not implemented in this build to maintain absolute stability for the 1-to-1 calling core functionality.
- **iOS Push Notifications**: Requires an active Apple Developer account and APNs certificate configuration in Firebase, which is currently optimized primarily for Android FCM.

---

## 🤖 AI Tools Used
- **Google Gemini**: Assisted with brainstorming the initial architecture, generating the glassmorphic UI layout code, and troubleshooting Android-specific permission and lifecycle bugs during Agora SDK integration. All core logic and implementation were thoroughly reviewed and understood.
