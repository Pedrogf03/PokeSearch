import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:pokesearch/blocs/pokemon/pokemon_event.dart';
import 'package:pokesearch/blocs/pokemon/pokemon_state.dart';

import '../../service/pokemon_service.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  static PokemonBloc? _instance;
  static PokemonBloc get instance => _instance ??= PokemonBloc._();

  final Logger log = Logger();

  String get name => 'PokemonBloc';

  factory PokemonBloc() => _instance ??= PokemonBloc._();

  PokemonBloc._() : super(PokemonState()) {
    on<PokemonEventInit>(_onInit);
  }

  Future<void> _onInit(PokemonEventInit event, Emitter<PokemonState> emit) async {
    try {
      emit(state.copyWith(isLoading: true));

      final pokemon = await PokemonService.fetchPokemonDetails(event.pokemonModel.url);

      emit(state.copyWith(isLoading: false, pokemonDetails: pokemon));
    } catch (e) {
      log.e(e);
      emit(state.copyWith(isLoading: false, errorMessage: 'Failed to load Pokémon'));
    }
  }

}