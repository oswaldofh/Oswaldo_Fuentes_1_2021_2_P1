import 'dart:convert';

import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dog_app/helpers/constants.dart';
import 'package:dog_app/models/breed.dart';
import 'package:dog_app/screens/breeds_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'images_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _showLoader = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dogs'),
        backgroundColor: Colors.brown,
      ),
      body: _getBody(),
      drawer: _getCustomerMenu(),
      //es el menu
    );
  }

  Widget _getBody() {
    return Container(
      margin: EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: const FadeInImage(
                placeholder: AssetImage('assets/logo_app.jpeg'),
                image: AssetImage('assets/logo_app.jpeg'),
                height: 300,
                fit: BoxFit.cover),
          ),
          const SizedBox(
            height: 20,
          ),
          const Center(
            child: Text(
              'Bienvenid@ al mundo de los perros',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getCustomerMenu() {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        const DrawerHeader(
            child: Image(
          image: AssetImage('assets/logo_app.jpeg'),
        )),
        ListTile(
          leading: const Icon(Icons.pets),
          title: const Text('Raza de perros'),
          onTap: () {
            Navigator.push(
              // no reemplaza la pagina si no que la pone encima
              //navegar al login
              //navegar entre paginas
              context,
              MaterialPageRoute(builder: (context) => BreedsScreem()),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.photo_sharp),
          title: const Text('Fotos'),
          onTap: () {
            Navigator.push(
              // no reemplaza la pagina si no que la pone encima
              //navegar al login
              //navegar entre paginas
              context,
              MaterialPageRoute(
                builder: (context) => imagesScreen(),
              ),
            );
          },
        ),
        const Divider(
          color: Colors.black,
          height: 2,
        ),
      ],
    ));
  }

  void _conectivity() async {
    var conectivityresul = await Connectivity().checkConnectivity();
    if (conectivityresul == ConnectivityResult.none) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: 'Verifica la conexion a internet',
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
  }
}
