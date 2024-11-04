import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokesearch/utils/theme_colors.dart';
import 'package:pokesearch/widget/custom_list_title.dart';

import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_event.dart';
import '../blocs/home/home_state.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  HomeScreen({super.key}) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !HomeBloc.instance!.isSearching) {
        HomeBloc.instance?.add(HomeEventFetchAllPokemon());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'PokéSearch',
          style: TextStyle(
            color: ThemeColors().yellow
          ),
        ),
        backgroundColor: ThemeColors().blue,
        leading: Image.asset(
          'lib/assets/splash_image.png',
          fit: BoxFit.cover,
        ),
        actions: [
          IconButton(
              onPressed: () {
                // TODO: Navegar a favoritos
              },
              icon: Icon(
                  Icons.favorite,
                  color: ThemeColors().yellow
              )
          )
        ],
      ),
      body: BlocProvider(
        create: (context) => HomeBloc()..add(HomeEventFetchAllPokemon()),
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: ThemeColors().gray
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Search for a Pokémon',
                    labelStyle: TextStyle(
                      color: ThemeColors().yellow
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: ThemeColors().yellow
                      )
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: ThemeColors().yellow
                        )
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        Icons.search,
                        color: ThemeColors().yellow,
                      ),
                      onPressed: () {
                        _handleSearch();
                      },
                    ),
                  ),
                  style: TextStyle(
                    color: ThemeColors().yellow
                  ),
                  onChanged: (value) {
                    _handleSearch();
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: BlocBuilder<HomeBloc, HomeState>(
                    builder: (context, state) {
                      if (state.isLoading && state.pokemonList == null) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state.pokemonList != null) {
                        final listToShow = state.filteredPokemonList ?? state.pokemonList!;
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: listToShow.length,
                          itemBuilder: (context, index) {
                            final pokemon = listToShow[index];
                            return Card(
                              color: ThemeColors().blue,
                              child: CustomListTitle(
                                tileColor: ThemeColors().blue,
                                height: 100.0,
                                onTap: () {
                                  // TODO: Navegar a la screen del pokemon
                                  print("Navega a la screen del pokemon ${pokemon.name}");
                                },
                                leading: Image.network(
                                  pokemon.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                                    return Image.asset(
                                      'lib/assets/splash_image.png',
                                      fit: BoxFit.cover,
                                    );
                                  },
                                ),
                                title: Text(
                                  pokemon.name.toUpperCase().replaceAll("-", " "),
                                  style: TextStyle(
                                    color: ThemeColors().yellow,
                                    fontSize: 20
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                      Icons.favorite_border,
                                      color: ThemeColors().yellow
                                  ),
                                  onPressed: () {
                                    print("Pokemon ${pokemon.name} añadido a favoritos");
                                    // TODO: Lógica para agregar a favoritos
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      } else if (state.errorMessage != null) {
                        return Center(child: Text(state.errorMessage!));
                      } else {
                        return const Center(child: Text('No Pokémon found'));
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSearch() {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      HomeBloc.instance?.add(HomeEventFetchAllPokemon());
    } else {
      HomeBloc.instance?.add(HomeEventSearchPokemon(query));
    }
  }
}
