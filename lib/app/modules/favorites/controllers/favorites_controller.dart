import 'package:get/get.dart';

import '../../../data/models/auction_item.dart';
import '../../../data/services/mock_data_service.dart';

class FavoritesController extends GetxController {
  FavoritesController(this._dataService);

  final MockDataService _dataService;

  List<AuctionItem> get favorites =>
      _dataService.items.where((element) => element.isFavorite).toList();
}
