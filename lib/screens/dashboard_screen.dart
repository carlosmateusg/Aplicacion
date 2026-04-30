import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';

import '../models/measurement.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // Cuenta alertas peligrosas
  int contarAlertas(List<Measurement> lista) {
    int total = 0;

    for (var m in lista) {
      if (m.monoxido > 25 ||
          m.co2 > 5000 ||
          m.metano > 5 ||
          m.sulfuricos > 1 ||
          m.nitrosos > 0.5 ||
          m.oxigeno < 19.5 ||
          m.oxigeno > 23.5) {
        total++;
      }
    }

    return total;
  }

  // Estado última medición
  String estadoActual(Measurement m) {
    if (m.monoxido > 25 ||
        m.co2 > 5000 ||
        m.metano > 5 ||
        m.sulfuricos > 1 ||
        m.nitrosos > 0.5 ||
        m.oxigeno < 19.5 ||
        m.oxigeno > 23.5) {
      return "ALERTA";
    }

    return "SEGURO";
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<Measurement>('mediciones');
    final lista = box.values.toList();

    final total = lista.length;
    final alertas = contarAlertas(lista);

    Measurement? ultima =
        lista.isNotEmpty ? lista.last : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Panel de Control"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            Card(
              child: ListTile(
                leading: const Icon(Icons.storage),
                title: const Text("Total mediciones"),
                trailing: Text("$total"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.warning),
                title: const Text("Alertas detectadas"),
                trailing: Text("$alertas"),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.analytics),
                title: const Text("Estado actual"),
                trailing: Text(
                  ultima == null
                      ? "Sin datos"
                      : estadoActual(ultima),
                  style: TextStyle(
                    color: ultima == null
                        ? Colors.black
                        : estadoActual(ultima) == "ALERTA"
                            ? Colors.red
                            : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            Card(
              child: ListTile(
                leading: const Icon(Icons.access_time),
                title: const Text("Último registro"),
                subtitle: Text(
                  ultima == null
                      ? "No disponible"
                      : "${ultima.fecha.day}/${ultima.fecha.month}/${ultima.fecha.year}",
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/measurements');
                },
                icon: const Icon(Icons.add),
                label: const Text("Nueva medición"),
              ),
            ),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/history');
                },
                icon: const Icon(Icons.history),
                label: const Text("Ver historial"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}