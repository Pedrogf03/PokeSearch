import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/home/home_bloc.dart';
import '../blocs/home/home_event.dart';
import '../blocs/home/home_state.dart';

class HomeScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  HomeScreen({super.key}) {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 100) {
        HomeBloc.instance?.add(HomeEventFetchAllPokemon());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PokéSearch'),
      ),
      body: BlocProvider(
        create: (context) => HomeBloc()..add(HomeEventFetchAllPokemon()),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: 'Search for a Pokémon',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      _handleSearch();
                    },
                  ),
                ),
                onSubmitted: (value) {
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
                      final listToShow =
                          state.filteredPokemonList ?? state.pokemonList!;
                      return ListView.builder(
                        controller: _scrollController,
                        itemCount: listToShow.length,
                        itemBuilder: (context, index) {
                          final pokemon = listToShow[index];
                          return Card(
                            child: ListTile(
                              leading: Image.network(pokemon.imageUrl),
                              title: Text(pokemon.name.toUpperCase()),
                              trailing: IconButton(
                                icon: const Icon(Icons.favorite_border),
                                onPressed: () {
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
