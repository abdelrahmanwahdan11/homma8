import '../stores.dart';

class SkipLeft {
  SkipLeft(this.catalogStore);

  final CatalogStore catalogStore;

  void call() {
    catalogStore.setSwipeIndex(catalogStore.value.swipeIndex + 1);
  }
}
