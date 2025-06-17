import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Page Profil',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    );
  }
}
