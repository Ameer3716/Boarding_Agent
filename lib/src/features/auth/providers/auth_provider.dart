import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/constants/app_constants.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../repositories/user_repository.dart';

// Auth State Provider
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Current User Provider
final currentUserProvider = StreamProvider<UserModel?>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return authState.when(
    data: (user) {
      if (user == null) return Stream.value(null);
      return ref.read(userRepositoryProvider).getUserStream(user.uid);
    },
    loading: () => Stream.value(null),
    error: (_, __) => Stream.value(null),
  );
});

// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository();
});

// User Repository Provider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

// Auth Controller Provider
final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(
    authRepository: ref.read(authRepositoryProvider),
    userRepository: ref.read(userRepositoryProvider),
  );
});

// Auth State
class AuthState {
  final bool isLoading;
  final String? error;
  final bool isSignedIn;

  const AuthState({
    this.isLoading = false,
    this.error,
    this.isSignedIn = false,
  });

  AuthState copyWith({
    bool? isLoading,
    String? error,
    bool? isSignedIn,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      isSignedIn: isSignedIn ?? this.isSignedIn,
    );
  }
}

// Auth Controller
class AuthController extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;
  final UserRepository _userRepository;

  AuthController({
    required AuthRepository authRepository,
    required UserRepository userRepository,
  }) : _authRepository = authRepository,
       _userRepository = userRepository,
       super(const AuthState());

  Future<void> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final userCredential = await _authRepository.signInWithEmail(email, password);
      if (userCredential.user != null) {
        state = state.copyWith(isLoading: false, isSignedIn: true);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signUpWithEmail(String email, String password, String displayName) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final userCredential = await _authRepository.signUpWithEmail(email, password);
      if (userCredential.user != null) {
        // Create user profile
        final userModel = UserModel(
          id: userCredential.user!.uid,
          email: email,
          displayName: displayName,
          experienceLevel: 'beginner',
          role: AppConstants.roleRegular,
          totalPoints: 0,
          rank: 0,
          isBlackcardMember: false,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          isOnboardingComplete: false,
        );
        
        await _userRepository.createUser(userModel);
        state = state.copyWith(isLoading: false, isSignedIn: true);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signInWithGoogle() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final userCredential = await _authRepository.signInWithGoogle();
      if (userCredential?.user != null) {
        // Check if user exists, if not create profile
        final existingUser = await _userRepository.getUser(userCredential!.user!.uid);
        if (existingUser == null) {
          final userModel = UserModel(
            id: userCredential.user!.uid,
            email: userCredential.user!.email ?? '',
            displayName: userCredential.user!.displayName ?? '',
            photoURL: userCredential.user!.photoURL,
            experienceLevel: 'beginner',
            role: AppConstants.roleRegular,
            totalPoints: 0,
            rank: 0,
            isBlackcardMember: false,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            isOnboardingComplete: false,
          );
          
          await _userRepository.createUser(userModel);
        }
        
        state = state.copyWith(isLoading: false, isSignedIn: true);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _authRepository.signOut();
      state = state.copyWith(isLoading: false, isSignedIn: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> resetPassword(String email) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _authRepository.resetPassword(email);
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}