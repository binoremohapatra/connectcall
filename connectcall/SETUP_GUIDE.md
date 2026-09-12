# ConnectCall — Setup Guide

## Prerequisites

| Tool | Version | Install |
|------|---------|---------|
| Flutter SDK | ≥ 3.5.0 | https://flutter.dev |
| Android Studio / VS Code | Latest | IDE + Android SDK |
| Node.js | ≥ 18 | https://nodejs.org |
| Firebase CLI | Latest | `npm install -g firebase-tools` |
| Agora Console account | Free | https://console.agora.io |
| Firebase account | Free | https://console.firebase.google.com |

---

## Step 1: Create Firebase Project

1. Go to https://console.firebase.google.com
2. Click **Add Project** → Name it "ConnectCall" → Continue
3. Enable Google Analytics (optional) → Create Project

### 1a. Enable Authentication
1. In Firebase Console → **Authentication** → **Get Started**
2. Click **Email/Password** → Enable → Save

### 1b. Create Firestore Database
1. **Firestore Database** → **Create database**
2. Choose **Start in test mode** (we'll apply real rules next)
3. Choose a region close to your users → Done

### 1c. Add Android App
1. **Project Settings** (gear icon) → **Add app** → Android
2. Android package name: `com.connectcall.connectcall`
3. App nickname: ConnectCall
4. Click **Register app**
5. **Download `google-services.json`** → Copy it to:
   ```
   d:\connectcall\connectcall\android\app\google-services.json
   ```
6. Skip the "Add Firebase SDK" steps (already in pubspec.yaml)

### 1d. Apply Firestore Security Rules
1. In Firebase Console → **Firestore Database** → **Rules** tab
2. Replace the default rules with the contents of `firestore.rules`
3. Click **Publish**

---

## Step 2: Get Agora App ID

1. Go to https://console.agora.io
2. Sign up / log in → Click **Create Project**
3. Project name: ConnectCall
4. Use case: Voice & Video Call
5. **Security**: Choose **Testing mode** (token-less) for development
6. Click **Submit**
7. Copy the **App ID** — you'll need it for every build command

---

## Step 3: Run the App

```powershell
# With your Agora App ID:
cd d:\connectcall\connectcall

# Debug run on a connected Android device:
flutter run --dart-define=AGORA_APP_ID=your_agora_app_id_here

# Build release APK (install on both phones):
flutter build apk --dart-define=AGORA_APP_ID=your_agora_app_id_here
```

The APK will be at: `build\app\outputs\flutter-apk\app-release.apk`

---

## Step 4: Deploy Firebase Cloud Function (for background FCM)

This enables incoming call notifications when the callee's app is in the background or killed.

```powershell
# Install Firebase CLI
npm install -g firebase-tools

# Log in to Firebase
firebase login

# Initialize Firebase in the project root
cd d:\connectcall\connectcall
firebase init

# Choose:
# [x] Functions
# [x] Firestore
# Select your ConnectCall project
# Language: JavaScript
# DO NOT overwrite existing files

# Install function dependencies
cd functions
npm install
cd ..

# Deploy the Cloud Function
firebase deploy --only functions

# Deploy Firestore rules
firebase deploy --only firestore:rules
```

> **Note**: The Cloud Function fires automatically whenever a new call document is created in Firestore. No additional code changes needed.

---

## Step 5: 8-Step Testing Protocol

1. **Install the APK** on two separate physical Android phones on different networks (WiFi + mobile data)
2. **Register** two different accounts, one per device
3. **User A** taps the video call button next to User B in the Contacts list
4. **User B's phone** — even if app is backgrounded — shows a full-screen incoming call notification *(requires Cloud Function deployed)*
5. **User B taps Accept** — both phones show live video and hear live audio
6. **Test controls**:
   - Mute/unmute audio ✓
   - Toggle camera on/off ✓
   - Switch front/back camera ✓
   - Toggle speaker/earpiece ✓
   - End call from either side — both screens close ✓
7. **Verify Call History** on both phones shows correct duration and status
8. **Network test**: Turn off WiFi mid-call → "Reconnecting..." banner appears → Call recovers (or shows "Connection Failed" gracefully)

---

## Troubleshooting

| Issue | Fix |
|-------|-----|
| `Agora App ID not configured` snackbar | Run with `--dart-define=AGORA_APP_ID=xxx` |
| No incoming call notification when app is killed | Deploy the Cloud Function (Step 4) |
| `google-services.json` error at build | Make sure you downloaded the real file from Firebase Console |
| Camera/microphone not working on device | Check app permissions in Android Settings |
| Firestore permission denied errors | Apply the Firestore security rules from Step 1d |
| Build fails with minSdk error | Already fixed — minSdk is now 21 |
| Two devices can't hear each other | Verify both are on different Agora UIDs; check Agora Console for channel activity |
