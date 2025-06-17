// import 'package:flutter/material.dart';
// import 'package:flutter_gestion/models/client.dart';
// import 'package:flutter_gestion/providers/api_providers.dart';
// import 'package:provider/provider.dart';

// // 1. Widget DettesClient qui prend un client
// class DettesClient extends StatefulWidget {
//   final Client client;

//   const DettesClient({Key? key, required this.client}) : super(key: key);

//   @override
//   State<DettesClient> createState() => _DettesClientState();
// }

// class _DettesClientState extends State<DettesClient> {
//   @override
//   void initState() {
//     super.initState();
//     // On charge les dettes du client au démarrage
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ApiProvider>(
//         context,
//         listen: false,
//       ).fetchDettesByClient(widget.client.id);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Dettes de ${widget.client.nomComplet}'),
//         backgroundColor: Colors.deepOrange,
//       ),
//       body: Consumer<ApiProvider>(
//         builder: (context, apiProvider, child) {
//           if (apiProvider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (apiProvider.errorMessage != null) {
//             return Center(
//               child: Text(
//                 '❌ Erreur : ${apiProvider.errorMessage}',
//                 style: const TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             );
//           }

//           final dettes = apiProvider.dettes;

//           if (dettes.isEmpty) {
//             return const Center(
//               child: Text('Aucune dette trouvée pour ce client.'),
//             );
//           }

//           return ListView.builder(
//             padding: const EdgeInsets.all(12),
//             itemCount: dettes.length,
//             itemBuilder: (context, index) {
//               final dette = dettes[index];
//               return Card(
//                 margin: const EdgeInsets.only(bottom: 12),
//                 child: ListTile(
//                   title: Text('Montant : ${dette.montant} FCFA'),
//                   subtitle: Text(
//                     'Date : ${dette.date.toLocal().toString().split(' ')[0]}',
//                   ),
//                   trailing:
//                       dette.montant == 0
//                           ? const Icon(Icons.check_circle, color: Colors.green)
//                           : const Icon(Icons.warning, color: Colors.red),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_gestion/models/client.dart';
import 'package:flutter_gestion/providers/api_providers.dart';
import 'package:flutter_gestion/views/paiements_dettes.dart';
import 'package:provider/provider.dart';

// 1. Widget DettesClient qui prend un client
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
    // On charge les dettes du client au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApiProvider>(
        context,
        listen: false,
      ).fetchDettesByClient(widget.client.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dettes de ${widget.client.nomComplet}'),
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

          final dettes = apiProvider.dettes;

          if (dettes.isEmpty) {
            return const Center(
              child: Text('Aucune dette trouvée pour ce client.'),
            );
          }

          return ListView.builder(
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
          );
        },
      ),
    );
  }
}
