import '../../models/pokemon_model.dart';

class HomeState {
  final bool isLoading;
  final List<PokemonModel>? pokemonList;
  final List<PokemonModel>? filteredPokemonList;
  final List<PokemonModel>? favoritesPokemon;
  final List<PokemonModel>? filteredFavoritesPokemon;
  final String? errorMessage;

  HomeState({
    this.isLoading = false,
    this.pokemonList,
    this.filteredPokemonList,
    this.favoritesPokemon,
    this.filteredFavoritesPokemon,
    this.errorMessage,
  });

  HomeState copyWith({
    bool? isLoading,
    List<PokemonModel>? pokemonList,
    List<PokemonModel>? filteredPokemonList,
    List<PokemonModel>? favoritesPokemon,
    List<PokemonModel>? filteredFavoritesPokemon,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      pokemonList: pokemonList ?? this.pokemonList,
      filteredPokemonList: filteredPokemonList ?? this.filteredPokemonList,
      favoritesPokemon: favoritesPokemon ?? this.favoritesPokemon,
      filteredFavoritesPokemon: filteredFavoritesPokemon ?? this.filteredFavoritesPokemon,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
