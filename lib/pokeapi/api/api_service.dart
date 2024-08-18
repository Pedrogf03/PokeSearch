import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokesearch/pokeapi/class/pokeinfo.dart';

import '../class/api_pokemon.dart';


class ApiService with ChangeNotifier{

  final url = "https://pokeapi.co/api/v2/pokemon";

  Future<ApiPokemon> getPokemons(String? customUrl) async {

    customUrl ??= url;

    final resultData = await http.get(
      Uri.parse(customUrl)
    );

    final statusCode = resultData.statusCode;

    if(statusCode == 200) {
      final body = resultData.body;
      final jsonMap = jsonDecode(body);
      ApiPokemon data = ApiPokemon.fromJson(jsonMap);

      return data;

    }else{
      throw HttpException('$statusCode');
    }
  }

  Future<Pokeinfo> getPokemon(String name) async {

    final resultData = await http.get(
        Uri.parse("$url/$name")
    );

    final statusCode = resultData.statusCode;

    if(statusCode == 200) {
      final body = resultData.body;
      final jsonMap = jsonDecode(body);
      Pokeinfo data = Pokeinfo.fromJson(jsonMap);

      return data;

    }else{
      throw HttpException('$statusCode');
    }
  }

  Future<Pokeinfo> getFavoritePokemon(String name) async {

    final resultData = await http.get(
        Uri.parse("$url/$name")
    );

    final statusCode = resultData.statusCode;

    if(statusCode == 200) {
      final body = resultData.body;
      final jsonMap = jsonDecode(body);
      Pokeinfo data = Pokeinfo.fromJson(jsonMap);

      return data;

    }else{
      throw HttpException('$statusCode');
    }
  }
}