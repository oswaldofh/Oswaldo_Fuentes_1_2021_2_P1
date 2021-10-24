import 'package:adaptive_dialog/adaptive_dialog.dart';
import 'package:dog_app/components/loader_component.dart';
import 'package:dog_app/helpers/api_helper.dart';
import 'package:dog_app/models/breed.dart';
import 'package:dog_app/models/response.dart';
import 'package:flutter/material.dart';

class BreedScreen extends StatefulWidget {
  final Breed breed;
  BreedScreen({required this.breed});

  @override
  _BreedScreenState createState() => _BreedScreenState();
}

class _BreedScreenState extends State<BreedScreen> {
  bool _showLoader = false;

  String _description = '';
  String _descriptionError = '';
  bool _descriptionShowError = false;
  TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _description = widget.breed.breed;
    _descriptionController.text = _description;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title:
            Text(widget.breed.breed == 0 ? 'Nueva marca' : widget.breed.breed),
      ),
      body: Stack(
        children: [
          Column(
              // children: <Widget>[_showDescription(), _showButton()],
              ),
          _showLoader
              ? LoaderComponent(
                  text: 'Por favor espere...',
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _showDescription() {
    return Container(
      padding: EdgeInsets.all(10),
      child: TextField(
        autofocus: true,
        controller: _descriptionController, //para que precarge la descripcion
        decoration: InputDecoration(
          hintText: 'Ingresa una descripción...',
          labelText: 'Descripción',
          errorText: _descriptionShowError ? _descriptionError : null,
          suffixIcon: Icon(Icons.description),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        ),
        onChanged: (value) {
          _description = value;
        },
      ),
    );
  }

  bool _validateFields() {
    bool isValid = true;

    if (_description.isEmpty) {
      isValid = false;
      _descriptionShowError = true;
      _descriptionError = 'Debes ingresar una descripción';
    } else {
      _descriptionShowError = false;
    }
    setState(() {});

    return isValid;
  }

  _addRecord() async {
    setState(() {
      _showLoader = true;
    });

    Map<String, dynamic> request = {
      'description': _description,
    };

    setState(() {
      _showLoader = false;
    });

    Response response = await ApiHelper.post('/breed/', request, 'images');

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
    Navigator.pop(context, 'yes'); //yes recarga la pantalla
  }
}
