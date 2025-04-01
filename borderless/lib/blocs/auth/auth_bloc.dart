import 'package:flutter_bloc/flutter_bloc.dart';
import 'auth_event.dart';
import 'auth_state.dart';
import '../../services/auth_service.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthService _authService;

  AuthBloc({required AuthService authService})
      : _authService = authService,
        super(const AuthInitial()) {
    on<Login>(_onLogin);
    on<Logout>(_onLogout);
    on<SignUp>(_onSignUp);
    on<GoogleSignIn>(_onGoogleSignIn);
    on<CheckAuth>(_onCheckAuth);
  }

  Future<void> _onLogin(Login event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final result = await _authService.signInWithEmail(event.email, event.password);
      if (result != null && result.containsKey('user')) {
        final user = result['user'];
        emit(Authenticated(
          userId: user.uid,
          name: user.displayName ?? 'User',
          email: user.email ?? event.email,
        ));
      } else {
        emit(AuthError(result?['error'] ?? 'Login failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogout(Logout event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      await _authService.signOut();
      emit(const Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUp(SignUp event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final result = await _authService.signUpWithEmail(
        event.email,
        event.password,
        event.name,
      );
      if (result != null && result.containsKey('user')) {
        final user = result['user'];
        emit(Authenticated(
          userId: user.uid,
          name: event.name,
          email: event.email,
        ));
      } else {
        emit(AuthError(result?['error'] ?? 'Sign-up failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onGoogleSignIn(GoogleSignIn event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final result = await _authService.signInWithGoogle();
      if (result != null && result.containsKey('user')) {
        final user = result['user'];
        emit(Authenticated(
          userId: user.uid,
          name: user.displayName ?? 'Google User',
          email: user.email ?? '',
        ));
      } else {
        emit(AuthError(result?['error'] ?? 'Google Sign-In failed'));
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onCheckAuth(CheckAuth event, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    try {
      final user = _authService.currentUser;
      if (user != null) {
        emit(Authenticated(
          userId: user.uid,
          name: user.displayName ?? 'User',
          email: user.email ?? '',
        ));
      } else {
        emit(const Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}