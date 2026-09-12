import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../services/calling_service.dart';
import '../services/permission_service.dart';
import '../services/notification_service.dart';
import '../services/push_service.dart';
import '../models/user.dart';
import '../models/call.dart';

// ── Service Providers ─────────────────────────────────────────────────────

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final userServiceProvider = Provider<UserService>((ref) => UserService());

/// CallingService is a ChangeNotifier — use ChangeNotifierProvider so widgets
/// rebuild when notifyListeners() is called (mute state, connection state, etc.)
final callingServiceProvider = ChangeNotifierProvider<CallingService>((ref) {
  final service = CallingService();
  ref.onDispose(() => service.dispose());
  return service;
});

final permissionServiceProvider =
    Provider<PermissionService>((ref) => PermissionService());

final notificationServiceProvider =
    ChangeNotifierProvider<NotificationService>((ref) {
  final service = NotificationService();
  ref.onDispose(() => service.dispose());
  return service;
});

final pushServiceProvider =
    Provider<PushService>((ref) => PushService());

// ── Auth / User Providers ─────────────────────────────────────────────────

/// Raw Firebase auth state stream.
final currentUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Current logged-in user as a UserModel, updated in real time from Firestore.
final currentUserModelProvider = StreamProvider<UserModel?>((ref) {
  return ref.watch(authServiceProvider).currentUserModelStream();
});

// ── Agora App ID ──────────────────────────────────────────────────────────

/// Agora App ID passed via --dart-define=AGORA_APP_ID=xxx at build time.
final agoraAppIdProvider = Provider<String>((ref) {
  const id = String.fromEnvironment('AGORA_APP_ID', defaultValue: '6571d2b8e21a44c195b0ab99363253c8');
  return id;
});

// ── Users / Contacts ──────────────────────────────────────────────────────

final usersListProvider =
    StreamProvider.family<List<UserModel>, String>((ref, currentUserId) {
  return ref.watch(userServiceProvider).getUsers(currentUserId);
});

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredUsersProvider =
    Provider.family<List<UserModel>, String>((ref, currentUserId) {
  final usersAsync = ref.watch(usersListProvider(currentUserId));
  final query = ref.watch(searchQueryProvider);
  final userService = ref.watch(userServiceProvider);

  return usersAsync.when(
    data: (users) => userService.filterUsersByName(users, query),
    loading: () => [],
    error: (_, __) => [],
  );
});

// ── Call Providers ────────────────────────────────────────────────────────

/// Incoming calls for the current user (callee side).
final incomingCallsProvider =
    StreamProvider.family<CallModel?, String>((ref, currentUserId) {
  return ref.watch(callingServiceProvider).listenForIncomingCalls(currentUserId);
});

/// Real-time status of a specific call document.
final callStatusProvider =
    StreamProvider.family<CallModel?, String>((ref, callId) {
  return ref.watch(callingServiceProvider).listenToCallStatus(callId);
});

/// Full call history for a user.
final callHistoryProvider =
    StreamProvider.family<List<CallModel>, String>((ref, userId) {
  return ref.watch(callingServiceProvider).getCallHistory(userId);
});
