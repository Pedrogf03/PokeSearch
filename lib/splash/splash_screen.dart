import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../screens/pkmn_grid.dart';
import '../utils/theme_colors.dart';

// Pantalla de carga de la aplicación
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

/*
  Muestra una imagen en el centro de la pantalla
  que se agranda hasta llegar a su tamaño, con un
  color azul de fondo que tras 2s lleva a la
  siguiente pantalla
 */
class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        duration: 2000,
        splash: Image.asset("lib/assets/splashImage.png"),
        pageTransitionType: PageTransitionType.bottomToTop,
        splashTransition: SplashTransition.scaleTransition,
        backgroundColor: ThemeColors().blue,
        nextScreen: const PkmnGrid(),
      ),
    );
  }
}
