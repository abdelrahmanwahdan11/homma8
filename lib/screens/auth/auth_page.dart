import 'package:flutter/material.dart';

import '../../core/localization/language_manager.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/primary_button.dart';
import '../home/home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final ValueNotifier<bool> _isLoginNotifier;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _isLoginNotifier = ValueNotifier<bool>(true);
  }

  @override
  void dispose() {
    _isLoginNotifier.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _validate(LanguageManager lang) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (!email.contains('@')) {
      _showSnackBar(lang.t('invalid_email'));
      return false;
    }
    if (password.length < 6) {
      _showSnackBar(lang.t('password_length'));
      return false;
    }
    if (!_isLoginNotifier.value) {
      final confirm = _confirmPasswordController.text.trim();
      if (confirm != password) {
        _showSnackBar(lang.t('password_match'));
        return false;
      }
    }
    return true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _goToHome() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = LanguageManager.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(lang.t('welcome_back')),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: GlassCard(
          padding: const EdgeInsets.all(24),
          child: ValueListenableBuilder<bool>(
            valueListenable: _isLoginNotifier,
            builder: (context, isLogin, _) {
              return Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      lang.t(isLogin ? 'login' : 'register'),
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: lang.t('email')),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: lang.t('password')),
                      obscureText: true,
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isLogin
                          ? const SizedBox.shrink()
                          : Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: TextFormField(
                                controller: _confirmPasswordController,
                                decoration: InputDecoration(
                                  labelText: lang.t('confirm_password'),
                                ),
                                obscureText: true,
                              ),
                            ),
                    ),
                    const SizedBox(height: 24),
                    PrimaryButton(
                      label: lang.t(isLogin ? 'login' : 'register'),
                      icon: Icons.lock_open_rounded,
                      onPressed: () {
                        if (_validate(lang)) {
                          _goToHome();
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    OutlinedButton(
                      onPressed: () => _isLoginNotifier.value = !isLogin,
                      child: Text(
                        lang.t(isLogin ? 'register' : 'login'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _goToHome,
                      child: Text(lang.t('continue_guest')),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
