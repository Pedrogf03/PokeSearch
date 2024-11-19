# PokéSearch

PokéSearch is a cross-platform application developed in Flutter that uses the public Pokémon API [PokeApi](https://pokeapi.co/).  
The app is designed to run on Android devices and through web browsers, following the Material 3 design guidelines.

## User Manual

### SplashScreen

The application includes a loading screen upon launch.

<img src="/lib/assets/splash_screen.png" 
alt="Splash Screen example image" 
width="300"/>

Its purpose is solely to initialize the app.

### HomeScreen

The Home screen displays a vertically scrollable list of 20 Pokémon. More Pokémon load as you scroll until the entire list is displayed.

<img src="/lib/assets/home_screen.png" 
alt="Home Screen example image" 
width="300"/>

This screen includes the following features:

- **Pokémon Search**: Allows users to search for Pokémon by entering the name in the text field at the top.

<img src="/lib/assets/home_screen_search.png" 
alt="Home Screen Search example image" 
width="300"/>

- **Favorite Pokémon**: Lets users save Pokémon to favorites by clicking the icon or double-clicking on the card. Users can filter to show only favorite Pokémon using the icon in the top-right corner.

<img src="/lib/assets/home_screen_favourites.jpg"
alt="Home Screen Favourites example image"
width="300"/>

- **Pokémon Details**: Enables navigation to the next screen (PokemonScreen) by clicking on a Pokémon card.

### PokemonScreen

The PokemonScreen displays detailed information about a specific Pokémon. From this screen, users can also add or remove the Pokémon from their favorites list.

<img src="/lib/assets/pokemon_screen.png"
alt="Pokemon Screen example image"
width="300"/>

## Installation

### Android

[Download the APK](https://github.com/Pedrogf03/PokeSearch/raw/refs/heads/v2/PokeSearch.apk)
