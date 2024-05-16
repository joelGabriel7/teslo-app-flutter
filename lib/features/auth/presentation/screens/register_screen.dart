import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:teslo_shop/features/auth/presentation/providers/register_form_provider.dart';
import 'package:teslo_shop/features/shared/shared.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textStyles = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
          body: GeometricalBackground(
              child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            // Icon Banner
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                    onPressed: () {
                      if (!context.canPop()) return;
                      context.pop();
                    },
                    icon: const Icon(Icons.arrow_back_rounded,  size: 30, color: Colors.white)),
                const Spacer(flex: 1),
                Text('Crear cuenta',  style: textStyles.titleLarge?.copyWith(color: Colors.white)),
                const Spacer(flex: 2),
              ],
            ),

            const SizedBox(height: 50),

            Container(
              height: size.height -100, // 80 los dos sizebox y 100 el ícono
              width: double.infinity,
              decoration: BoxDecoration(
                color: scaffoldBackgroundColor,
                borderRadius:
                    const BorderRadius.only(topLeft: Radius.circular(100)),
              ),
              child: const _RegisterForm(),
            )
          ],
        ),
      ))),
    );
  }
}

class _RegisterForm extends ConsumerWidget {
  const _RegisterForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final registerFormProvider = ref.watch(registerProvider);

    final textStyles = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          // const SizedBox(height: 50),
          const Spacer(),
          Text('Nueva cuenta', style: textStyles.titleMedium),
          const SizedBox(height: 25),
          CustomTextFormField(
            label: 'Nombre completo',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(registerProvider.notifier).onFullnameChange,
            errorMessage: registerFormProvider.isFormPosted
                ? registerFormProvider.fullname.errorMessage
                : null,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Correo',
            keyboardType: TextInputType.emailAddress,
            onChanged: ref.read(registerProvider.notifier).onEmailChange,
            errorMessage: registerFormProvider.isFormPosted
                ? registerFormProvider.email.errorMessage
                : null,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Contraseña',
            obscureText: true,
            onChanged: ref.read(registerProvider.notifier).onPasswordChange,
            errorMessage: registerFormProvider.isFormPosted
                ? registerFormProvider.password.errorMessage
                : null,
          ),
          const SizedBox(height: 30),
          CustomTextFormField(
            label: 'Repita la contraseña',
            obscureText: true,
            onChanged: ref.read(registerProvider.notifier).onRepeatPasswordChange,
            errorMessage: registerFormProvider.isFormPosted
                ? (registerFormProvider.repeatPassword.errorMessage ?? (registerFormProvider.password.value != registerFormProvider.repeatPassword.value ? 'Las contraseñas no coinciden' : null))
                : null,
          ),
          const SizedBox(height: 20),
          SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                  text: 'Crear',
                  buttonColor: Colors.black,
                  onPressed: () {
                    ref.read(registerProvider.notifier).onRegisterSubmit();
                  })),
          // const Spacer(flex: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('¿Ya tienes cuenta?'),
              TextButton(
                  onPressed: () {
                    if (context.canPop()) {
                      return context.pop();
                    }
                    context.go('/login');
                  },
                  child: const Text('Ingresa aquí'))
            ],
          ),
          const Spacer(flex: 1),
        ],
      ),
    );
  }
}
