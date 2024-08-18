import 'package:flutter/material.dart';
import 'package:pokesearch/pokeapi/class/pokeinfo.dart';
import 'package:pokesearch/utils/FavoriteService.dart';
import 'package:pokesearch/utils/theme_colors.dart';

import '../pokeapi/api/api_service.dart';
import '../pokeapi/class/api_pokemon.dart';

// Pantalla de busqueda y filtro de pokemon
class PkmnGrid extends StatefulWidget {
  const PkmnGrid({super.key});

  @override
  State<PkmnGrid> createState() => _PkmnGridState();
}

/*
  Muestra una lista con todos los pokemon recogidos
  de la api, una barra de búsqueda para buscar por
  nombre y un icono que filtra por favoritos
*/
class _PkmnGridState extends State<PkmnGrid> {

  String appBarTitle = "PokeSearch";
  TextEditingController search = TextEditingController();
  bool favsOn = false;
  late ApiPokemon infoPokemon;
  String? customUrl;

  @override
  void initState() {
    super.initState();
    customUrl = null;
  }

  /*
    Metodo que se encarga de la busqueda
    de un pokemon por su nombre
   */
  void searchPokemon(String pokeName) {
    Navigator.popAndPushNamed(
      context,
      '/pkm_details',
      arguments: {'pkmn_name': pokeName.toLowerCase()},
    );
  }

  /*
    Metodo que muestra los pokemon almacenados en favoritos
   */
  void getFavorites() async {
    final favorites = await FavoritesService().getFavorites();
    for(final favorites in favorites) {
      print(favorites);
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
              futureGridPokemon()
            ]
          )
        ),
      )
    );
  }

  /*
    Método que recoge toda la creación y estilo de
    la barra de búsqueda y filtro de favoritos
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
              hintText: "Busca un Pokémon",
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
                  getFavorites();
                }
              });
            },
            icon: favsOn ? Icon(Icons.star, color: ThemeColors().yellow, size: 50) : Icon(Icons.star_border, color: ThemeColors().gray,  size: 50)
        )
      ],
    );
  }

  /*
    Método que recoge toda la creacion y estilo del grid el cual
    recoge todos los pokemon
   */
  FutureBuilder<ApiPokemon> futureGridPokemon() {
    return FutureBuilder(
      future: Future.delayed(const Duration(milliseconds: 150))
          .then((_) => ApiService().getPokemons(customUrl)),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          infoPokemon = snapshot.data!;
          return Expanded(
            child: Column(
              children: [
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 400,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 0.6,
                    ),
                    itemCount: infoPokemon.results.length,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        future: ApiService().getPokemon(infoPokemon.results[index].name),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            Pokeinfo pokemon = snapshot.data!;
                            return pokemonCard(context, pokemon);
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
          return const Center(child: Text('Error al cargar los datos'));
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }


  /*
    Metodo que recoge la creacion y estilo de la carta que contiene un pokemon
   */
  Card pokemonCard(BuildContext context, Pokeinfo pokemon) {
    return Card(
      color: ThemeColors().blue,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(
                context,
                '/pkm_details',
                arguments: {'pkmn_name': pokemon.name},
              );
            },
            icon: Center(
              child: Image.network(
                pokemon.sprite,
                fit: BoxFit.contain,
                width: MediaQuery.of(context).size.width * 0.3,
                height: MediaQuery.of(context).size.width * 0.3,
              ),
            ),
          ),
          Text(
            '${pokemon.name[0].toUpperCase()}${pokemon.name.substring(1)}',
            style: TextStyle(color: ThemeColors().yellow),
          ),
        ],
      ),
    );
  }

}