import 'package:flutter_bloc/flutter_bloc.dart';
import '../../service/pokemon_service.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  static HomeBloc? _instance;
  static HomeBloc? get instance => _instance;

  int _currentOffset = 0;
  final int _pageSize = 20;
  bool _isFetching = false;

  @override
  String get name => 'HomeBloc';

  factory HomeBloc() => _instance ??= HomeBloc._();

  HomeBloc._() : super(HomeState()) {
    on<HomeEventFetchAllPokemon>(_onFetchAllPokemon);
    on<HomeEventSearchPokemon>(_onSearchPokemon);
  }

  Future<void> _onFetchAllPokemon(
      HomeEventFetchAllPokemon event, Emitter<HomeState> emit) async {
    if (_isFetching) return;
    _isFetching = true;
    try {
      emit(state.copyWith(isLoading: true));

      final newPokemonList = await PokemonService.fetchPokemonList(offset: _currentOffset, limit: _pageSize);

      _currentOffset += _pageSize;
      final updatedList = [
        ...?state.pokemonList,
        ...newPokemonList
      ];

      emit(state.copyWith(pokemonList: updatedList, filteredPokemonList: updatedList, isLoading: false));
    } catch (e) {
      emit(state.copyWith(isLoading: false, errorMessage: 'Failed to load Pokémon'));
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _onSearchPokemon(HomeEventSearchPokemon event, Emitter<HomeState> emit) async {
    final filteredList = state.pokemonList
        ?.where((pokemon) => pokemon.name.toLowerCase().contains(event.query.toLowerCase()))
        .toList();
    emit(state.copyWith(filteredPokemonList: filteredList));
  }
}
