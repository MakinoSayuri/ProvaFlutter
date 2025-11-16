import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class HistoricoAbastecimentosPage extends StatelessWidget {
  const HistoricoAbastecimentosPage({super.key});

  int _extractMillis(dynamic raw) {
    if (raw == null) return 0;
    if (raw is int) return raw;
    if (raw is Timestamp) return raw.millisecondsSinceEpoch;
    if (raw is DateTime) return raw.millisecondsSinceEpoch;
    // fallback
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Histórico de Abastecimentos')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: auth.abastecimentosRef().snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.pink),
            );
          }

          final queryDocs = snapshot.data!.docs;

          if (queryDocs.isEmpty) {
            return const Center(
              child: Text("Nenhum abastecimento registrado ainda 💗"),
            );
          }

          final items = queryDocs.map((qs) {
            final map = qs.data();
            final millis = _extractMillis(map['data']);
            return {'snap': qs, 'millis': millis, 'map': map};
          }).toList();

          items.sort((a, b) => (b['millis'] as int).compareTo(a['millis'] as int));

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final snap = items[index]['snap'] as QueryDocumentSnapshot<Map<String, dynamic>>;
              final doc = items[index]['map'] as Map<String, dynamic>;
              final millis = items[index]['millis'] as int;

              final date = millis > 0
                  ? DateTime.fromMillisecondsSinceEpoch(millis)
                  : null; 
              final valorPago = (doc['valorPago'] is num) ? (doc['valorPago'] as num).toDouble() : 0.0;
              final litros = doc['quantidadeLitros']?.toString() ?? '-';
              final quilometragem = doc['quilometragem']?.toString() ?? '-';
              final consumo = (doc['consumo'] is num) ? (doc['consumo'] as num).toDouble() : 0.0;

              return Card(
                elevation: 4,
                shadowColor: Colors.pink.shade100,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  title: Text(
                    "R\$ ${valorPago.toStringAsFixed(2)} • $litros L",
                    style: TextStyle(
                      color: Colors.pink.shade400,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    "${date != null
                        ? "${date.day.toString().padLeft(2,'0')}/${date.month.toString().padLeft(2,'0')}/${date.year} • "
                        : "Date desconhecida • "}KM: $quilometragem\nConsumo: ${consumo.toStringAsFixed(1)} km/L",
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red.shade300),
                    onPressed: () async {
                      await snap.reference.delete();
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
