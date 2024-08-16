class Pokeinfo {
  String name;
  List<Ability> abilities;
  List<Sprite> sprites;

  Pokeinfo({required this.name, required this.abilities, required this.sprites});

  factory Pokeinfo.fromJson(Map<String, Object?> jsonMap) {
    List<Ability> pkmnAbilities = [];
    dynamic abilitiesMap  = jsonMap['abilities'];

    for(var item in abilitiesMap) {
      Ability sesion = Ability.fromJson(item);
      pkmnAbilities.add(sesion);
    }

    List<Sprite> pkmnSprites = [];
    dynamic spritesMap  = jsonMap['sprites'];

    for(var item in spritesMap) {
      Sprite sesion = Sprite.fromJson(item);
      spritesMap.add(sesion);
    }

    return Pokeinfo(
      name: jsonMap['name'] as String,
      abilities: pkmnAbilities,
      sprites: pkmnSprites
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
