import 'package:flutter/material.dart';
import 'package:pokesearch/models/pokemon_model.dart';

class PokemonScreen extends StatelessWidget {

  final PokemonModel pokemon;

  const PokemonScreen({
    super.key,
    required this.pokemon
  });

  @override
  Widget build(BuildContext context) {
    return Text(pokemon.name);
  }
}
