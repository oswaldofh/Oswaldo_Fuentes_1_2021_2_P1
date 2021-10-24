class Breed {
  String breed = '';

  Breed({required this.breed});

  Breed.fromJson(Map<String, dynamic> json) {
    breed = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['breed'] = breed;
    return data;
  }
}
