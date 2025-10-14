import 'auction_repo.dart';
import 'wanted_repo.dart';
import 'user_repo.dart';

class RepoProvider {
  RepoProvider._();

  static final AuctionRepository auctionRepository = AuctionRepository();
  static final WantedRepository wantedRepository = WantedRepository();
  static final UserRepository userRepository = UserRepository();
}
