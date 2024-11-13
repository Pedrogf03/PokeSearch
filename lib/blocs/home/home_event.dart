abstract class HomeEvent {}

class HomeEventFetchAllPokemon extends HomeEvent {}

class HomeEventSearchPokemon extends HomeEvent {
  final String query;
  final bool favsOn;

  HomeEventSearchPokemon(this.query, this.favsOn);
}

class HomeEventFetchFavorites extends HomeEvent {}

