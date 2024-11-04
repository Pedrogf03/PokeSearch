import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pokemon_model.dart';

class PokemonService {
  static Future<List<PokemonModel>> fetchPokemonList(
      {required int offset, required int limit}) async {
    final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=$offset&limit=$limit'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((json) => PokemonModel(name: json['name'], url: json['url'])).toList();
    } else {
      throw Exception('Failed to load Pokémon');
    }
  }
}
