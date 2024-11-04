abstract class HomeEvent {}

class HomeEventFetchAllPokemon extends HomeEvent {}

class HomeEventSearchPokemon extends HomeEvent {
  final String query;

  HomeEventSearchPokemon(this.query);
}

