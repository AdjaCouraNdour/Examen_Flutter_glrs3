import 'package:flutter/material.dart';
import 'package:flutter_gestion/models/client.dart';
import 'package:flutter_gestion/providers/api_providers.dart';
import 'package:flutter_gestion/views/add_dette.dart';
import 'package:flutter_gestion/views/paiements_dettes.dart';
import 'package:provider/provider.dart';

class DettesClient extends StatefulWidget {
  final Client client;

  const DettesClient({Key? key, required this.client}) : super(key: key);

  @override
  State<DettesClient> createState() => _DettesClientState();
}

class _DettesClientState extends State<DettesClient> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApiProvider>(context, listen: false)
          .fetchDettesByClient(widget.client.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dettes de ${widget.client.nomComplet}'),
        backgroundColor: Colors.red,
      ),
      body: Consumer<ApiProvider>(
        builder: (context, apiProvider, child) {
          if (apiProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (apiProvider.errorMessage != null) {
            return Center(
              child: Text(
                '❌ Erreur : ${apiProvider.errorMessage}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          final dettes = apiProvider.dettes;

          if (dettes.isEmpty) {
            return const Center(
              child: Text('Aucune dette trouvée pour ce client.'),
            );
          }

          // Calcul des sommes totales
          final double sommeTotale =
              dettes.fold(0, (sum, dette) => sum + dette.montant);
          final double sommeRestante =
              dettes.fold(0, (sum, dette) => sum + dette.montantRestant);

          return Column(
            children: [
              Container(
                width: double.infinity,
                color: Colors.grey[200],
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Somme totale des dettes : ${sommeTotale.toStringAsFixed(2)} FCFA',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Somme restante à payer : ${sommeRestante.toStringAsFixed(2)} FCFA',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: sommeRestante > 0 ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: dettes.length,
                  itemBuilder: (context, index) {
                    final dette = dettes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text('Montant : ${dette.montant} FCFA'),
                        subtitle: Text(
                          'Date : ${dette.date.toLocal().toString().split(' ')[0]}',
                        ),
                        trailing: dette.montantRestant <= 0
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.warning, color: Colors.red),
                        onTap: () {
                          if (dette.id != null) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaiementsDettes(dette: dette),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Cette dette n'a pas d'ID valide.")),
                            );
                          }
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(
              builder: (_) => AddDettePage(client: widget.client),
            ),
          );

          if (result == true) {
            // Recharge les dettes après ajout
            Provider.of<ApiProvider>(context, listen: false)
                .fetchDettesByClient(widget.client.id);
          }
        },
      ),
    );
  }
}
