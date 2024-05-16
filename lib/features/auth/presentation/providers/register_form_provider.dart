//! 1 -State del provider

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';
import 'package:teslo_shop/features/auth/presentation/providers/auth_provider.dart';
import 'package:teslo_shop/features/shared/infrastructure/infrastructure.dart';

//! 3 - StateNotifierProviders - consumir afuera

final registerProvider =
    StateNotifierProvider.autoDispose<RegisterNotifier, RegisterState>((ref) {
  final registerCallback = ref.watch(authProvider.notifier).register;
  return RegisterNotifier(registerCallback: registerCallback);
});

//! 2 - Statenotifier implementations

class RegisterNotifier extends StateNotifier<RegisterState> {
  final Function(String, String, String) registerCallback;
  RegisterNotifier({required this.registerCallback}) : super(RegisterState());

  onFullnameChange(value) {
    final fullname = FullName.dirty(value);
    state = state.copyWith(
      fullname: fullname,
      isValid: Formz.validate([fullname, state.email, state.password]),
    );
  }

  onEmailChange(value) {
    final newEmail = Email.dirty(value);
    state = state.copyWith(
      email: newEmail,
      isValid: Formz.validate([newEmail, state.password]),
    );
  }

  onPasswordChange(value) {
    final newPassword = Password.dirty(value);
    state = state.copyWith(
      password: newPassword,
      isValid: Formz.validate([newPassword, state.email]),
    );
  }

  onRegisterSubmit() async {
    _toucheEveryField();
    if (!state.isValid) return;
    await registerCallback(state.email.value, state.password.value, state.fullname.value);
  }

  onRepeatPasswordChange(value) {
    final repeatPassword = Password.dirty(value);
    state = state.copyWith(
      repeatPassword: repeatPassword,
      isValid: Formz.validate([repeatPassword, state.password]) &&
          _passwordsMatch(state.password, repeatPassword),
    );
  }

  bool _passwordsMatch(Password password, Password repeatPassword) {
    return password.value == repeatPassword.value;
  }

  void _toucheEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final fullname = FullName.dirty(state.fullname.value);
    final repeatPassword = Password.dirty(state.repeatPassword.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      repeatPassword: repeatPassword,
      fullname: fullname,
      isValid: Formz.validate([email, password, fullname, repeatPassword]) &&
          _passwordsMatch(state.password, repeatPassword),
    );
  }
}

class RegisterState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final Password repeatPassword;
  final FullName fullname;

  RegisterState(
      {this.isPosting = false,
      this.isFormPosted = false,
      this.isValid = false,
      this.email = const Email.pure(),
      this.password = const Password.pure(),
      this.repeatPassword = const Password.pure(),
      this.fullname = const FullName.pure()});

  RegisterState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    Password? repeatPassword,
    FullName? fullname,
  }) =>
      RegisterState(
        isPosting: isPosting ?? this.isPosting,
        isFormPosted: isFormPosted ?? this.isFormPosted,
        isValid: isValid ?? this.isValid,
        email: email ?? this.email,
        password: password ?? this.password,
        repeatPassword: repeatPassword ?? this.repeatPassword,
        fullname: fullname ?? this.fullname,
      );

  @override
  String toString() {
    return '''
      RegisterState: 
        isPosting: $isPosting
        isFormPosted: $isFormPosted
        isValid: $isValid
        email: $email
        password: $password
        repeatPassword: $repeatPassword
        fullname: $fullname
 ''';
  }
}
