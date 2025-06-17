import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_gestion/models/client.dart';
import 'package:flutter_gestion/models/dette.dart';
import 'package:flutter_gestion/models/paiement.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({this.baseUrl = 'http://192.168.1.5:3000'});

  Future<List<dynamic>> fetchData(String endpoint) async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/$endpoint'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes)) as List<dynamic>;
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erreur fetchData($endpoint): $e');
      throw Exception('Erreur réseau: $e');
    }
  }

  Future<dynamic> postData(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/$endpoint'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 201 || response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Erreur serveur: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Erreur postData($endpoint): $e');
      throw Exception('Erreur réseau: $e');
    }
  }

  Future<Client> createClient(Map<String, dynamic> clientData) async {
    final response = await postData('clients', clientData);
    return Client.fromJson(response);
  }

  Future<List<Client>> getClients() async {
    final data = await fetchData('clients');
    return data.map<Client>((json) => Client.fromJson(json)).toList();
  }

  Future<List<Dette>> getDettesByClientId({int? clientId}) async {
    final endpoint = clientId != null ? 'dettes?clientId=$clientId' : 'dettes';
    final data = await fetchData(endpoint);
    return data.map<Dette>((json) => Dette.fromJson(json)).toList();
  }

  Future<Dette> createDette(Dette dette) async {
    final response = await postData('dettes', dette.toJson());
    return Dette.fromJson(response);
  }

  Future<List<Paiement>> getPaiementsByDetteId(int detteId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/paiements?detteId=$detteId'),
    );

    if (response.statusCode == 200) {
      final List jsonData = json.decode(response.body);
      return jsonData.map((e) => Paiement.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des paiements');
    }
  }

  Future<Paiement> createPaiement(Paiement paiement) async {
    final response = await postData('paiements', paiement.toJson());
    return Paiement.fromJson(response);
  }
}
