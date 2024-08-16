import 'package:flutter/material.dart';

import '../utils/theme_colors.dart';

class PkmDetails extends StatefulWidget {
  const PkmDetails({super.key});

  @override
  State<PkmDetails> createState() => _PkmDetailsState();
}

class _PkmDetailsState extends State<PkmDetails> {

  final String title = "PokeSearch";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.popAndPushNamed(context, '/pkm_grid');
            },
            icon: const Icon(Icons.arrow_back), color: ThemeColors().yellow,
          ),
          title: Text(title, style: TextStyle(color: ThemeColors().yellow)),
          backgroundColor: ThemeColors().blue
      ),
    );
  }
}