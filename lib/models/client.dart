class Client {
  final int id;
  final String nomComplet;
  final String telephone;
  final String adresse; 

  Client({
    required this.id,
    required this.nomComplet,
    required this.telephone,
    required this.adresse, 
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      id: json['id'] is int ? json['id'] : int.parse(json['id'].toString()),
      nomComplet: json['nomComplet'],
      telephone: json['telephone'],
      adresse: json['adresse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nomComplet': nomComplet,
      'telephone': telephone,
      'adresse': adresse,
    };
  }
}
