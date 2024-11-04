import '../../models/pokemon_model.dart';

class HomeState {
  final bool isLoading;
  final List<PokemonModel>? pokemonList;
  final List<PokemonModel>? filteredPokemonList;
  final String? errorMessage;

  HomeState({
    this.isLoading = false,
    this.pokemonList,
    this.filteredPokemonList,
    this.errorMessage,
  });

  HomeState copyWith({
    bool? isLoading,
    List<PokemonModel>? pokemonList,
    List<PokemonModel>? filteredPokemonList,
    String? errorMessage,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      pokemonList: pokemonList ?? this.pokemonList,
      filteredPokemonList: filteredPokemonList ?? this.filteredPokemonList,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
