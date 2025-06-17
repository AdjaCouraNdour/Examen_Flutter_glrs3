class Paiement {
  final int? id;
  final double montant;
  final DateTime date;
  final int detteId;

  Paiement({
    this.id,
    required this.montant,
    required this.date,
    required this.detteId,
  });

  factory Paiement.fromJson(Map<String, dynamic> json) {
    return Paiement(
      id: json['id'],
      montant: (json['montant'] as num).toDouble(),
      date: DateTime.parse(json['date']),
      detteId: json['detteId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'montant': montant,
      'date': date.toIso8601String().split('T').first,
      'detteId': detteId,
    };
  }
}
