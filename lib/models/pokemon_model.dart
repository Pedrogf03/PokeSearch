class PokemonModel {
  final String name;
  final String url;

  PokemonModel({required this.name, required this.url});

  String get imageUrl {
    final id = url.split('/')[url.split('/').length - 2];
    return 'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
  }
}

