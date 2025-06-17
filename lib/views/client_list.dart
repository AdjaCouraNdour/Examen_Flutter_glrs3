// import 'package:flutter/material.dart';
// import 'package:flutter_gestion/providers/client_providers.dart';
// import 'package:provider/provider.dart';

// class ClientList extends StatefulWidget {
//   const ClientList({super.key});

//   @override
//   State<ClientList> createState() => _ClientListState();
// }

// class _ClientListState extends State<ClientList> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Provider.of<ApiProvider>(context, listen: false).fetchClients();
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       appBar: AppBar(
//         title: const Text('📋 Liste des Clients'),
//         centerTitle: true,
//         backgroundColor: Colors.deepOrange,
//         elevation: 0,
//       ),
//       body: Consumer<ApiProvider>(
//         builder: (context, provider, child) {
//           if (provider.isLoading) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           if (provider.errorMessage != null) {
//             return Center(
//               child: Text(
//                 '❌ Erreur : ${provider.errorMessage}',
//                 style: const TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             );
//           }

//           final clients = provider.clients;
//           if (clients.isEmpty) {
//             return const Center(child: Text('Aucun client trouvé.'));
//           }

//           return Padding(
//             padding: const EdgeInsets.all(12),
//             child: Column(
//               children: [
//                 // 🔍 Barre de recherche (non fonctionnelle ici)
//                 TextField(
//                   decoration: InputDecoration(
//                     hintText: 'Rechercher un client...',
//                     prefixIcon: const Icon(Icons.search),
//                     filled: true,
//                     fillColor: Colors.white,
//                     contentPadding: const EdgeInsets.symmetric(horizontal: 20),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(30),
//                       borderSide: BorderSide.none,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Expanded(
//                   child: ListView.builder(
//                     itemCount: clients.length,
//                     itemBuilder: (context, index) {
//                       final client = clients[index];
//                       final isSelected = provider.selectedClient?.id == client.id;

//                       return AnimatedContainer(
//                         duration: const Duration(milliseconds: 300),
//                         margin: const EdgeInsets.only(bottom: 15),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black12,
//                               blurRadius: 6,
//                               offset: const Offset(0, 2),
//                             ),
//                           ],
//                           border: isSelected
//                               ? Border.all(color: Colors.green, width: 2)
//                               : Border.all(color: Colors.transparent),
//                         ),
//                         child: ListTile(
//                           contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//                           leading: CircleAvatar(
//                             radius: 25,
//                             backgroundColor: Colors.orange.shade400,
//                             child: Text(
//                               client.nomComplet.substring(0, 1).toUpperCase(),
//                               style: const TextStyle(fontSize: 20, color: Colors.white),
//                             ),
//                           ),
//                           title: Text(
//                             client.nomComplet,
//                             style: const TextStyle(fontWeight: FontWeight.w600),
//                           ),
//                           subtitle: Text('📞 ${client.telephone}'),
//                           trailing: AnimatedSwitcher(
//                             duration: const Duration(milliseconds: 300),
//                             child: isSelected
//                                 ? const Icon(Icons.check_circle, color: Colors.green, size: 28, key: ValueKey('selected'))
//                                 : const Icon(Icons.person_outline, color: Colors.grey, size: 28, key: ValueKey('unselected')),
//                           ),
//                           onTap: () async {
//                             await provider.selectClient(client);
//                             ScaffoldMessenger.of(context).showSnackBar(
//                               SnackBar(
//                                 content: Text('✅ Client sélectionné : ${client.nomComplet}'),
//                                 backgroundColor: Colors.green,
//                                 duration: const Duration(seconds: 2),
//                               ),
//                             );
//                           },
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_gestion/providers/api_providers.dart';
import 'package:flutter_gestion/views/dettes_client.dart';
import 'package:provider/provider.dart';

// Ta page liste clients
class ClientList extends StatefulWidget {
  const ClientList({super.key});

  @override
  State<ClientList> createState() => _ClientListState();
}

class _ClientListState extends State<ClientList> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ApiProvider>(context, listen: false).fetchClients();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('📋 Liste des Clients'),
        centerTitle: true,
        backgroundColor: Colors.deepOrange,
        elevation: 0,
      ),
      body: Consumer<ApiProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.errorMessage != null) {
            return Center(
              child: Text(
                '❌ Erreur : ${provider.errorMessage}',
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          final clients = provider.clients;
          if (clients.isEmpty) {
            return const Center(child: Text('Aucun client trouvé.'));
          }

          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Rechercher un client...',
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: clients.length,
                    itemBuilder: (context, index) {
                      final client = clients[index];
                      final isSelected =
                          provider.selectedClient?.id == client.id;

                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                          border:
                              isSelected
                                  ? Border.all(color: Colors.green, width: 2)
                                  : Border.all(color: Colors.transparent),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 10,
                          ),
                          leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: Colors.orange.shade400,
                            child: Text(
                              client.nomComplet.substring(0, 1).toUpperCase(),
                              style: const TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          title: Text(
                            client.nomComplet,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('📞 ${client.telephone}'),
                          trailing: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child:
                                isSelected
                                    ? const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                      size: 28,
                                      key: ValueKey('selected'),
                                    )
                                    : const Icon(
                                      Icons.person_outline,
                                      color: Colors.grey,
                                      size: 28,
                                      key: ValueKey('unselected'),
                                    ),
                          ),
                          onTap: () async {
                            await provider.selectClient(client);
                            // Navigation vers DettesClient
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DettesClient(client: client),
                              ),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '✅ Client sélectionné : ${client.nomComplet}',
                                ),
                                backgroundColor: Colors.green,
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
