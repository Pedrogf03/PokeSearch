import 'package:pokesearch/models/pokemon_model.dart';

abstract class PokemonEvent {}

class PokemonEventInit extends PokemonEvent {
  final PokemonModel pokemonModel;

  PokemonEventInit(this.pokemonModel);
}