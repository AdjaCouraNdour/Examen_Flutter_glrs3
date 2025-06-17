import 'package:flutter/material.dart';
import 'package:flutter_gestion/models/dette.dart';
import 'package:flutter_gestion/providers/api_providers.dart';
import 'package:provider/provider.dart';

class PaiementsDettes extends StatefulWidget {
  final Dette dette;

  const PaiementsDettes({Key? key, required this.dette}) : super(key: key);

  @override
  State<PaiementsDettes> createState() => _PaiementsDettesState();
}

class _PaiementsDettesState extends State<PaiementsDettes> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final detteId = widget.dette.id;
      if (detteId != null) {
        Provider.of<ApiProvider>(
          context,
          listen: false,
        ).fetchPaiementsByDetteId(detteId);
      } else {
        debugPrint("Erreur : l'id de la dette est null");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Tu peux afficher l'ID de la dette, ou un texte générique
        title: Text('Paiements pour la dette #${widget.dette.id}'),
        backgroundColor: Colors.deepOrange,
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

          final paiements = apiProvider.paiements;

          if (paiements.isEmpty) {
            return const Center(
              child: Text('Aucun paiement trouvé pour cette dette.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: paiements.length,
            itemBuilder: (context, index) {
              final paiement = paiements[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  title: Text('Montant payé : ${paiement.montant} FCFA'),
                  subtitle: Text(
                    'Date : ${paiement.date.toLocal().toString().split(' ')[0]}',
                  ),
                  trailing: const Icon(Icons.attach_money, color: Colors.green),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
