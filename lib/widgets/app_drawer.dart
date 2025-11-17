import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/auth_service.dart';
import '../pages/home_page.dart';
import '../pages/veiculos_page.dart';
import '../pages/registrar_abastecimento_page.dart';
import '../pages/historico_abastecimentos_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Drawer(
      backgroundColor: Colors.pink.shade50,
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.pink.shade300,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.favorite, size: 60, color: Colors.white),
                const SizedBox(height: 8),
                const Text(
                  "Abastecimento",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),

          ListTile(
            leading: const Icon(Icons.home, color: Colors.pink),
            title: const Text("Início"),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HomePage()),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.directions_car, color: Colors.pink),
            title: const Text("Meus Veículos"),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const VeiculosPage()),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.local_gas_station, color: Colors.pink),
            title: const Text("Registrar Abastecimento"),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const RegistrarAbastecimentoPage()),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.history, color: Colors.pink),
            title: const Text("Histórico de Abastecimentos"),
            onTap: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HistoricoAbastecimentosPage()),
            ),
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.pink),
            title: const Text("Sair"),
            onTap: () async {
              await auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
