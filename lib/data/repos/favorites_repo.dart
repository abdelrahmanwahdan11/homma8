import '../models/favorite.dart';

class FavoritesRepository {
  FavoritesRepository();

  final List<FavoriteModel> _favorites = <FavoriteModel>[];

  List<FavoriteModel> all() => List.unmodifiable(_favorites);

  void toggle(FavoriteModel fav) {
    final existing = _favorites.indexWhere((element) => element.refId == fav.refId && element.userId == fav.userId);
    if (existing != -1) {
      _favorites.removeAt(existing);
    } else {
      _favorites.add(fav);
    }
  }
}
