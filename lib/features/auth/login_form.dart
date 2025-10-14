import 'package:flutter/material.dart';

import '../../core/utils/validators.dart';

typedef AuthCallback = Future<void> Function(String email, String password);

typedef VoidAsyncCallback = Future<void> Function();

class LoginForm extends StatefulWidget {
  const LoginForm({super.key, required this.onSubmit, required this.onForgot});

  final AuthCallback onSubmit;
  final VoidAsyncCallback onForgot;

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await widget.onSubmit(_emailController.text.trim(), _passwordController.text);
    if (mounted) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            validator: Validators.requireEmail,
            decoration: const InputDecoration(labelText: 'Email'),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            validator: Validators.requirePassword,
            decoration: const InputDecoration(labelText: 'Password'),
          ),
          const SizedBox(height: 16),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: widget.onForgot, child: const Text('Forgot password?')),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: _loading
                  ? const CircularProgressIndicator.adaptive()
                  : const Text('Log in'),
            ),
          ),
        ],
      ),
    );
  }
}
