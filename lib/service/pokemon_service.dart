import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/pokemon_details.dart';
import '../models/pokemon_model.dart';

class PokemonService {

  static final Logger log = Logger();

  static Future<List<PokemonModel>> fetchPokemonList({required int offset, required int limit}) async {
    final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$limit'));

    if (response.statusCode == 200) {
      log.i("Fetched Pokemon list");
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => PokemonModel(name: json['name'], url: json['url'])).toList();
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }

  static Future<PokemonDetails> fetchPokemonDetails(String url) async {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {

      log.i("Fetched Pokemon Details");

      final Map<String, dynamic> pokemonJson = json.decode(response.body);
      final types = (pokemonJson['types'] as List).map((type) => type['type']['url'] as String).toList();

      // Obtener los sprites de los tipos
      List<String> typeSprites = [];
      for (String typeUrl in types) {
        final typeResponse = await http.get(Uri.parse(typeUrl));
        if (typeResponse.statusCode == 200) {
          log.i("Fetched Pokemon type");
          final typeJson = json.decode(typeResponse.body);
          typeSprites.add(typeJson['sprites']['generation-ix']['scarlet-violet']['name_icon']);
        } else {
          throw Exception('Failed to load Pokémon types');
        }
      }

      return PokemonDetails(
        name: pokemonJson['name'],
        id: pokemonJson['id'],
        height: pokemonJson['height'],
        weight: pokemonJson['weight'],
        imageUrl: pokemonJson['sprites']['other']['official-artwork']['front_default'],
        abilities: (pokemonJson['abilities'] as List).map((ability) => ability['ability']['name'] as String).toList(),
        types: typeSprites,
      );
    } else {
      throw Exception('Failed to load Pokémon details');
    }
  }
}

