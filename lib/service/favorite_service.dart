import 'package:logger/logger.dart';
import 'package:pokesearch/service/pokemon_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/pokemon_model.dart';

class FavoriteService {
  static const _favoritesKey = 'favorites';

  static final Logger log = Logger();

  static Future<void> addFavorite(String pokemonName) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    if(!favorites.contains(pokemonName.toLowerCase())) {
      favorites.add(pokemonName.toLowerCase());
      await prefs.setStringList(_favoritesKey, favorites);
    }
    log.i("Pokemon $pokemonName added to favorites");
  }

  static Future<void> removeFavorite(String pokemonName) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> favorites = prefs.getStringList(_favoritesKey) ?? [];
    favorites.remove(pokemonName.toLowerCase());
    await prefs.setStringList(_favoritesKey, favorites);
    log.i("Pokemon $pokemonName removed from favorites");
  }

  static Future<List<PokemonModel>> getFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> pokemonNames = prefs.getStringList(_favoritesKey) ?? [];
    List<Future<PokemonModel>> fetchFutures = pokemonNames.map((name) {
      return PokemonService.fetchPokemon(name: name);
    }).toList();
    return Future.wait(fetchFutures);
  }

  static Future<bool> isFavorite(String name) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> pokemonNames = prefs.getStringList(_favoritesKey) ?? [];
    return pokemonNames.contains(name.toLowerCase());
  }

}