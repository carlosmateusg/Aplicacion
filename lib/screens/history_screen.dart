// history_screen.dart
// Pantalla historial mejorada
// Ahora muestra TODAS las mediciones registradas:
// O2, CH4, CO2, CO, NO2, H2S, observación, fecha y estado

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import '../models/measurement.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Box<Measurement> box;

  @override
  void initState() {
    super.initState();
    box = Hive.box<Measurement>('mediciones');
  }

  // -------------------------------------
  // Formato fecha
  // -------------------------------------
  String formatearFecha(DateTime f) {
    return "${f.day}/${f.month}/${f.year} "
        "${f.hour}:${f.minute.toString().padLeft(2, '0')}";
  }

  // -------------------------------------
  // Estado general
  // -------------------------------------
  Color getEstado(Measurement m) {
    if (m.monoxido > 25) return Colors.red;
    if (m.co2 > 5000) return Colors.red;
    if (m.sulfuricos > 1) return Colors.red;
    if (m.nitrosos > 0.5) return Colors.red;
    if (m.metano > 5) return Colors.red;
    if (m.oxigeno < 19.5 || m.oxigeno > 23.5) {
      return Colors.red;
    }

    return Colors.green;
  }

  // -------------------------------------
  // Confirmar eliminación
  // -------------------------------------
  void confirmarEliminar(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Eliminar registro"),
        content: const Text(
          "¿Desea eliminar esta medición?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),

          ElevatedButton(
            onPressed: () {
              box.deleteAt(index);

              setState(() {});

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("Registro eliminado"),
                ),
              );
            },
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }

  // -------------------------------------
  // Tarjeta visual completa
  // -------------------------------------
  Widget tarjetaMedicion(
      Measurement m,
      int index,
  ) {
    final color = getEstado(m);

    return Card(
      margin: const EdgeInsets.symmetric(
        vertical: 8,
      ),

      child: Padding(
        padding: const EdgeInsets.all(14),

        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [

            // Encabezado
            Row(
              children: [
                CircleAvatar(
                  radius: 8,
                  backgroundColor: color,
                ),

                const SizedBox(width: 10),

                Expanded(
                  child: Text(
                    formatearFecha(m.fecha),
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ),

                IconButton(
                  onPressed: () {
                    confirmarEliminar(index);
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                ),
              ],
            ),

            const Divider(),

            // Gases fila 1
            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Text("O2: ${m.oxigeno}%"),
                Text("CH4: ${m.metano}%"),
              ],
            ),

            const SizedBox(height: 6),

            // Gases fila 2
            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Text("CO2: ${m.co2} ppm"),
                Text("CO: ${m.monoxido} ppm"),
              ],
            ),

            const SizedBox(height: 6),

            // Gases fila 3
            Row(
              mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,
              children: [
                Text("NO2: ${m.nitrosos} ppm"),
                Text("H2S: ${m.sulfuricos} ppm"),
              ],
            ),

            const SizedBox(height: 10),

            // Observación
            Text(
              "Observación:",
              style: TextStyle(
                fontWeight:
                    FontWeight.bold,
                color: Colors.grey[700],
              ),
            ),

            const SizedBox(height: 4),

            Text(
              m.observacion.isEmpty
                  ? "Sin observaciones"
                  : m.observacion,
            ),

            const SizedBox(height: 8),

            // Ubicación
            Text(
              "Lat: ${m.latitud.toStringAsFixed(5)}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),

            Text(
              "Lng: ${m.longitud.toStringAsFixed(5)}",
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------
  // UI principal
  // -------------------------------------
  @override
  Widget build(BuildContext context) {
    final lista = box.values.toList()
      ..sort(
        (a, b) =>
            b.fecha.compareTo(a.fecha),
      );

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Historial Completo",
        ),
      ),

      body: lista.isEmpty
          ? const Center(
              child: Text(
                "No hay mediciones registradas",
              ),
            )
          : ListView.builder(
              padding:
                  const EdgeInsets.all(12),

              itemCount: lista.length,

              itemBuilder:
                  (context, index) {
                final m = lista[index];

                return tarjetaMedicion(
                  m,
                  index,
                );
              },
            ),
    );
  }
}