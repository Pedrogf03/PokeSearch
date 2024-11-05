import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokesearch/blocs/home/home_bloc.dart';
import 'package:pokesearch/blocs/pokemon/pokemon_bloc.dart';
import 'package:pokesearch/screens/splash_screen.dart';

void main() {
  runApp(
    MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => HomeBloc(),
          ),
          BlocProvider(
            create: (context) => PokemonBloc(),
          )
        ],
        child: const MyApp()
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PokeSearch',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SplashScreen(),
    );
  }
}
