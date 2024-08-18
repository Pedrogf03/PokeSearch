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
    final bool favSearch = arguments['favSearch'];
    return FutureBuilder(
      future: ApiService().getPokemon(name),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          pokemon = snapshot.data!;
          if(favSearch && !favsOn) {
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
            return Column(
              children: [
                Image.network(
                  pokemon.sprite,
                  width: 100,
                  height: 100,
                ),
                Text(
                  '${pokemon.name[0].toUpperCase()}${pokemon.name.substring(1)}',
                ),
              ],
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