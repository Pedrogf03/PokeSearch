import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokesearch/blocs/pokemon/pokemon_bloc.dart';
import 'package:pokesearch/blocs/pokemon/pokemon_event.dart';
import 'package:pokesearch/models/pokemon_model.dart';

import '../blocs/pokemon/pokemon_state.dart';
import '../utils/theme_colors.dart';

class PokemonScreen extends StatelessWidget {
  final PokemonModel pokemon;

  const PokemonScreen({
    super.key,
    required this.pokemon,
  });

  @override
  Widget build(BuildContext context) {
    PokemonBloc.instance.add(PokemonEventInit(pokemon));

    return Scaffold(
      appBar: AppBar(
        foregroundColor: ThemeColors().yellow,
        title: Text(
          pokemon.name.toUpperCase().replaceAll("-", " "),
        ),
        backgroundColor: ThemeColors().blue,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Añadir a favoritos
            },
            icon: const Icon(
              Icons.favorite_border,
            ),
          ),
        ],
      ),
      body: BlocBuilder<PokemonBloc, PokemonState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state.errorMessage != null) {
            return Center(child: Text(state.errorMessage!));
          } else if (state.pokemonDetails != null) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: ThemeColors().gray,
              ),
              child: Center(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: ThemeColors().blue,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.network(
                          state.pokemonDetails!.imageUrl ?? "",
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                            return const Icon(Icons.error, size: 50);
                          },
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: state.pokemonDetails!.types != null && state.pokemonDetails!.types!.isNotEmpty
                              ? state.pokemonDetails!.types!.map((String typeImg) {
                            return Flexible(
                              child: Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Image.network(
                                  typeImg,
                                  fit: BoxFit.contain,
                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                    return const Icon(Icons.error, size: 50);
                                  },
                                ),
                              ),
                            );
                          }).toList()
                              : [
                            const Text('No types available')
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          state.pokemonDetails!.name?.toUpperCase().replaceAll("-", " ") ?? "",
                          style: TextStyle(
                            color: ThemeColors().yellow,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Height: ${(state.pokemonDetails?.height != null ? (state.pokemonDetails!.height! / 10).toStringAsFixed(1) : 'N/A')} m',
                          style: TextStyle(
                            color: ThemeColors().yellow,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Weight: ${(state.pokemonDetails!.weight != null ? (state.pokemonDetails!.weight! / 10).toStringAsFixed(1) : 'N/A')} kg',
                          style: TextStyle(
                            color: ThemeColors().yellow,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Abilities: ${state.pokemonDetails?.abilities != null && state.pokemonDetails!.abilities!.isNotEmpty
                              ? state.pokemonDetails!.abilities!
                                .map((ability) => ability.replaceAll("-", " ").split(' ')
                                .map((word) => word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '')
                                .join(' '))
                                .join(', ')
                              : 'N/A'}',
                          style: TextStyle(
                            color: ThemeColors().yellow,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('No Pokémon data available'));
          }
        },
      ),
    );
  }


}
