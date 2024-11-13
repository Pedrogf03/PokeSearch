import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokesearch/blocs/home/home_bloc.dart';
import 'package:pokesearch/blocs/home/home_event.dart';
import 'package:pokesearch/blocs/home/home_state.dart';
import 'package:pokesearch/screens/pokemon_screen.dart';
import 'package:pokesearch/service/favorite_service.dart';
import 'package:pokesearch/utils/theme_colors.dart';
import 'package:pokesearch/widget/custom_list_title.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late bool favsOn;

  loadMorePokemon() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100 && !HomeBloc.instance.isSearching) {
      HomeBloc.instance.add(HomeEventFetchAllPokemon());
    }
  }

  @override
  void initState() {
    super.initState();
    HomeBloc.instance.add(HomeEventFetchAllPokemon());
    HomeBloc.instance.add(HomeEventFetchFavorites());
    _scrollController.addListener(loadMorePokemon);
    favsOn = false;
  }

  @override
  void dispose() {
    _scrollController.removeListener(loadMorePokemon);
    super.dispose();
  }

  void _handleSearch() {
    final query = _controller.text.trim();
    if (query.isEmpty) {
      HomeBloc.instance.add(HomeEventFetchAllPokemon());
    } else {
      HomeBloc.instance.add(HomeEventSearchPokemon(query));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PokéSearch',
          style: TextStyle(
            color: ThemeColors().yellow,
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
              setState(() {
                favsOn = !favsOn;
              });
              if(favsOn) {
                HomeBloc.instance.add(HomeEventFetchFavorites());
              }
            },
            icon: Icon(
              favsOn ? Icons.favorite : Icons.favorite_border,
              color: ThemeColors().yellow,
            ),
          ),
        ],
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          color: ThemeColors().gray,
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
                    color: ThemeColors().yellow,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ThemeColors().yellow,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: ThemeColors().yellow,
                    ),
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
                  color: ThemeColors().yellow,
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
                      final listToShow = favsOn ? state.favoritesPokemon! : state.filteredPokemonList ?? state.pokemonList!;
                      return listToShow.isEmpty
                          ? Center(
                              child: Text(
                                "No Pokemon Data to show",
                                style: TextStyle(
                                    color: ThemeColors().yellow
                                ),
                              ),
                            )
                          : ListView.builder(
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
                                      // Navegar a la pantalla del Pokémon
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PokemonScreen(pokemon: pokemon),
                                        ),
                                      );
                                    },
                                    onDoubleTap: () {
                                      FavoriteService.addFavorite(pokemon.name);
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
                                        fontSize: 20,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.favorite_border,
                                        color: ThemeColors().yellow,
                                      ),
                                      onPressed: () {
                                        FavoriteService.addFavorite(pokemon.name);
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                    } else if (state.errorMessage != null) {
                      return Center(child: Text(state.errorMessage!));
                    } else {
                      return Center(
                          child: Text(
                            'No Pokémon found',
                            style: TextStyle(color: ThemeColors().yellow),
                          )
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}