import 'package:flutter/material.dart';
import 'package:pokesearch/pokeapi/class/pokeinfo.dart';
import 'package:pokesearch/utils/FavoriteService.dart';

import '../pokeapi/api/api_service.dart';
import '../utils/theme_colors.dart';


// Pantalla de detalles de un Pokemon
class PkmDetails extends StatefulWidget {
  const PkmDetails({super.key});

  @override
  State<PkmDetails> createState() => _PkmDetailsState();
}

/*
  Muestra una columna con toda la información
  sobre el pokemon seleccionado en la pantalla anterior
 */
class _PkmDetailsState extends State<PkmDetails> {

  final String title = "PokeSearch";
  late Pokeinfo pokemon;
  bool favsOn = false;
  late String pokemonName;

  /*
    Metodo que comprueba si el pokemon esta en favoritos
    al iniciar la pantalla
   */
  void getFavorites(String pokeName) async {
    final favorites = await FavoritesService().getFavorites();
    if(favorites.contains(pokeName)) {
      setState(() {
        favsOn = true;
      });
    }else{
      setState(() {
        favsOn = false;
      });
    }
  }


  /*
    Metodo que se usa cuando el contexto ya esta cargado para
    poder usarlo
   */
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    pokemonName = arguments['pkmn_name'];
    getFavorites(pokemonName);
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final String pokemonName = arguments['pkmn_name'];
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/pkm_grid');
            },
            icon: const Icon(Icons.arrow_back), color: ThemeColors().yellow,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  setState(() {
                    favsOn = !favsOn;
                  });
                  if(favsOn) {
                    FavoritesService().addFavorite(pokemonName);
                  }else{
                    FavoritesService().removeFavorite(pokemonName);
                  }
                },
                icon: favsOn ? Icon(Icons.star, color: ThemeColors().yellow, size: 25) : Icon(Icons.star_border, color: ThemeColors().yellow,  size: 25)
            )
          ],
          title: Text(title, style: TextStyle(color: ThemeColors().yellow)),
          backgroundColor: ThemeColors().blue
      ),
      body: SafeArea(
          child: futurePokeInfo(pokemonName)
      ),
    );
  }

  /*
    Método encargado de cargar y mostrar los datos de un pokemon
    sacado de la api
   */
  FutureBuilder<Pokeinfo> futurePokeInfo(String name) {
    final arguments = ModalRoute.of(context)!.settings.arguments as Map;
    final bool? favSearch = arguments['favSearch'];
    return FutureBuilder(
      future: ApiService().getPokemon(name),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          pokemon = snapshot.data!;
          if(favSearch == true && !favsOn) {
            return SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(Icons.error),
                  Text("No tienes este pokemon en favoritos")
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: 600,
                      ),
                      child: Card(
                        color: ThemeColors().blue,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                pokemon.sprite,
                                width: constraints.maxWidth < 600 ? constraints.maxWidth * 0.7 : 600 * 0.7,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                '${pokemon.name[0].toUpperCase()}${pokemon.name.substring(1)}',
                                style: TextStyle(
                                  fontSize: 64,
                                  color: ThemeColors().yellow,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              const Text(
                                'Pokemon Abilities',
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0), // Espacio entre el título y las habilidades
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: pokemon.abilities.map((ability) {
                                  return Text(
                                    '${ability.name.replaceAll('-', ' ')[0].toUpperCase()}${ability.name.replaceAll('-', ' ').substring(1)}',
                                    style: const TextStyle(fontSize: 24, color: Colors.white),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );

          }
        } else if (snapshot.hasError){
          return SizedBox(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.error),
                Text("Pokemon no encontrado")
              ],
            ),
          );
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

}