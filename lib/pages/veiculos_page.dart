import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class VeiculosPage extends StatefulWidget {
  const VeiculosPage({super.key});

  @override
  State<VeiculosPage> createState() => _VeiculosPageState();
}

class _VeiculosPageState extends State<VeiculosPage> {
  late final Query<Map<String, dynamic>> veiculosRef;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthService>(context, listen: false);
    veiculosRef = auth.veiculosRef().orderBy('modelo');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("🚗 Meus Veículos")),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.pink.shade300,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () async {
          final result = await Navigator.push<bool>(
            context,
            MaterialPageRoute(builder: (_) => const VeiculoFormPage()),
          );

          if (mounted && result == true) setState(() {});
        },
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: veiculosRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.pink),
            );
          }

          if (snapshot.hasError) {
            return Center(child: Text("Erro ao carregar: ${snapshot.error}"));
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return Center(
              child: Text(
                "Nenhum veículo ainda 💗\nAdicione o primeiro!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.pink.shade400,
                  fontWeight: FontWeight.w600,
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: docs.length,
            itemBuilder: (context, i) {
              final doc = docs[i];
              final data = doc.data();

              return Dismissible(
                key: ValueKey(doc.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  decoration: BoxDecoration(
                    color: Colors.red.shade400,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) => _confirmDelete(doc),
                child: Card(
                  elevation: 6,
                  shadowColor: Colors.pink.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Icon(
                      Icons.directions_car,
                      size: 40,
                      color: Colors.pink.shade300,
                    ),
                    title: Text(
                      "${data['marca']} ${data['modelo']}",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.pink.shade500,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Text(
                          "Placa: ${data['placa']}",
                          style: TextStyle(color: Colors.pink.shade300),
                        ),
                        Text(
                          "Ano: ${data['ano']}",
                          style: TextStyle(color: Colors.pink.shade300),
                        ),
                        Text(
                          "Combustível: ${data['tipoCombustivel']}",
                          style: TextStyle(color: Colors.pink.shade300),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<bool> _confirmDelete(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Excluir veículo?"),
        content: const Text("Tem certeza que deseja excluir este veículo? 💔"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Excluir", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (result == true) {
      try {
        await doc.reference.delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text("Veículo removido 💗"),
              backgroundColor: Colors.pink.shade300,
            ),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Erro ao deletar: $e"),
              backgroundColor: Colors.red,
            ),
          );
        }
        return false;
      }
    }

    return result ?? false;
  }
}

class VeiculoFormPage extends StatefulWidget {
  const VeiculoFormPage({super.key});

  @override
  State<VeiculoFormPage> createState() => _VeiculoFormPageState();
}

class _VeiculoFormPageState extends State<VeiculoFormPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController modelo = TextEditingController();
  final TextEditingController marca = TextEditingController();
  final TextEditingController placa = TextEditingController();
  final TextEditingController ano = TextEditingController();
  final TextEditingController kmInicial = TextEditingController();

  String tipoCombustivel = "Gasolina";
  bool loading = false;

  @override
  void dispose() {
    modelo.dispose();
    marca.dispose();
    placa.dispose();
    ano.dispose();
    kmInicial.dispose();
    super.dispose();
  }

  Future<void> _saveVeiculo() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    final auth = Provider.of<AuthService>(context, listen: false);

    try {
      await auth.veiculosRef().add({
        "marca": marca.text.trim(),
        "modelo": modelo.text.trim(),
        "placa": placa.text.trim(),
        "ano": ano.text.trim(),
        "tipoCombustivel": tipoCombustivel,
        "kmInicial": double.parse(kmInicial.text.trim()),
        "createdAt": FieldValue.serverTimestamp(),
      });

      if (!mounted) return;

      setState(() => loading = false);

      Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        setState(() => loading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Erro ao salvar: $e"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Adicionar Veículo")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _inputField(
                label: "Marca",
                controller: marca,
                icon: Icons.directions_car,
              ),
              const SizedBox(height: 16),
              _inputField(
                label: "Modelo",
                controller: modelo,
                icon: Icons.local_offer,
              ),
              const SizedBox(height: 16),
              _inputField(
                label: "Placa",
                controller: placa,
                icon: Icons.confirmation_number,
              ),
              const SizedBox(height: 16),
              _inputField(
                label: "Ano",
                controller: ano,
                icon: Icons.calendar_month,
                keyboard: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _inputField(
                label: "KM Atual do Veículo",
                controller: kmInicial,
                icon: Icons.speed,
                keyboard: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: tipoCombustivel,
                decoration: InputDecoration(
                  labelText: "Tipo de Combustível",
                  filled: true,
                  fillColor: Colors.pink.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                  labelStyle: TextStyle(color: Colors.pink.shade400),
                ),
                items: const [
                  DropdownMenuItem(value: "Gasolina", child: Text("Gasolina")),
                  DropdownMenuItem(value: "Etanol", child: Text("Etanol")),
                  DropdownMenuItem(value: "Diesel", child: Text("Diesel")),
                  DropdownMenuItem(value: "Flex", child: Text("Flex")),
                ],
                onChanged: (v) {
                  if (v != null) {
                    setState(() => tipoCombustivel = v);
                  }
                },
              ),
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.pink.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: loading ? null : _saveVeiculo,
                  child: loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Salvar",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _inputField({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    TextInputType? keyboard,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: (v) => v == null || v.isEmpty ? "Informe $label" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.pink.shade300),
        filled: true,
        fillColor: Colors.pink.shade50,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide.none,
        ),
        labelStyle: TextStyle(color: Colors.pink.shade400),
      ),
    );
  }
}
