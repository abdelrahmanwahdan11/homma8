import '../../core/result.dart';
import '../../domain/entities.dart';
import '../../domain/repositories.dart';

class CreateSellListing {
  CreateSellListing(this.repository);

  final SellRepository repository;

  Future<Result<String>> call(Product product) {
    return repository.postListing(product);
  }
}
