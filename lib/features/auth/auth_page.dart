import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import 'guest_gate.dart';
import 'login_form.dart';
import 'signup_form.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.onGuest});

  final Future<void> Function() onGuest;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n['app_title']),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Login'),
            Tab(text: 'Sign up'),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 360,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    LoginForm(
                      onSubmit: (email, password) async {
                        await Future<void>.delayed(const Duration(milliseconds: 400));
                        await widget.onGuest();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Logged in (mock)')));
                        }
                      },
                      onForgot: () async {
                        await Future<void>.delayed(const Duration(milliseconds: 400));
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reset link sent (mock)')));
                        }
                      },
                    ),
                    SignupForm(
                      onSubmit: (name, email, password) async {
                        await Future<void>.delayed(const Duration(milliseconds: 400));
                        await widget.onGuest();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Account created (mock)')));
                        }
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              GuestGate(onGuest: () async {
                await widget.onGuest();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Guest mode activated')));
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
