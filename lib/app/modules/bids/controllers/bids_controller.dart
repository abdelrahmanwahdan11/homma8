import 'package:get/get.dart';

import '../../../data/models/auction_item.dart';
import '../../../data/models/bid.dart';
import '../../../data/services/mock_data_service.dart';

class BidsController extends GetxController {
  BidsController(this._dataService);

  final MockDataService _dataService;

  RxList<Bid> get bids => _dataService.bids;

  AuctionItem? itemFor(String id) =>
      _dataService.items.firstWhereOrNull((element) => element.id == id);
}
