import 'package:get/get.dart';

import '../../../data/models/price_alert.dart';
import '../../../data/services/mock_data_service.dart';

class AlertsController extends GetxController {
  AlertsController(this._dataService);

  final MockDataService _dataService;

  RxList<PriceAlert> get alerts => _dataService.alerts;
}
