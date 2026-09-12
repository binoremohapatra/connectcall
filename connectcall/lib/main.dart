import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'providers/providers.dart';
import 'providers/locale_provider.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Initialize Firebase
  await Firebase.initializeApp();

  // Register background FCM handler BEFORE runApp (top-level requirement)
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final prefs = await SharedPreferences.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const ConnectCallApp(),
    ),
  );
}

class ConnectCallApp extends ConsumerStatefulWidget {
  const ConnectCallApp({super.key});

  @override
  ConsumerState<ConnectCallApp> createState() => _ConnectCallAppState();
}

class _ConnectCallAppState extends ConsumerState<ConnectCallApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Initialize notification service
      final notificationService = ref.read(notificationServiceProvider);
      await notificationService.initialize();

      // Initialize Agora engine early if App ID is configured
      final agoraAppId = ref.read(agoraAppIdProvider);
      if (agoraAppId.isNotEmpty) {
        final callingService = ref.read(callingServiceProvider);
        await callingService.initialize(appId: agoraAppId);
      }

      // Update FCM token for the currently logged-in user (if any)
      _updateFcmToken();
    });
  }

  Future<void> _updateFcmToken() async {
    try {
      final userAsync = await ref.read(currentUserModelProvider.future);
      if (userAsync != null) {
        final token = await ref.read(notificationServiceProvider).getFcmToken();
        if (token != null) {
          await ref.read(userServiceProvider).updateFcmToken(userAsync.uid, token);
        }
      }
    } catch (_) {
      // Non-fatal — token update will retry on next launch
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    _handleLifecycle(state);
  }

  Future<void> _handleLifecycle(AppLifecycleState state) async {
    try {
      final userAsync = await ref.read(currentUserModelProvider.future);
      if (userAsync == null) return;

      final userService = ref.read(userServiceProvider);
      switch (state) {
        case AppLifecycleState.resumed:
          await userService.setUserOnline(userAsync.uid, true);
          break;
        case AppLifecycleState.paused:
        case AppLifecycleState.detached:
        case AppLifecycleState.hidden:
          await userService.setUserOnline(userAsync.uid, false);
          break;
        case AppLifecycleState.inactive:
          break;
      }
    } catch (_) {
      // Non-fatal
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConnectCall',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      home: const SplashScreen(),
    );
  }

  ThemeData _buildTheme() {
    const seedColor = Color(0xFF6C63FF); // Vibrant indigo-violet
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: const Color(0xFF0F0E1A),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1A1930),
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1E1D2E),
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF252438),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF3D3B5E), width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: seedColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1),
        ),
        labelStyle: const TextStyle(color: Color(0xFF9A97C5)),
        hintStyle: const TextStyle(color: Color(0xFF6A6890)),
        prefixIconColor: const Color(0xFF9A97C5),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: seedColor,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: seedColor,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF1A1930),
        selectedItemColor: Color(0xFF6C63FF),
        unselectedItemColor: Color(0xFF6A6890),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
