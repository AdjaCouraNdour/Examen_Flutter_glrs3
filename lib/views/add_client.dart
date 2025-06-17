
import 'package:flutter/material.dart';
import 'package:flutter_gestion/providers/api_providers.dart';
import 'package:provider/provider.dart';

class AddClient extends StatefulWidget {
  const AddClient({super.key});

  @override
  State<AddClient> createState() => _AddClientDialogState();
}

class _AddClientDialogState extends State<AddClient> {
  final _formKey = GlobalKey<FormState>();
  String nom = '';
  String telephone = '';
  String adresse = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un client'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Nom complet'),
              validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              onSaved: (value) => nom = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Téléphone'),
              validator: (value) => value!.isEmpty ? 'Champ requis' : null,
              onSaved: (value) => telephone = value!,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Adresse'),
              onSaved: (value) => adresse = value ?? '',
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();

              final client = {
                "nomComplet": nom,
                "telephone": telephone,
                "adresse": adresse,
              };

              try {
                await Provider.of<ApiProvider>(context, listen: false)
                    .createClient(client);
                Navigator.pop(context, true);
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Erreur lors de l'ajout")),
                );
              }
            }
          },
          child: const Text('Ajouter'),
        ),
      ],
    );
  }
}