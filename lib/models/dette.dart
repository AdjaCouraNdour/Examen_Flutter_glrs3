import 'package:flutter_gestion/models/paiement.dart';

class Dette {
  final int? id;
  final double montant;
  final DateTime date;
  final int clientId;
  List<Paiement> paiements;

  Dette({
    this.id,
    required this.montant,
    required this.date,
    required this.clientId,
    this.paiements = const [],
  });

  double get montantPaye => paiements.fold(0, (sum, p) => sum + p.montant);

  double get montantRestant => montant - montantPaye;

  factory Dette.fromJson(Map<String, dynamic> json) {
    return Dette(
      id: int.tryParse(json['id'].toString().split('.')[0]) ?? 0,
      montant: (json['montant'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      clientId: json['clientId'],
      paiements:
          json['paiements'] != null
              ? (json['paiements'] as List)
                  .map((p) => Paiement.fromJson(p))
                  .toList()
              : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'montant': montant,
      'date': date.toIso8601String().split('T').first,
      'clientId': clientId,
      'paiements': paiements.map((p) => p.toJson()).toList(),
    };
  }
}
