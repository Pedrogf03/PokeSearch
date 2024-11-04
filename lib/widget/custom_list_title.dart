import 'package:flutter/material.dart';

class CustomListTitle extends StatelessWidget {

  /// Optional leading widget
  final Widget? leading;
  /// Required title text
  final Text? title;
  /// Optional subtitle text
  final Text? subTitle;
  /// Optional tap event handler
  final Function? onTap;
  /// Optional long press event handler
  final Function? onLongPress;
  /// Optional double tap event handler
  final Function? onDoubleTap;
  /// Optional trailing widget
  final Widget? trailing;
  /// Optional tile background color
  final Color? tileColor;
  /// Required height for the custom list tile
  final double? height;

  const CustomListTitle({
    super.key,
    this.leading,
    this.title,
    this.subTitle,
    this.onTap,
    this.onLongPress,
    this.onDoubleTap,
    this.trailing,
    this.tileColor,
    this.height
  });

  @override
  Widget build(BuildContext context) {
    return Material( // Material design container for the list tile
      shape: RoundedRectangleBorder( // Rounder border
        borderRadius: BorderRadius.circular(50.0),
      ),
      color: tileColor, // Set background color if provided
      child: InkWell( // Tappable area with event handlers
        onTap: () => onTap, // Tap event handler
        onDoubleTap: () => onDoubleTap, // Double tap event handler
        onLongPress: () => onLongPress, // Long press event handler
        child: SizedBox( // Constrain the size of the list tile
          height: height, // Set custom height from constructor
          child: Row( // Row layout for list item content
            children: [
              Padding( // Padding for the leading widget
                padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                child: leading, // Display leading widget
              ),
              Expanded( // Expanded section for title and subtitle
                child: Column( // Column layout for title and subtitle
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text left
                  mainAxisAlignment: MainAxisAlignment.center, // Center text vertically
                  children: [
                    title ?? const SizedBox(), // Display title or empty space
                    const SizedBox(height: 10), // Spacing between title and subtitle
                    subTitle ?? const SizedBox(), // Display subtitle or empty space
                  ],
                ),
              ),
              Padding( // Padding for the trailing widget
                padding: const EdgeInsets.all(12.0),
                child: trailing, // Display trailing widget
              )
            ],
          ),
        ),
      ),
    );
  }
}
