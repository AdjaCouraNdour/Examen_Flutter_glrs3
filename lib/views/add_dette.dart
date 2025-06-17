import 'package:flutter/material.dart';
import 'package:flutter_gestion/models/client.dart';
import 'package:flutter_gestion/providers/api_providers.dart';
import 'package:provider/provider.dart';

class AddDettePage extends StatefulWidget {
  final Client client;

  const AddDettePage({Key? key, required this.client}) : super(key: key);

  @override
  State<AddDettePage> createState() => _AddDettePageState();
}

class _AddDettePageState extends State<AddDettePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _montantController = TextEditingController();
  DateTime? _selectedDate;

  @override
  void dispose() {
    _montantController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final today = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? today,
      firstDate: DateTime(today.year - 5),
      lastDate: DateTime(today.year + 5),
    );

    if (date != null) {
      setState(() {
        _selectedDate = date;
      });
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Veuillez sélectionner une date')),
        );
        return;
      }

      final montant = double.tryParse(_montantController.text);
      if (montant == null || montant <= 0) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Montant invalide')));
        return;
      }

      try {
        await Provider.of<ApiProvider>(
          context,
          listen: false,
        ).addDetteToSelectedClient(
          // clientId: widget.client.id,
          montant: montant,
          date: _selectedDate!,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Dette de $montant FCFA ajoutée pour ${widget.client.nomComplet} le ${_selectedDate!.toLocal().toString().split(" ")[0]}',
            ),
            backgroundColor: Colors.green,
          ),
        );

        Navigator.pop(context, true); 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de l\'ajout de la dette : $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter une dette pour ${widget.client.nomComplet}'),
        backgroundColor: Colors.deepOrange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _montantController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Montant (FCFA)',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.monetization_on),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez saisir un montant';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Montant invalide';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedDate == null
                          ? 'Aucune date sélectionnée'
                          : 'Date : ${_selectedDate!.toLocal().toString().split(" ")[0]}',
                    ),
                  ),
                  TextButton(
                    onPressed: _pickDate,
                    child: const Text('Choisir une date'),
                  ),
                ],
              ),
              const Spacer(),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  minimumSize: const Size(double.infinity, 50),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Ajouter la dette'),
                onPressed: _submit,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
