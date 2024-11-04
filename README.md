# PokéSearch

PokéSearch es una aplicación multiplataforma desarrollada en Flutter que emplea la API pública de Pokémon [PokeApi](https://pokeapi.co/).
La app está diseñada para funcionar en dispositivos Android y a través del navegador, siguiendo las pautas de diseño de Material 3.

## Manual de uso

### SplashScreen

La aplicación cuenta con una pantalla de carga al entrar en la misma.

<img src="/lib/assets/splash_screen.png" 
alt="Splash Screen example image" 
width="300"/>

Su función no es más que inicializar la app.

### HomeScreen

La pantalla de Home muestra una lista vertical scrollable de 20 Pokémon. A medida que scrolleamos van cargando los Pokémon hasta tenerlos todos.

<img src="/lib/assets/home_screen.png" 
alt="Home Screen example image" 
width="300"/>

Esta pantalla tiene las siguientes funcionalidades:

- **Búsqueda de Pokémon**: Permite realizar una búsqueda de Pokémon ingresando el nombre en el cuadro de texto de la parte superior.

<img src="/lib/assets/home_screen_search.png" 
alt="Home Screen Search example image" 
width="300"/>

- **Pokémon favoritos**: Permite almacenar Pokémon en favoritos, para posteriormente filtrar por los mismos.

<img src="/lib/assets/home_screen_favourites.png" alt="Home Screen Favourites example image" width="200"/>

- **Detalles de un Pokémon**: Permite acceder a la siguiente pantalla (PokemonScreen), pulsando sobre la carta de un Pokémon.

### PokemonScreen

La pantalla de Pokemon muestra los detalles de un Pokémon concreto. Desde esta pantalla también podemos añadir o quitar el mismo Pokémon de favoritos.

<img src="/lib/assets/pokemon_screen.png" alt="Pokemon Screen example image" width="200"/>