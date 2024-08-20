import 'package:flutter/material.dart';
import 'package:pokesearch/pokeapi/class/pokeinfo.dart';
import 'package:pokesearch/utils/FavoriteService.dart';
import 'package:pokesearch/utils/theme_colors.dart';

import '../pokeapi/api/api_service.dart';
import '../pokeapi/class/api_pokemon.dart';

// Pantalla para el grid con todos los pokemon
class PkmnGrid extends StatefulWidget {
  const PkmnGrid({super.key});

  @override
  State<PkmnGrid> createState() => _PkmnGridState();
}

/*
  Muestra un cuadro de busqueda, un icono para filtrar por pokemon favoritos
  y un grid con cartas que muestran un pokemon, su nombre y si están o no
  en favoritos.
 */
class _PkmnGridState extends State<PkmnGrid> {

  String appBarTitle = "PokeSearch";
  TextEditingController search = TextEditingController();
  bool favsOn = false;
  late ApiPokemon infoPokemon;
  late List<Pokeinfo> favorites;
  String? customUrl;

  @override
  void initState() {
    super.initState();
    customUrl = null;
    /*
      Inicia la lista de favoritos, sacando los que hay guardados en sharedpreferences
     */
    favorites = [];
    _loadFavorites();
  }

  /*
    Metodo para sacar de los shared preferences los pokemon favoritos
   */
  Future<void> _loadFavorites() async {
    try {
      favorites = await getFavorites();
      setState(() {});
    } catch (e) {
      print('Error loading favorites: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle, style: TextStyle(color: ThemeColors().yellow)),
        centerTitle: true,
        backgroundColor: ThemeColors().blue,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: Column(
            children: [
              searchBar(context),
              Expanded(
                child: futureGridPokemon(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /*
    Método de busqueda de pokemon por nombre y favoritos
   */
  void searchPokemon(String pokeName) {
    Navigator.popAndPushNamed(
      context,
      '/pkm_details',
      arguments: {'pkmn_name': pokeName.toLowerCase(), 'favSearch': favsOn},
    );
  }

  /*
    Método para sacar de forma asincrona los favoritos
   */
  Future<List<Pokeinfo>> getFavorites() async {
    final favorites = await FavoritesService().getFavorites();

    List<Pokeinfo> favoritePokemon = [];

    for (final favorite in favorites) {
      final pokemon = await ApiService().getPokemon(favorite);
      favoritePokemon.add(pokemon);
    }

    return favoritePokemon;
  }

  /*
    Muestra un cuadro de busqueda y el icono de favoritos
   */
  Row searchBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          child: TextFormField(
            controller: search,
            autocorrect: true,
            textInputAction: TextInputAction.search,
            onFieldSubmitted: (String query) {
              searchPokemon(query);
            },
            decoration: InputDecoration(
              hintText: "Search for pokemon",
              suffixIcon: IconButton(
                  onPressed: () {
                    searchPokemon(search.text);
                  },
                  icon: const Icon(Icons.search)
              ),
              border: const OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              setState(()  {
                favsOn = !favsOn;
                if(favsOn) {
                  favorites.clear();
                  getFavorites().then((value) {
                    setState(() {
                      favorites = value;
                    });
                  });
                }
              });
            },
            icon: favsOn ? Icon(Icons.star, color: ThemeColors().yellow, size: 50) : Icon(Icons.star_border, color: ThemeColors().gray, size: 50)
        )
      ],
    );
  }

  /*
    Muestra un grid con las cartas de los pokemon
   */
  FutureBuilder<dynamic> futureGridPokemon() {
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 150))
          .then((_) {
        if (favsOn) {
          return getFavorites();
        } else {
          return ApiService().getPokemons(customUrl);
        }
      }),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          try {
            if (!favsOn) {
              infoPokemon = snapshot.data!;
            } else {
              favorites = snapshot.data!;
            }
          } catch (e) {
            //ignore
          }
          return Expanded(
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.5,
                    ),
                    itemCount:  favsOn ? favorites.length : infoPokemon.results.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: ApiService().getPokemon(favsOn ? favorites[index].name : infoPokemon.results[index].name),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Pokeinfo pokemon = snapshot.data!;
                            return AnimatedPokemonCard(
                              pokemon: pokemon,
                              isFavorite: favorites.any((fav) => fav.name == pokemon.name),
                              onToggleFavorite: () {
                                setState(() {
                                  if (favorites.any((fav) => fav.name == pokemon.name)) {
                                    favorites.removeWhere((fav) => fav.name == pokemon.name);
                                    FavoritesService().removeFavorite(pokemon.name);
                                  } else {
                                    favorites.add(pokemon);
                                    FavoritesService().addFavorite(pokemon.name);
                                  }
                                });
                              },
                              onCardTapped: () {
                                Navigator.popAndPushNamed(
                                  context,
                                  '/pkm_details',
                                  arguments: {'pkmn_name': pokemon.name},
                                );
                              },
                            );
                          } else {
                            return const SizedBox.shrink();
                          }
                        },
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (infoPokemon.previous != null)
                      IconButton(
                        icon: const Icon(Icons.arrow_left, size: 50),
                        onPressed: () {
                          setState(() {
                            customUrl = infoPokemon.previous;
                          });
                        },
                      ),
                    if (infoPokemon.next != null)
                      IconButton(
                        icon: const Icon(Icons.arrow_right, size: 50),
                        onPressed: () {
                          setState(() {
                            customUrl = infoPokemon.next;
                          });
                        },
                      ),
                  ],
                )
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text('Error while fetching data'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

/*
  Clase para las cartas de los pokemon, que maneja la animacion
 */
class AnimatedPokemonCard extends StatefulWidget {
  final Pokeinfo pokemon;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onCardTapped;

  const AnimatedPokemonCard({
    super.key,
    required this.pokemon,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onCardTapped,
  });

  @override
  _AnimatedPokemonCardState createState() => _AnimatedPokemonCardState();
}

/*
  Clase que contiene la logica para la animacion
 */
class _AnimatedPokemonCardState extends State<AnimatedPokemonCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Card(
          color: ThemeColors().blue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: widget.onCardTapped,
                icon: Center(
                  child: Image.network(
                    widget.pokemon.sprite,
                    fit: BoxFit.contain,
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: MediaQuery.of(context).size.width * 0.3,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${widget.pokemon.name[0].toUpperCase()}${widget.pokemon.name.substring(1)}',
                    style: TextStyle(color: ThemeColors().yellow),
                  ),
                  IconButton(
                    icon: Icon(
                      widget.isFavorite ? Icons.star : Icons.star_border,
                      color: ThemeColors().yellow,
                    ),
                    onPressed: widget.onToggleFavorite,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
