import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:pokesearch/screens/home_screen.dart';

import '../utils/theme_colors.dart';
//import 'home_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            child: Image.asset('lib/assets/splash_image.png'),
          ),
          const SizedBox(height: 20),
          Text(
            'PokéSearch',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: ThemeColors().yellow
            ),
          ),
        ],
      ),
      backgroundColor: ThemeColors().blue,
      nextScreen: HomeScreen(),
      splashTransition: SplashTransition.scaleTransition,
      duration: 2000,
    );
  }
}
