import '../../core/result.dart';
import '../../domain/entities.dart';
import '../../domain/repositories.dart';
import '../stores.dart';

class CreateWantedItem {
  CreateWantedItem({required this.repository, required this.userStore});

  final SellRepository repository;
  final UserStore userStore;

  Future<Result<String>> call(WantedItem item) async {
    final result = await repository.postWanted(item);
    if (result is Success<String>) {
      userStore.addWanted(item);
    }
    return result;
  }
}
