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

    // Abrimos caja Hive
    box = Hive.box<Measurement>('mediciones');
  }

  // -----------------------------------------
  // Formato fecha
  // -----------------------------------------
  String formatearFecha(DateTime f) {
    return "${f.day}/${f.month}/${f.year} "
        "${f.hour}:${f.minute.toString().padLeft(2, '0')}";
  }

  // -----------------------------------------
  // Evalúa estado general
  // -----------------------------------------
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

  // -----------------------------------------
  // Confirmar eliminación
  // -----------------------------------------
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
              // Eliminar registro
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

  // -----------------------------------------
  // UI principal
  // -----------------------------------------
  @override
  Widget build(BuildContext context) {
    final lista = box.values.toList()
      ..sort((a, b) => b.fecha.compareTo(a.fecha));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Historial"),
      ),

      body: SafeArea(
        child: lista.isEmpty
            ? const Center(
                child: Text("No hay mediciones registradas"),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: lista.length,

                itemBuilder: (context, index) {
                  final m = lista[index];
                  final color = getEstado(m);

                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),

                    child: ListTile(
                      // Indicador color estado
                      leading: CircleAvatar(
                        radius: 8,
                        backgroundColor: color,
                      ),

                      // Fecha
                      title: Text(
                        formatearFecha(m.fecha),
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      // Datos rápidos
                      subtitle: Text(
                        "CO: ${m.monoxido} ppm | O2: ${m.oxigeno} %",
                      ),

                      // Botón eliminar
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          confirmarEliminar(index);
                        },
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}