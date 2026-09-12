# ConnectCall 📞

> **"Connect with anyone, anywhere. A premium, seamless, and secure communication experience."**

![ConnectCall Banner](assets/logo/connectcall_banner.png)

Welcome to the **ConnectCall** repository! ConnectCall is a fully functional, real-time 1-to-1 audio and video calling application built with Flutter. It was developed to provide an unparalleled user experience, featuring a premium glassmorphic UI, robust state management, and real-time backend integration.

This project was developed as part of a Flutter Development Intern Assignment to demonstrate absolute proficiency in UI/UX design, advanced state management, complex API integrations, device hardware handling, and real-time communication technologies.

---

## 📖 Table of Contents
1. [Project Overview](#-project-overview)
2. [UI & Design Philosophy](#-ui--design-philosophy)
3. [Features Detailed Breakdown](#-features-detailed-breakdown)
4. [Architecture & Design Patterns](#-architecture--design-patterns)
5. [State Management Approach](#-state-management-approach)
6. [Database Structure](#-database-structure)
7. [Tech Stack & Dependencies](#-tech-stack--dependencies)
8. [Comprehensive Setup Guide](#-comprehensive-setup-guide)
9. [Known Limitations & Future Roadmap](#-known-limitations--future-roadmap)
10. [AI Tools Used](#-ai-tools-used)
11. [License](#-license)

---

## 🌟 Project Overview

In today's fast-paced world, reliable communication is key. ConnectCall bridges the gap by offering high-definition audio and video calling capabilities wrapped in an intuitive and beautiful interface. The application leverages Firebase for robust authentication and real-time data synchronization, alongside the Agora RTC SDK for ultra-low latency media streaming.

The ultimate goal of this project is to showcase production-ready Flutter code that adheres to industry best practices, including clean architecture, modular component design, and reactive programming.

---

## 🎨 UI & Design Philosophy

The application utilizes a **Glassmorphic** design language natively. Instead of relying on traditional flat design or material surfaces, ConnectCall employs frosted glass effects, subtle gradients, and rich deep background animations (GIFs) to create a premium, immersive experience.

- **Permanent Dark Mode**: The app is designed exclusively in a dark theme to reduce eye strain and highlight the vibrant gradients and caller avatars.
- **Micro-interactions**: Buttons feature scale animations and haptic feedback to ensure the interface feels responsive and alive.
- **Consistent Typography**: Typography is scaled appropriately across all devices to maintain readability.

---

## 🚀 Features Detailed Breakdown

All mandatory requirements for the assignment have been met, along with several high-value bonus features.

### Core Features (Mandatory)

1. **Secure Authentication System**
   - **Email/Password**: Standard registration and login flows with field validation.
   - **Google Sign-In**: Seamless one-tap login integration via Google OAuth.
   - **Session Persistence**: Users remain logged in across app restarts.

2. **Real-time Home & Contacts Dashboard**
   - Live stream of all registered users on the platform.
   - **Presence System**: Dynamic indicator showing whether a user is currently "Online" or "Offline".
   - **Quick Actions**: One-tap shortcuts to initiate audio or video calls directly from the list.

3. **High-Definition Audio Calling**
   - 1-to-1 voice calls using Agora RTC.
   - **Controls**: Mute/Unmute microphone, toggle speakerphone, and end call.
   - **UI**: Full-screen immersive call interface with animated avatars.

4. **High-Definition Video Calling**
   - 1-to-1 video calls with adaptive bitrate streaming.
   - **Controls**: Disable/Enable camera, switch between front and rear cameras, and mute audio.
   - **UI**: Picture-in-Picture (PiP) style local preview overlapping the remote user's full-screen video stream.

5. **Advanced Call State Management**
   - **Incoming/Ringing**: Distinct UI for incoming calls with accept/decline slide-to-answer mechanics.
   - **Connected**: Dynamic in-call controls that slide up from the bottom.
   - **Missed/Rejected**: Graceful tear-down of the RTC engine and navigation back to the home screen if the remote user hangs up or rejects the call.

6. **Comprehensive Call History**
   - Detailed log of all incoming, outgoing, and missed calls.
   - Visual indicators for Audio vs. Video calls.
   - Displays accurate call durations in minutes/seconds and human-readable timestamps (e.g., "Today, 11:30 PM").
   - Swipe-to-delete functionality for individual call records.

7. **Hardware Permissions Handling**
   - Graceful, localized requests for Microphone and Camera permissions.
   - Granular toggle switches in the Profile settings to manually revoke or request permissions.
   - Direct deep-linking to device App Settings if permissions are permanently denied.

### Bonus Features Implemented ⭐

- **Bonus 1 — Push Notifications (FCM)**: Integrated Firebase Cloud Messaging to instantly notify the callee when a call is initiated.
- **Bonus 2 — Background Call Notifications**: Uses `flutter_local_notifications` with full-screen intents. This ensures that even if the app is killed or running in the background, an incoming call will wake up the screen and show a native-like ringing UI.
- **Bonus 3 — Permanent Dark Mode**: Implemented a stunning glassmorphic dark theme out-of-the-box.
- **Bonus 9 — Network Quality Indicators**: Real-time monitoring of uplink/downlink quality via Agora SDK. Displays a dynamic "HD Video" / "SD Video" / "Poor Connection" pill during active calls.
- **Bonus Feature — Multi-Language Support**: Fully localized into English and Hindi, dynamically switchable at runtime without app restart.

---

## 🏗️ Architecture & Design Patterns

The project strictly follows a **Feature-First / Layered Architecture** to ensure high scalability, maintainability, and clear separation of concerns.

```text
lib/
├── components/      # Reusable, stateless UI widgets (AppButton, GlassmorphicContainer, Tiles)
├── l10n/            # Localization and string resources (app_translations.dart)
├── models/          # Data models (UserModel, CallModel) with fromMap/toMap serialization logic
├── providers/       # Riverpod providers for global state, dependency injection, and streams
├── screens/         # Stateful UI screens (Auth, Home, Call, Profile, Splash)
├── services/        # Core business logic classes (AuthService, CallingService, PushService)
└── main.dart        # Application entry point, Firebase init, and routing
```

### Layer Breakdown
- **Presentation Layer (`screens/`, `components/`)**: Purely concerned with UI rendering and user input. No direct Firebase or Agora calls are made here.
- **State Management Layer (`providers/`)**: Acts as the glue between the UI and Services. UI components listen to these providers.
- **Service Layer (`services/`)**: Contains all external integrations (Firebase Auth, Firestore DB, Agora Engine).
- **Data Layer (`models/`)**: Defines the shape of the data flowing through the app.

---

## 🧠 State Management Approach

**Riverpod (`flutter_riverpod`)** was chosen as the singular state management solution for this project.

### Why Riverpod?
1. **Compile-time Safety**: Prevents the dreaded `ProviderNotFoundException` common with standard Provider.
2. **Reactive Streams**: Simplifies consumption of Firebase Firestore streams. `StreamProvider` is used heavily to rebuild the UI instantly when a user comes online or a call status changes in the database.
3. **Global Dependency Injection**: Services like `AuthService` and `CallingService` are instantiated once as global providers, making them easily accessible anywhere in the widget tree without passing parameters.
4. **Testing & Mocking**: Providers can easily be overridden for widget testing.

---

## 🗄️ Database Structure (Firestore)

ConnectCall utilizes a highly normalized NoSQL structure in Firebase Firestore.

### Collection: `users`
Stores all registered users.
- `uid` (String): Unique Firebase Auth ID.
- `name` (String): Display name.
- `email` (String): User's email address.
- `photoUrl` (String?): Profile avatar URL.
- `isOnline` (Boolean): Current presence status.
- `fcmToken` (String?): Device token for push notifications.
- `lastSeen` (Timestamp): Timestamp of last activity.

### Collection: `calls`
Stores the active signaling state and historical log of calls.
- `callId` (String): Unique UUID for the call (also used as Agora Channel Name).
- `callerId` (String) / `calleeId` (String): User IDs.
- `callerName` (String) / `calleeName` (String): Display names.
- `type` (String): "audio" or "video".
- `status` (String): "ringing", "accepted", "rejected", "missed", or "ended".
- `startTime` (Timestamp): When the call was initiated.
- `endTime` (Timestamp?): When the call concluded.
- `duration` (Number?): Duration of the call in seconds.

---

## 💻 Tech Stack & Dependencies

- **Framework**: Flutter 3.24+ (Dart 3.5+)
- **Backend & Database**: Firebase (Auth, Firestore, Cloud Messaging)
- **Calling Engine**: Agora RTC Engine (Selected for ultra-low latency and excellent Flutter plugin support).

### Key Packages
- `agora_rtc_engine`: Core audio/video communication.
- `agora_token_service`: Used to generate dynamic tokens on the fly using App ID and Cert (No separate Node.js token server required!).
- `firebase_core`, `firebase_auth`, `cloud_firestore`: Backend infrastructure.
- `firebase_messaging`, `flutter_local_notifications`: Push notifications and background full-screen intents.
- `flutter_riverpod`: State management and DI.
- `google_sign_in`: OAuth authentication.
- `permission_handler`: Device hardware permissions handling.
- `uuid`: Generating unique call IDs.
- `intl`: Date and time formatting.

---

## 🛠️ Comprehensive Setup Guide

Follow these steps meticulously to get the app running locally on your machine.

### Prerequisites
1. Install [Flutter SDK](https://flutter.dev/docs/get-started/install).
2. Set up Android Studio and/or Xcode for emulator/simulator support.
3. Create a Firebase Project at [console.firebase.google.com](https://console.firebase.google.com).
4. Create an Agora Project at [console.agora.io](https://console.agora.io) (Make sure to enable App Certificate).

### 1. Clone the repository
```bash
git clone https://github.com/yourusername/connectcall.git
cd connectcall
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Environment Variables (.env)
The project relies on environment variables for sensitive API keys to prevent them from being committed to version control.
Create a `.env` file in the root of the project:
```env
AGORA_APP_ID=your_agora_app_id_here
AGORA_APP_CERT=your_agora_app_certificate_here
FIREBASE_PROJECT_ID=your_firebase_project_id_here
```
*(Note: The `CallingService` uses the `agora_token_service` package to generate permanent, dynamic tokens on the fly using your App ID and Cert. This completely bypasses the need for a separate backend token server!)*

### 4. Firebase Configuration
**Android:**
1. Register your Android app in the Firebase console (Package name: `com.example.connectcall`).
2. Download `google-services.json` and place it inside `android/app/`.

**Firebase Services Setup:**
1. **Authentication**: Enable Email/Password and Google provider.
2. **Firestore Database**: Create a database in production mode.
3. **Firestore Rules**: Deploy the following rules to allow authenticated reads/writes:
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId} {
         allow read, write: if request.auth != null;
       }
       match /calls/{callId} {
         allow read, write: if request.auth != null;
       }
     }
   }
   ```

### 5. Running the Application
Connect a physical device or start an emulator. (Note: Audio/Video functionality is best tested on physical devices).
```bash
flutter run
```

---

## ⚠️ Known Limitations & Future Roadmap

While the application is highly functional, a few limitations exist in this build:
- **Group Calling**: Currently restricted to 1-to-1 calls to maintain absolute stability and simplicity of the signaling logic.
- **Screen Sharing**: Not implemented in this iteration.
- **iOS Push Notifications**: Requires an active Apple Developer account and APNs certificate configuration in Firebase. The background wake-up functionality is currently optimized heavily for Android FCM and Full-Screen Intents.

### 🌟 Future Roadmap
We have exciting plans for ConnectCall! Here is what is on the horizon for future releases:
1. **Multi-User Rooms (Group Calling)**: Upgrading the Agora implementation to support multiple remote video streams dynamically.
2. **Real-time Chat**: Adding a text-based chat interface alongside calls, allowing users to share links and images during active sessions.
3. **Call Recording**: Integrating Agora Cloud Recording to allow users to record important meetings.
4. **End-to-End Encryption (E2EE)**: Enhancing privacy by implementing custom encryption keys for video and audio data streams.
5. **Cross-Platform Support**: Expanding testing and optimization to fully support Flutter Web and Desktop (Windows/macOS) platforms.

---

## 🛠️ Contribution Guidelines

We welcome contributions from the community! If you'd like to help improve ConnectCall, please follow these guidelines:

### How to Contribute
1. **Fork the Repository**: Start by forking the project to your own GitHub account.
2. **Create a Branch**: Create a new branch for your feature or bugfix (e.g., `feature/awesome-new-thing` or `fix/annoying-bug`).
3. **Commit your Changes**: Write clear, descriptive commit messages. Ensure your code follows standard Flutter linting rules.
4. **Push to your Fork**: Push the changes up to your forked repository.
5. **Open a Pull Request**: Submit a Pull Request (PR) to the `main` branch of the original repository. Include a detailed description of what your PR accomplishes.

### Code Style Requirements
- Always use `camelCase` for variables and methods.
- Always use `PascalCase` for class names.
- Always use `snake_case` for file names and directories.
- Prefer `const` constructors for widgets wherever possible to optimize rendering performance.
- Extract large widget trees into smaller, reusable components in the `lib/components` directory.

### Reporting Bugs
If you find a bug, please open an Issue on GitHub with:
- A clear description of the problem.
- Steps to reproduce the bug.
- Device information (Model, OS version).
- Flutter version used.

---

## 🤖 AI Tools Used

This project leveraged modern AI assistance to accelerate development and solve complex problems:
- **Google Gemini**: Assisted extensively with brainstorming the initial layered architecture, generating complex UI boilerplate for the glassmorphic components, and troubleshooting Android-specific permission and lifecycle bugs during the Agora SDK integration phase.
- **Code Structuring**: AI was used to ensure the `flutter_riverpod` state management tree was optimized and free of unnecessary rebuilds.
- *Note: All core business logic, state management architecture, and critical security implementations were thoroughly reviewed, written, and optimized manually by the developer to ensure they met production standards.*

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### What the MIT License entails:
- You are free to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software.
- You must include the original copyright notice and this permission notice in all copies or substantial portions of the Software.
- The software is provided "AS IS", without warranty of any kind.

Developed with ❤️ and Flutter.
