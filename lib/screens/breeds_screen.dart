import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:connectivity/connectivity.dart';
import 'package:dog_app/components/loader_component.dart';
import 'package:dog_app/helpers/api_helper.dart';
import 'package:dog_app/models/breed.dart';
import 'package:dog_app/models/response.dart';
import 'package:flutter/material.dart';

import 'breed_screen.dart';

class BreedsScreem extends StatefulWidget {
  const BreedsScreem({Key? key}) : super(key: key);

  @override
  _BreedsScreemState createState() => _BreedsScreemState();
}

class _BreedsScreemState extends State<BreedsScreem> {
  List<Breed> _breeds = [];
  bool _showLoader = false;

  bool _isFilter = false;
  String _search = '';

  @override
  void initState() {
    //se llama cuando la pantalla cambia
    super.initState();

    _getBreeds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Razas'),
        backgroundColor: Colors.brown,
        actions: <Widget>[
          _isFilter
              ? IconButton(
                  onPressed: _removeFilter, icon: Icon(Icons.filter_none))
              : IconButton(onPressed: _showFilter, icon: Icon(Icons.filter_alt))
        ],
      ),
      body: Center(
        child: _showLoader
            ? LoaderComponent(
                text: 'Por favor espere...',
              )
            : _getContent(),
      ),
      floatingActionButton: FloatingActionButton(
        //agregar un boton flotante
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
        onPressed: () => _goAdd(),
      ),
    );
  }

  Future<Null> _getBreeds() async {
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

    setState(() {
      _showLoader = true;
    });
    Response response = await ApiHelper.getBreeds();

    setState(() {
      _showLoader = false;
    });

    if (!response.isSuccess) {
      await showAlertDialog(
          context: context,
          title: 'Error',
          message: response.message,
          actions: <AlertDialogAction>[
            AlertDialogAction(key: null, label: 'Aceptar'),
          ]);
      return;
    }
    setState(() {
      _breeds = response.result;
    });
  }

  Widget _getContent() {
    return _breeds.length == 0 ? _noContent() : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFilter
              ? 'No hay Raza con ese criterio de busqueda..'
              : 'No hay Raza registradas..',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _getListView() {
    return RefreshIndicator(
      onRefresh: _getBreeds, //se refresca la pantalla al bajarla
      child: ListView(
        children: _breeds.map((e) {
          return Card(
            child: InkWell(
              onTap: () => _goEdit(e),
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.breed,
                          style: TextStyle(fontSize: 20),
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ); //cuando hacen clic en cualquiera de ellos
        }).toList(),
      ),
    );
  }

  void _removeFilter() {
    setState(() {
      _isFilter = false;
    });
    _getBreeds();
  }

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text('Filtrar raza'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Escriba las primeras letras de la raza'),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                      hintText: 'Criterio de busqueda...',
                      labelText: 'Buscar',
                      suffixIcon: Icon(Icons.search)),
                  onChanged: (value) {
                    _search = value;
                  },
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Cancelar')),
              TextButton(onPressed: () => _filter(), child: Text('Filtrar')),
            ],
          );
        });
  }

  void _filter() {
    if (_search.isEmpty) {
      return;
    }
    List<Breed> filteredList = [];

    for (var brand in _breeds) {
      if (brand.breed.toLowerCase().contains(_search.toLowerCase())) {
        filteredList.add(brand);
      }
    }
    setState(() {
      _breeds = filteredList;
      _isFilter = true;
    });

    Navigator.of(context).pop();
  }

  void _goAdd() async {
    String? result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) => BreedScreen(breed: )));

    if (result == 'yes') {
      _getBreeds();
    }
  }

  void _goEdit(Breed breed) async {
    String result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => BreedScreen(breed: breed)));

    if (result == 'yes') {
      _getBreeds();
    }
  }
}
