import 'package:flutter/material.dart';
import 'package:pokesearch/pokeapi/class/pokeinfo.dart';
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
    return FutureBuilder(
      future: ApiService().getPokemon(name),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          pokemon = snapshot.data!;
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
        } else if (snapshot.hasError){
            if(snapshot.error.toString() == "HttpException: 404") {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error),
                  Text("Pokemon no encontrado")
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

}


/*
print(snapshot.error);
            if(snapshot.error == "HttpException: 404") {
              return const Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error),
                  Text("Pokemon no encontrado")
                ],
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
 */