import 'package:flutter/material.dart';
import 'package:flutter_gestion/providers/api_providers.dart';
import 'package:flutter_gestion/views/add_client.dart';
import 'package:flutter_gestion/views/dettes_client.dart';
import 'package:provider/provider.dart';

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
        backgroundColor: Colors.red,
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
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.deepOrange,
                          ),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => DettesClient(client: client),
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

      // ✅ Bouton flottant en bas à droite
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await showDialog(
            context: context,
            builder: (_) => const AddClient(),
          );
          if (result == true) {
            Provider.of<ApiProvider>(context, listen: false).fetchClients();
          }
        },
        label: const Text("Ajouter Client"),
        icon: const Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
    );
  }
}

