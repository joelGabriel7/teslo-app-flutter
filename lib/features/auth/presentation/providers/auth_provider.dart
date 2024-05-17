import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:teslo_shop/features/auth/domain/domain.dart';
import 'package:teslo_shop/features/auth/infrastructure/infrastructure.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage.dart';
import 'package:teslo_shop/features/shared/infrastructure/services/key_value_storage_services_impl.dart';

//! Se crea el provider para el authNotifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = AuthRepositoryImpl();
  final keyValueStorageServices = KeyValueStorageServicesImpl();
  return AuthNotifier(
      authRepository: authRepository,
      keyValueStorageServices: keyValueStorageServices);
});

//! implementacion del authNotifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageServices keyValueStorageServices;

  AuthNotifier(
      {required this.keyValueStorageServices, required this.authRepository})
      : super(AuthState()) {
        checkAuthStatus();
      }

  Future<void> loginUser(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));

    try {
      final user = await authRepository.login(email, password);
      _setLoggedUser(user);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Error, please try again later');
    }
  }

  void register(String email, String password, String fullname) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final newUser = await authRepository.register(email, password, fullname);
      _setLoggedUser(newUser);
    } on CustomError catch (e) {
      logout(e.message);
    } catch (e) {
      logout('Somenthig happend with register, please try again later ');
    }
  }

  void checkAuthStatus() async {
    final token = await keyValueStorageServices.getValue<String>('token');
    if (token == null) return logout();
    try {
      final user = await authRepository.checkAuthStatus(token);
      _setLoggedUser(user);
    } catch (e) {
      logout();
    }
  }

  _setLoggedUser(User user) async {
    await keyValueStorageServices.setKeyValue('token', user.token);
    state = state.copyWith(
      status: AuthStatus.authenticated,
      user: user,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    keyValueStorageServices.removeKey('token');
    state = state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
        errorMessage: errorMessage);
  }
}

//! State
enum AuthStatus { checking, authenticated, unauthenticated }

class AuthState {
  final AuthStatus status;
  final User? user;
  final String errorMessage;

  AuthState({
    this.status = AuthStatus.checking,
    this.user,
    this.errorMessage = '',
  });

  AuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
        status: status ?? this.status,
        user: user ?? this.user,
        errorMessage: errorMessage ?? this.errorMessage,
      );
}
