import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart'; // 
import 'veiculos_page.dart';
import 'registrar_abastecimento_page.dart';
import 'historico_abastecimentos_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Início")),
      drawer: const AppDrawer(),

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
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
      ),
    );
  }
}
