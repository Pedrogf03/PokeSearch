
import '../../models/pokemon_details.dart';

class PokemonState {
  final bool isLoading;
  final PokemonDetails? pokemonDetails;
  final String? errorMessage;

  PokemonState({
    this.isLoading = false,
    this.pokemonDetails,
    this.errorMessage,
  });

  PokemonState copyWith({
    bool? isLoading,
    PokemonDetails? pokemonDetails,
    String? errorMessage,
  }) {
    return PokemonState(
      isLoading: isLoading ?? this.isLoading,
      pokemonDetails: pokemonDetails ?? this.pokemonDetails,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

}