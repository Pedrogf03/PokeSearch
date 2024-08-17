class Pokeinfo {
  String name;
  List<Ability> abilities;
  String sprite;

  Pokeinfo({required this.name, required this.abilities, required this.sprite});

  factory Pokeinfo.fromJson(Map<String, Object?> jsonMap) {
    List<Ability>? pkmnAbilities = [];
    dynamic abilitiesMap = jsonMap['abilities'];

    for(var item in abilitiesMap) {
      Ability sesion = Ability.fromJson(item['ability'] as Map<String, Object?>);
      pkmnAbilities.add(sesion);
    }

    dynamic spritesMap = jsonMap['sprites'];
    String frontDefaultSprite = spritesMap['front_default'] as String;

    return Pokeinfo(
      name: jsonMap['name'] as String,
      abilities: pkmnAbilities,
      sprite: frontDefaultSprite
    );
  }
}

class Ability {
  String name;

  Ability({required this.name});

  factory Ability.fromJson(Map<String, Object?> jsonMap) {
    return Ability(
      name: jsonMap['name'] as String
    );
  }

}

class Sprite {
  String frontDefault;

  Sprite({required this.frontDefault});

  factory Sprite.fromJson(Map<String, Object?> jsonMap) {
    return Sprite(
        frontDefault: jsonMap['front_default'] as String
    );
  }

}
