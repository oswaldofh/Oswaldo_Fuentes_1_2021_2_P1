import 'dart:convert';

import 'package:dog_app/helpers/constants.dart';
import 'package:dog_app/models/breed.dart';
import 'package:dog_app/models/image.dart';
import 'package:dog_app/models/response.dart';

import 'package:http/http.dart' as http;

class ApiHelper {
  static Future<Response> getBreeds() async {
    var url = Uri.parse('${Constans.apiUrl}/breeds/list/all');
    var response = await http.get(url);

    List<Breed> breeds = [];

    if (response.statusCode == 200) {
      Map mapData = await json.decode(response.body);
      var data = mapData["message"];
      for (String key in data.keys) {
        if (key != "") {
          Breed b = Breed(breed: key);
          breeds.add(b);
        }
      }
    }
    return Response(isSuccess: true, result: breeds);
  }

  static Future<Response> getImages() async {
    var url = Uri.parse('${Constans.apiUrl}/breed/bulldog/images');

    var response = await http.get(
      url,
    );

    List<Image> list = [];

    //var map = jsonDecode(response.body);
    //print(map);
    var decodedjson = json.decode(response.body);

    if (decodedjson != null) {
      for (var item in decodedjson) {
        list.add(Image.fromJson(item)); //se cargan todos los procedimientos
      }
    }

    return Response(isSuccess: true, result: list);
  }

  static Future<Response> post(
      String controller, Map<String, dynamic> request, String token) async {
    var url = Uri.parse('${Constans.apiUrl}$controller');
    //var url = Uri.parse('${Constans.apiUrl}/breed/$controller/images');
    var response = await http.post(
      url,
    );

    if (response.statusCode >= 400) {
      return Response(isSuccess: false, message: response.body);
    }

    return Response(isSuccess: true);
  }
}
