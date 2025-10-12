import 'package:flutter/material.dart';

import '../../../app/router.dart';
import '../../../core/app_scope.dart';
import '../../../core/localization/l10n_extensions.dart';
import '../../../core/utils/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const SizedBox(height: 32),
              Hero(
                tag: 'logo_hero',
                child: Icon(Icons.diamond, size: 72, color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 24),
              Text(l10n.login, style: theme.textTheme.headlineMedium),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: l10n.email),
                validator: (value) => Validators.email(value) == null ? null : l10n.invalid,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: l10n.password,
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                ),
                obscureText: _obscure,
                validator: (value) => Validators.password(value) == null ? null : l10n.invalid,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final state = AppScope.of(context);
                    if (state.login(_emailController.text, _passwordController.text)) {
                      AppRouterDelegate.of(context).go('/swipe');
                    }
                  }
                },
                child: Text(l10n.login),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  final state = AppScope.of(context);
                  state.login('guest@bentobid.local', 'guest1234');
                  AppRouterDelegate.of(context).go('/swipe');
                },
                child: Text(l10n.guest),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => AppRouterDelegate.of(context).go('/auth/signup'),
                child: Text(l10n.createAccount),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
