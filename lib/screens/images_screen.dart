import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dog_app/components/loader_component.dart';
import 'package:dog_app/helpers/api_helper.dart';
import 'package:dog_app/models/response.dart';
import 'package:flutter/material.dart';

class imagesScreen extends StatefulWidget {
  const imagesScreen({Key? key}) : super(key: key);

  @override
  _imagesScreenState createState() => _imagesScreenState();
}

class _imagesScreenState extends State<imagesScreen> {
  List<Image> _images = [];
  bool _showLoader = false;

  bool _isFilter = false;
  String _search = '';

  @override
  void initState() {
    //se llama cuando la pantalla cambia
    super.initState();

    _getImages();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imagenes'),
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
        backgroundColor: Colors.red,
        onPressed: () => '',
      ),
    );
  }

  Future<Null> _getImages() async {
    setState(() {
      _showLoader = true;
    });
    Response response = await ApiHelper.getImages();

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
      _images = response.result;
    });
  }

  Widget _getContent() {
    return _images.length == 0 ? _noContent() : _getListView();
  }

  Widget _noContent() {
    return Center(
      child: Container(
        margin: EdgeInsets.all(20),
        child: Text(
          _isFilter
              ? 'No hay Imagenes con ese criterio de busqueda..'
              : 'No hay Imagenes registradas..',
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
      onRefresh: _getImages, //se refresca la pantalla al bajarla
      child: ListView(
        children: _images.map((e) {
          return Card(
            child: InkWell(
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          e.alignment.toString(),
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
    _getImages();
  }

  void _showFilter() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text('Filtrar fotos'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text('Escriba las primeras letras de la foto'),
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
              TextButton(onPressed: () => '', child: Text('Filtrar')),
            ],
          );
        });
  }
}
