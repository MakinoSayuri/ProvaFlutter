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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.pink.shade300,
                  Colors.pink.shade400,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.white,
                    size: 46,
                  ),
                ),
                const SizedBox(width: 16),
                const Text(
                  "Abastecimento",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Inter",
                  ),
                ),
              ],
            ),
          ),

          _item(
            context,
            icon: Icons.home,
            label: "Início",
            page: const HomePage(),
          ),
          _item(
            context,
            icon: Icons.directions_car,
            label: "Meus Veículos",
            page: const VeiculosPage(),
          ),
          _item(
            context,
            icon: Icons.local_gas_station,
            label: "Registrar Abastecimento",
            page: const RegistrarAbastecimentoPage(),
          ),
          _item(
            context,
            icon: Icons.history,
            label: "Histórico de Abastecimentos",
            page: const HistoricoAbastecimentosPage(),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Divider(
              color: Colors.pink.shade200,
              thickness: 0.8,
            ),
          ),

          _item(
            context,
            icon: Icons.exit_to_app,
            label: "Sair",
            onTap: () async {
              await auth.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),

          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              "Versão 1.0",
              style: TextStyle(
                color: Colors.pink.shade300,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    required IconData icon,
    required String label,
    Widget? page,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.pink.shade400),
      title: Text(
        label,
        style: TextStyle(
          color: Colors.pink.shade700,
          fontSize: 16,
          fontWeight: FontWeight.w500,
          fontFamily: "Inter",
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      hoverColor: Colors.pink.shade100,
      splashColor: Colors.pink.shade200.withOpacity(0.3),
      onTap: () {
        Navigator.pop(context);
        if (onTap != null) return onTap();
        if (page != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => page),
          );
        }
      },
    );
  }
}
