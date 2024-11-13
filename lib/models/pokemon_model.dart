class PokemonModel {
  final String name;
  final int id;

  PokemonModel({required this.name, required this.id});

  String get imageUrl {
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  }
}

