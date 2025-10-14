import 'package:flutter/material.dart';

import '../../core/localization/app_localizations.dart';
import '../../core/utils/validators.dart';

typedef SignupCallback = Future<void> Function(String name, String email, String password);

class SignupForm extends StatefulWidget {
  const SignupForm({super.key, required this.onSubmit});

  final SignupCallback onSubmit;

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await widget.onSubmit(
      _nameController.text.trim(),
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _nameController,
            validator: (value) => Validators.requireName(value, l10n: l10n),
            decoration: InputDecoration(labelText: l10n.fullName),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _emailController,
            validator: (value) => Validators.requireEmail(value, l10n: l10n),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(labelText: l10n.email),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            validator: (value) => Validators.requirePassword(value, l10n: l10n),
            decoration: InputDecoration(labelText: l10n.password),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmController,
            obscureText: true,
            validator: (value) => Validators.confirmPassword(value, _passwordController.text, l10n: l10n),
            decoration: InputDecoration(labelText: l10n.confirmPassword),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? const CircularProgressIndicator.adaptive()
                    : Text(l10n.signUp),
              ),
            ),
        ],
      ),
    );
  }
}
