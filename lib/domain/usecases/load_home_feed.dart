import '../../data/models/auction.dart';
import '../../data/repos/auction_repo.dart';

class LoadHomeFeed {
  LoadHomeFeed(this._repo);

  final AuctionRepository _repo;

  Future<PagedResult<AuctionModel>> call(int pageKey, {int pageSize = 12}) {
    return _repo.fetchAuctions(pageKey: pageKey, pageSize: pageSize);
  }
}
