import 'dart:math';

import 'package:flutter/material.dart';

import '../../core/app_state.dart';
import '../../core/localization/language_manager.dart';
import '../../data/models.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/gradient_background.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final ValueNotifier<bool> _isLogin = ValueNotifier(true);
  bool _autoValidate = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _isLogin.dispose();
    super.dispose();
  }

  bool _isValidEmail(String value) {
    return value.contains('@') && value.contains('.');
  }

  bool _isValidPassword(String value) {
    final hasLength = value.length >= 8;
    final hasLetter = value.contains(RegExp(r'[A-Za-z]'));
    final hasNumber = value.contains(RegExp(r'[0-9]'));
    return hasLength && hasLetter && hasNumber;
  }

  void _submit(BuildContext context) {
    setState(() {
      _autoValidate = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      final session = UserSession(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _isLogin.value ? 'SouqBid User' : 'New Bidder',
        email: _emailController.text,
        avatar:
            'https://api.dicebear.com/7.x/initials/svg?seed=${_emailController.text}',
        rating: 4 + Random().nextDouble(),
      );
      AppState.of(context).setSession(session);
      Navigator.of(context)
          .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    }
  }

  void _guest(BuildContext context) {
    final session = UserSession(
      id: 'guest',
      name: LanguageManager.of(context).t('guest'),
      email: 'guest@souqbid.app',
      avatar: 'https://api.dicebear.com/7.x/initials/svg?seed=guest',
      rating: 0,
      isGuest: true,
    );
    AppState.of(context).setSession(session);
    Navigator.of(context)
        .pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lang = LanguageManager.of(context);

    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Hero(
                    tag: 'app_logo',
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.primary.withOpacity(0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.25),
                            blurRadius: 24,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Text(
                          'SB',
                          style: theme.textTheme.displayLarge?.copyWith(
                            color: theme.colorScheme.onPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    lang.t('welcome_back'),
                    style: theme.textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 24),
                  GlassContainer(
                    padding: const EdgeInsets.all(24),
                    child: ValueListenableBuilder<bool>(
                      valueListenable: _isLogin,
                      builder: (context, isLogin, child) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  isLogin
                                      ? lang.t('login')
                                      : lang.t('register'),
                                  style: theme.textTheme.titleMedium,
                                ),
                                Switch(
                                  value: isLogin,
                                  onChanged: (value) {
                                    _isLogin.value = value;
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Form(
                              key: _formKey,
                              autovalidateMode: _autoValidate
                                  ? AutovalidateMode.onUserInteraction
                                  : AutovalidateMode.disabled,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: InputDecoration(
                                      labelText: lang.t('email'),
                                    ),
                                    validator: (value) {
                                      if (value == null || !_isValidEmail(value)) {
                                        return lang.t('invalid_email');
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 16),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      labelText: lang.t('password'),
                                    ),
                                    validator: (value) {
                                      if (value == null || !_isValidPassword(value)) {
                                        return lang.t('invalid_password');
                                      }
                                      return null;
                                    },
                                  ),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 300),
                                    child: isLogin
                                        ? const SizedBox.shrink()
                                        : Padding(
                                            padding:
                                                const EdgeInsets.only(top: 16),
                                            child: TextFormField(
                                              controller: _confirmController,
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                labelText:
                                                    lang.t('confirm_password'),
                                              ),
                                              validator: (value) {
                                                if (!isLogin &&
                                                    value !=
                                                        _passwordController
                                                            .text) {
                                                  return lang
                                                      .t('password_mismatch');
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton(
                              onPressed: () => _submit(context),
                              child:
                                  Text(isLogin ? lang.t('login') : lang.t('register')),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton(
                              onPressed: () => _guest(context),
                              child: Text(lang.t('continue_guest')),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
