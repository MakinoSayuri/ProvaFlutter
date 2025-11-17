import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import 'veiculos_page.dart';
import 'registrar_abastecimento_page.dart';
import 'historico_abastecimentos_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50,
      appBar: AppBar(
        title: const Text("Início"),
        backgroundColor: Colors.pink.shade300,
        elevation: 3,
      ),
      drawer: const AppDrawer(),

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.pink.shade100,
                    blurRadius: 20,
                    spreadRadius: 5,
                  )
                ],
              ),
              child: Icon(
                Icons.favorite,
                size: 70,
                color: Colors.pink.shade300,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "Bem-vinda(o) ao seu app de abastecimento",
              style: TextStyle(
                fontSize: 22,
                color: Colors.pink.shade400,
                fontWeight: FontWeight.w700,
                height: 1.3,
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

            const SizedBox(height: 18),

            _cuteButton(
              context,
              label: "Registrar Abastecimento",
              icon: Icons.local_gas_station,
              page: const RegistrarAbastecimentoPage(),
            ),

            const SizedBox(height: 18),

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
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.pink.shade100.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, size: 32, color: Colors.pink.shade400),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.pink.shade600,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios,
                  size: 18, color: Colors.pink.shade300),
            ],
          ),
        ),
      ),
    );
  }
}
