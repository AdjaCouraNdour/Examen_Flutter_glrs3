import 'package:flutter/material.dart';
import 'package:flutter_gestion/providers/api_providers.dart';
import 'package:flutter_gestion/views/client_list.dart';
import 'package:flutter_gestion/views/bottom_view.dart';
import 'package:flutter_gestion/views/profil_page.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApiProvider()..fetchClients()),
        // Ajoute d'autres providers ici si besoin
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Gestion Clients',
      theme: ThemeData(primarySwatch: Colors.red, fontFamily: 'Poppins'),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [const ClientList(), const ProfilPage()];

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F3F3),
      appBar: AppBar(
        title: Text(_currentIndex == 0 ? 'Accueil' : 'Profil'),
        backgroundColor: const Color(0xFFEC6C1B),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }
}

// void main() {
//   runApp(MainApp());
// }

// class MainApp extends StatelessWidget {
//   const MainApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final compteService = CompteService(baseUrl: 'http://192.168.1.123:3000');

//     return MaterialApp(
//       title: 'Flutter Bank',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(primarySwatch: Colors.brown),
//       initialRoute: "/",
//       routes: {
//         "/":
//             (context) =>
//                 layoutPage(contentPage: CompteListPage(service: compteService)),
//         "/form":
//             (context) =>
//                 layoutPage(contentPage: FormComptePage(service: compteService)),
//       },
//     );
//   }
// }
