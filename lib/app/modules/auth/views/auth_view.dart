import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/widgets/glass_card.dart';
import '../controllers/auth_controller.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [theme.colorScheme.primary, theme.colorScheme.secondary],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: GlassCard(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('app_name'.tr, style: theme.textTheme.headlineMedium),
                      const SizedBox(height: 24),
                      Wrap(
                        spacing: 12,
                        children: [
                          ChoiceChip(
                            label: Text('action_login'.tr),
                            selected: controller.tabIndex.value == 0,
                            onSelected: (_) => controller.setTab(0),
                          ),
                          ChoiceChip(
                            label: Text('action_register'.tr),
                            selected: controller.tabIndex.value == 1,
                            onSelected: (_) => controller.setTab(1),
                          ),
                          ChoiceChip(
                            label: Text('action_forgot_password'.tr),
                            selected: controller.tabIndex.value == 2,
                            onSelected: (_) => controller.setTab(2),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      if (controller.tabIndex.value == 0) _buildLoginForm(context),
                      if (controller.tabIndex.value == 1) _buildRegisterForm(context),
                      if (controller.tabIndex.value == 2) _buildForgotForm(context),
                      const SizedBox(height: 24),
                      if (controller.tabIndex.value != 2)
                        FilledButton.icon(
                          onPressed: controller.continueAsGuest,
                          icon: const Icon(Icons.visibility_off_outlined),
                          label: Text('action_continue_guest'.tr),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: controller.loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            controller: controller.emailController,
            decoration: InputDecoration(labelText: 'label_email'.tr),
            validator: (value) => controller.validateEmail(value)?.tr,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: controller.passwordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'label_password'.tr),
            validator: (value) => controller.validatePassword(value)?.tr,
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => controller.setTab(2),
              child: Text('action_forgot_password'.tr),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: controller.login,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            child: Text('action_login'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildRegisterForm(BuildContext context) {
    final theme = Theme.of(context);
    return Form(
      key: controller.registerFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller.nameController,
            decoration: InputDecoration(labelText: 'label_name'.tr),
            validator: (value) => value == null || value.isEmpty ? 'validation_required'.tr : null,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.emailController,
            decoration: InputDecoration(labelText: 'label_email'.tr),
            validator: (value) => controller.validateEmail(value)?.tr,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.phoneController,
            decoration: InputDecoration(labelText: 'label_phone'.tr),
            validator: (value) => controller.validatePhone(value)?.tr,
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.passwordController,
            obscureText: true,
            onChanged: controller.onPasswordChanged,
            decoration: InputDecoration(labelText: 'label_password'.tr),
            validator: (value) => controller.validatePassword(value)?.tr,
          ),
          const SizedBox(height: 8),
          Obx(
            () => LinearProgressIndicator(
              value: controller.strength.value,
              backgroundColor: theme.colorScheme.surfaceVariant,
              color: theme.colorScheme.primary,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: controller.confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(labelText: 'label_confirm_password'.tr),
            validator: (value) => value == controller.passwordController.text
                ? null
                : 'error_password_match'.tr,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: controller.register,
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            ),
            child: Text('action_register'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildForgotForm(BuildContext context) {
    return Form(
      key: controller.forgotFormKey,
      child: Column(
        children: [
          TextFormField(
            controller: controller.emailController,
            decoration: InputDecoration(labelText: 'label_email'.tr),
            validator: (value) => controller.validateEmail(value)?.tr,
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: controller.sendReset,
            child: Text('action_send_reset'.tr),
          ),
        ],
      ),
    );
  }
}
