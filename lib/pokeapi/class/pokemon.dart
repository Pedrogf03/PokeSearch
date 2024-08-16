class Pokemon {
  String name;
  String url;

  Pokemon({required this.name, required this.url});

  factory Pokemon.fromJson(Map<String, Object?> jsonMap) {
    return Pokemon(
      name: jsonMap['name'] as String,
      url: jsonMap['url'] as String,
    );
  }
}