import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class RegistrarAbastecimentoPage extends StatefulWidget {
  const RegistrarAbastecimentoPage({super.key});

  @override
  State<RegistrarAbastecimentoPage> createState() =>
      _RegistrarAbastecimentoPageState();
}

class _RegistrarAbastecimentoPageState
    extends State<RegistrarAbastecimentoPage> {
  final _formKey = GlobalKey<FormState>();

  final litrosCtrl = TextEditingController();
  final valorCtrl = TextEditingController();
  final kmCtrl = TextEditingController();
  final obsCtrl = TextEditingController();

  String? veiculoSelecionado;
  String tipoCombustivel = "Gasolina";
  DateTime dataSelecionada = DateTime.now();
  bool loading = false;

  @override
  void dispose() {
    litrosCtrl.dispose();
    valorCtrl.dispose();
    kmCtrl.dispose();
    obsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text("Registrar Abastecimento")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: auth.veiculosRef().orderBy('modelo').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const CircularProgressIndicator();
                  }

                  final docs = snapshot.data!.docs;

                  return DropdownButtonFormField<String>(
                    value: veiculoSelecionado,
                    decoration: _decoration("Selecione o veículo"),
                    items: docs
                        .map(
                          (doc) => DropdownMenuItem(
                            value: doc.id,
                            child: Text(
                              "${doc['marca']} ${doc['modelo']} - ${doc['placa']}",
                            ),
                          ),
                        )
                        .toList(),
                    validator: (v) => v == null ? "Escolha um veículo" : null,
                    onChanged: (v) => setState(() => veiculoSelecionado = v),
                  );
                },
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: litrosCtrl,
                keyboardType: TextInputType.number,
                decoration: _decoration("Quantidade de Litros"),
                validator: (v) =>
                    v!.isEmpty ? "Informe a quantidade de litros" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: valorCtrl,
                keyboardType: TextInputType.number,
                decoration: _decoration("Valor Pago (R\$)"),
                validator: (v) => v!.isEmpty ? "Informe o valor" : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: kmCtrl,
                keyboardType: TextInputType.number,
                decoration: _decoration("Quilometragem Atual"),
                validator: (v) => v!.isEmpty ? "Informe a KM" : null,
              ),
              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: tipoCombustivel,
                decoration: _decoration("Tipo de Combustível"),
                items: const [
                  DropdownMenuItem(value: "Gasolina", child: Text("Gasolina")),
                  DropdownMenuItem(value: "Etanol", child: Text("Etanol")),
                  DropdownMenuItem(value: "Diesel", child: Text("Diesel")),
                  DropdownMenuItem(value: "Flex", child: Text("Flex")),
                ],
                onChanged: (v) => setState(() => tipoCombustivel = v!),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: obsCtrl,
                decoration: _decoration("Observação (opcional)"),
              ),
              const SizedBox(height: 24),

              // Botão salvar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : () => _salvar(auth),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Salvar Abastecimento"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _decoration(String label) {
    return InputDecoration(
      labelText: label,
      filled: true,
      fillColor: Colors.pink.shade50,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      labelStyle: TextStyle(color: Colors.pink.shade400),
    );
  }

  Future<void> _salvar(AuthService auth) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      final litros = double.parse(litrosCtrl.text);
      final valor = double.parse(valorCtrl.text);
      final km = double.parse(kmCtrl.text);

      final consumo = litros > 0 ? (km / litros) : 0;

      await auth.abastecimentosRef().add({
        "veiculoId": veiculoSelecionado,
        "quantidadeLitros": litros,
        "valorPago": valor,
        "quilometragem": km,
        "tipoCombustivel": tipoCombustivel,
        "consumo": consumo,
        "observacao": obsCtrl.text.trim(),
        "data": DateTime.now().millisecondsSinceEpoch,
      });

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
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
