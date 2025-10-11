import '../core/result.dart';
import '../core/errors.dart';
import 'entities.dart';

abstract class ProductRepository {
  Future<Result<List<Product>>> fetchPage(int page);
  Stream<Result<Auction>> watchAuction(String productId);
  Future<Result<void>> placeBid(String productId, double amount);
}

abstract class UserRepository {
  Future<Result<void>> addToWatchlist(String productId);
  Future<Result<List<Product>>> getWatchlist();
  Future<Result<void>> setTargetPrice(WantedItem item);
}

abstract class SellRepository {
  Future<Result<String>> postListing(Product product);
  Future<Result<String>> postWanted(WantedItem wanted);
}
