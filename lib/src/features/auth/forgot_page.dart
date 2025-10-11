import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgotPage extends StatelessWidget {
  const ForgotPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final TextEditingController controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgot_password)),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: controller,
              decoration: InputDecoration(labelText: l10n.email_or_phone),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم الإرسال (محاكاة)')),
                );
              },
              child: const Text('إرسال رابط/رمز الاستعادة'),
            ),
          ],
        ),
      ),
    );
  }
}
