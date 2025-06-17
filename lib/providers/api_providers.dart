import 'package:flutter/material.dart';
import 'package:flutter_gestion/models/client.dart';
import 'package:flutter_gestion/models/dette.dart';
import 'package:flutter_gestion/models/paiement.dart';
import 'package:flutter_gestion/services/api_service.dart';

class ApiProvider with ChangeNotifier {
  final ApiService apiService = ApiService();

  List<Client> _clients = [];
  List<Dette> _dettes = [];
  List<Paiement> _paiements = [];

  bool _isLoading = false;
  String? _errorMessage;
  Client? _selectedClient;

  List<Client> get clients => _clients;
  List<Dette> get dettes => _dettes;
  List<Paiement> get paiements => _paiements;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Client? get selectedClient => _selectedClient;

  Future<void> fetchClients() async {
    _isLoading = true;
    notifyListeners();

    try {
      _clients = await apiService.getClients();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _clients = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> selectClient(Client client) async {
    _selectedClient = client;
    notifyListeners();
    await fetchDettesByClient(client.id);
  }

  Future<Client?> getClientById(int clientId) async {
    if (_clients.isEmpty) {
      await fetchClients();
    }

    try {
      return _clients.firstWhere((client) => client.id == clientId);
    } catch (e) {
      _errorMessage = 'Client introuvable';
      notifyListeners();
      return null;
    }
  }

  Future<void> fetchDettesByClient(int clientId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _dettes = await apiService.getDettesByClientId(clientId: clientId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _dettes = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addDetteToSelectedClient({
    required double montant,
    required DateTime date,
  }) async {
    if (_selectedClient == null) {
      _errorMessage = 'Aucun client sélectionné';
      notifyListeners();
      return;
    }

    final newDette = Dette(
      montant: montant,
      date: date,
      clientId: _selectedClient!.id,
    );

    await addDetteToClient(newDette);
  }

  Future<void> addDetteToClient(Dette dette) async {
    _isLoading = true;
    notifyListeners();

    try {
      final created = await apiService.createDette(dette);
      _dettes.add(created);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPaiementsByDette(int detteId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _paiements = await apiService.getPaiementsByDetteId(detteId);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _paiements = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }


  Future<void> addPaiement(Paiement paiement) async {
    _isLoading = true;
    notifyListeners();

    try {
      final created = await apiService.createPaiement(paiement);
      _paiements.add(created);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
