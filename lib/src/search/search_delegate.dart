import 'package:flutter/material.dart';
import 'package:peliculas/src/models/pelicula_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class DataSearch extends SearchDelegate {
  String seleccion = "";
  final peliculasProvider = new PeliculasProvider();

  /* final peliculas = [
    'Spiderman',
    'Capitan America',
    'Aquaman',
    'Batman',
    'Ironman',
    'Capitan America'
  ];

  final peliculasRecientes = ['Spiderman', 'Capitan America']; */

  @override
  List<Widget> buildActions(BuildContext context) {
    // Las acciones de nuestro AppBar como los iconos con acciones para limpiar o cancelar
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          //query es una variable interna del searchDelegate, todo lo que se escribe se guarda ahí, así que lo cambianos a string vacio
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Es el icono que aparece a la izquierda
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        //progress un valor de 0 a 1
        progress: transitionAnimation,
      ),
      onPressed: () {
        //método interno del search delegate
        //el close: recibe de parámetro el contexto y el resultado que se quiere devolver
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Crea los resultados que vamos a mostrar de la busqueda
    return Center(
      child: Container(
        height: 100.0,
        width: 100.0,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // buildSuggestions: Son las sugerencias que aparece cuando escribimos

    if (query.isEmpty) {
      return Container();
    }

    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot) {
        if (snapshot.hasData) {
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((Pelicula pelicula) {
              return ListTile(
                leading: FadeInImage(
                  image: NetworkImage(pelicula.getPosterImg()),
                  placeholder: AssetImage('assets/img/no-image.jpg'),
                  width: 50.0,
                  fit: BoxFit.contain,
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  close(context, null);
                  //necesitamos que el unique ID no sea nulo
                  pelicula.uniqueId = "";
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                },
              );
            }).toList(),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}
