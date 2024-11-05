class PokemonDetails {
  final String? name;
  final int? id;
  final int? height;
  final int? weight;
  final String? imageUrl;
  final List<String>? abilities;
  final List<String>? types;

  PokemonDetails({
    this.name,
    this.id,
    this.height,
    this.weight,
    this.imageUrl,
    this.abilities,
    this.types,
  });

  factory PokemonDetails.fromJson(Map<String, dynamic> json) {
    return PokemonDetails(
      name: json['name'],
      id: json['id'],
      height: json['height'],
      weight: json['weight'],
      imageUrl: json['sprites']['other']['official-artwork']['front_default'],
      abilities: (json['abilities'] as List).map((ability) => ability['ability']['name'] as String).toList(),
      types: (json['types'] as List).map((type) => type['type']['url'] as String).toList(),
    );
  }

}