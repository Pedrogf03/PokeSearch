import 'package:shared_preferences/shared_preferences.dart';

/*
  Clase que usa los shared preferences para
  guardar una lista con el nombre de los pokemon
  favoritos
 */
class FavoritesService {
  static const _favoritesKey = 'favorites';

  /*
    Metodo para guardar un pokemon en favoritos
   */
  Future<void> addFavorite(String pokemonName) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    if (!favorites.contains(pokemonName)) {
      favorites.add(pokemonName);
      await prefs.setStringList(_favoritesKey, favorites);
    }
  }

  /*
    Metodo para eliminar un pokemon de favoritos
   */
  Future<void> removeFavorite(String pokemonName) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    favorites.remove(pokemonName);
    await prefs.setStringList(_favoritesKey, favorites);
  }

  /*
    Metodo que devuelve la lista de pokemon favoritos
   */
  Future<List<String>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

}