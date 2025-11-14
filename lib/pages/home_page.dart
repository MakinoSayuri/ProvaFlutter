import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'veiculos_page.dart';
import 'registrar_abastecimento_page.dart';
import 'historico_abastecimentos_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Início")),
      drawer: _buildCuteDrawer(context, auth),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            Icon(Icons.favorite, size: 80, color: Colors.pink.shade300),

            const SizedBox(height: 16),

            Text(
              "Bem-vinda(o) ao seu app de abastecimento ",
              style: TextStyle(
                fontSize: 20,
                color: Colors.pink.shade400,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 40),

            _cuteButton(
              context,
              label: "Meus Veículos",
              icon: Icons.directions_car,
              page: const VeiculosPage(),
            ),

            const SizedBox(height: 16),

            _cuteButton(
              context,
              label: "Registrar Abastecimento",
              icon: Icons.local_gas_station,
              page: const RegistrarAbastecimentoPage(),
            ),

            const SizedBox(height: 16),

            _cuteButton(
              context,
              label: "Histórico de Abastecimentos",
              icon: Icons.history,
              page: const HistoricoAbastecimentosPage(),
            ),
          ],
        ),
      ),
    );
  }

  Drawer _buildCuteDrawer(BuildContext context, AuthService auth) {
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
                  "Abastecimento Cute",
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
            leading: const Icon(Icons.directions_car, color: Colors.pink),
            title: const Text("Meus Veículos"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const VeiculosPage()),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.local_gas_station, color: Colors.pink),
            title: const Text("Registrar Abastecimento"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const RegistrarAbastecimentoPage()),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.history, color: Colors.pink),
            title: const Text("Histórico"),
            onTap: () => Navigator.push(
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
          )
        ],
      ),
    );
  }

  Widget _cuteButton(BuildContext context,
      {required String label, required IconData icon, required Widget page}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: Icon(icon, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(fontSize: 18),
        ),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => page));
        },
      ),
    );
  }
}
