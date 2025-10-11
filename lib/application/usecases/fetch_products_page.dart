import '../../core/errors.dart';
import '../../core/result.dart';
import '../../domain/entities.dart';
import '../../domain/repositories.dart';
import '../stores.dart';

class FetchProductsPage {
  FetchProductsPage(this.repository, this.store);

  final ProductRepository repository;
  final CatalogStore store;

  Future<void> call({bool append = true}) async {
    if (store.value.isLoading) return;
    store.startLoading();
    final result = await repository.fetchPage(store.value.page);
    if (result is Success<List<Product>>) {
      final products = result.data;
      if (products.isEmpty && !append) {
        store.setProducts(products, append: false);
        return;
      }
      store.setProducts(products, append: append);
    } else if (result is Failure<List<Product>>) {
      store.setError(result.error);
    }
  }
}
