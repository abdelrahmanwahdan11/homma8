import '../../core/result.dart';
import '../../domain/repositories.dart';
import '../stores.dart';

class PlaceBid {
  PlaceBid({required this.repository, required this.auctionStore});

  final ProductRepository repository;
  final AuctionStore auctionStore;

  Future<bool> call(String productId, double amount) async {
    auctionStore.setPlacingBid(true);
    final result = await repository.placeBid(productId, amount);
    auctionStore.setPlacingBid(false);
    if (result is Failure<void>) {
      auctionStore.setError(result.error);
      return false;
    }
    auctionStore.setError(null);
    return true;
  }
}
