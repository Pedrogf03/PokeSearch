import '../../models/pokemon_model.dart';

class HomeState {
  final bool isLoading;
  final List<PokemonModel>? pokemonList;
  final List<PokemonModel>? filteredPokemonList;
  final List<PokemonModel>? favoritesPokemon;
  final String? errorMessage;

  HomeState({
    this.isLoading = false,
    this.pokemonList,
    this.filteredPokemonList,
    this.favoritesPokemon,
    this.errorMessage,
  });

  HomeState copyWith({
    bool? isLoading,
    List<PokemonModel>? pokemonList,
    List<PokemonModel>? filteredPokemonList,
    List<PokemonModel>? favoritesPokemon,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      pokemonList: pokemonList ?? this.pokemonList,
      filteredPokemonList: filteredPokemonList ?? this.filteredPokemonList,
      favoritesPokemon: favoritesPokemon ?? this.favoritesPokemon,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
