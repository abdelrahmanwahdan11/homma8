import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/app_scope.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _identity = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _remember = true;
  String? _error;

  @override
  void dispose() {
    _identity.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context)!;
    if (_identity.text.isEmpty || _password.text.length < 6) {
      setState(() {
        _error = l10n.password;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('⚠ ${l10n.password}')),
      );
      return;
    }
    final app = AppScope.of(context);
    app.login(identity: _identity.text, password: _password.text);
    if (app.isLoggedIn) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      setState(() {
        _error = l10n.password;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Card(
            elevation: 0,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(l10n.login, style: theme.textTheme.headlineSmall),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _identity,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: l10n.email_or_phone,
                      hintText: 'name@example.com',
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(labelText: l10n.password),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Switch(
                        value: _remember,
                        onChanged: (value) => setState(() => _remember = value),
                      ),
                      const SizedBox(width: 8),
                      Text(l10n.remember_me),
                      const Spacer(),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, '/forgot'),
                        child: Text(l10n.forgot_password),
                      ),
                    ],
                  ),
                  if (_error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        _error!,
                        style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
                      ),
                    ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _submit,
                    child: Text(l10n.login_cta),
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, '/signup'),
                    child: Text(l10n.create_account),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, '/guest'),
                    child: Text(l10n.guest),
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
