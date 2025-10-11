import '../../domain/entities.dart';
import '../stores.dart';

class RegisterPriceAlert {
  RegisterPriceAlert(this.userStore);

  final UserStore userStore;

  void call(PriceAlert alert) {
    userStore.addAlert(alert);
  }
}
