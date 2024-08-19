import 'package:pokesearch/pokeapi/api/api_service.dart';
import 'package:pokesearch/pokeapi/class/pokeinfo.dart';
import 'package:pokesearch/pokeapi/class/pokemon.dart';

class ApiPokemon {
  String? next;
  String? previous;
  List<Pokemon> results;

  ApiPokemon({required this.next, required this.results, required this.previous});

  factory ApiPokemon.fromJson(Map<String, Object?> jsonMap) {

    List<Pokemon>? pokemonList = [];
    dynamic pokemonMap = jsonMap['results'];

    for (var item in pokemonMap) {
      Pokemon sesion = Pokemon.fromJson(item);
      pokemonList.add(sesion);
    }
    return ApiPokemon(
        next: jsonMap['next'] as String?,
        previous: jsonMap['previous'] as String?,
        results: pokemonList
    );
  }

  Future<List<Pokeinfo>?> pokemonAsPokeInfo() async {
    List<Pokeinfo> pokeInfoList = [];

    for (var poke in results) {
      Pokeinfo? pokeInfo = await ApiService().getPokemon(poke.name);

      pokeInfoList.add(pokeInfo);
    }

    return pokeInfoList;
  }


}