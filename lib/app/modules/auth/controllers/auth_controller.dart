import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/utils/form_validators.dart';
import '../../../data/models/user.dart';
import '../../../routes/app_routes.dart';

class AuthController extends GetxController {
  final tabIndex = 0.obs;
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();
  final forgotFormKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final strength = 0.0.obs;
  final Rxn<User> user = Rxn<User>();

  void setTab(int index) {
    tabIndex.value = index;
  }

  String? validateEmail(String? value) => FormValidators.email(value);
  String? validatePassword(String? value) => FormValidators.password(value);
  String? validatePhone(String? value) => FormValidators.phone(value);

  void onPasswordChanged(String value) {
    strength.value = (value.length / 12).clamp(0.0, 1.0);
  }

  Future<void> login() async {
    if (!(loginFormKey.currentState?.validate() ?? false)) return;
    user.value = User(
      id: 'user-1',
      name: 'Alex Jordan',
      email: emailController.text,
      phone: '+9715000000',
      avatar: null,
      guest: false,
    );
    Get.offAllNamed(Routes.home);
  }

  Future<void> register() async {
    if (!(registerFormKey.currentState?.validate() ?? false)) return;
    if (passwordController.text != confirmPasswordController.text) {
      Get.snackbar('app_name'.tr, 'error_password_match'.tr);
      return;
    }
    user.value = User(
      id: 'user-registered',
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      avatar: null,
      guest: false,
    );
    Get.offAllNamed(Routes.home);
  }

  Future<void> continueAsGuest() async {
    user.value = User.guestUser();
    Get.snackbar('app_name'.tr, 'toast_guest_mode'.tr);
    Get.offAllNamed(Routes.home);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    phoneController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
  Future<void> sendReset() async {
    if (!(forgotFormKey.currentState?.validate() ?? false)) return;
    Get.snackbar('app_name'.tr, 'info_reset_sent'.tr);
  }
}
