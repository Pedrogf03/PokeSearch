import 'package:flutter/material.dart';
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
            key: UniqueKey(),
            autocorrect: true,
            decoration: const InputDecoration(
              hintText: "Busca un Pokémon",
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              setState(() {
                favsOn = !favsOn;
              });
            },
            icon: favsOn ? Icon(Icons.star, color: ThemeColors().yellow, size: 50) : Icon(Icons.star_border, color: ThemeColors().gray,  size: 50)
        )
      ],
    );
  }

  /*
    Método que recoge toda la creacion y estilo de tarjteas
    para mostrar imagen y nombre de los pokemon
   */
  FutureBuilder<ApiPokemon> futureGridPokemon() {
    return FutureBuilder(
      future: ApiService().getPokemons(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          infoPokemon = snapshot.data!;
          return Expanded(
            child: GridView.builder(

                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 1,
                    crossAxisSpacing: 1,
                    childAspectRatio: 0.8
                ),
                itemCount: infoPokemon.results.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: ThemeColors().blue,
                    child: Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.popAndPushNamed(context, '/pkm_details');
                            },
                            icon: Image.asset("lib/assets/splashImage.png", width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height * 0.2,)),
                        Text(
                          infoPokemon.results[index].name,
                          style: TextStyle(color: ThemeColors().yellow),
                        ),
                      ],
                    ),
                  );
                }
            ),
          );
        }else{
          if(snapshot.hasError){
            //Navigator.pop(context);
          }
          return const  Center(
            child: CircularProgressIndicator(),
          );
        }
      },

    );
  }

}
