import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import '../models/measurement.dart';

class MeasurementScreen extends StatefulWidget {
  const MeasurementScreen({super.key});

  @override
  State<MeasurementScreen> createState() => _MeasurementScreenState();
}

class _MeasurementScreenState extends State<MeasurementScreen> {

  late Box<Measurement> box;

  final ox = TextEditingController();
  final me = TextEditingController();
  final co2 = TextEditingController();
  final ni = TextEditingController();
  final mo = TextEditingController();
  final su = TextEditingController();
  final obs = TextEditingController();

  @override
  void initState() {
    super.initState();
    box = Hive.box<Measurement>('mediciones');
  }

  // 🔴 Riesgo global
  Color getColorRiesgoTotal(Measurement m) {
    if (m.monoxido > 25) return Colors.red;
    if (m.co2 > 5000) return Colors.red;
    if (m.sulfuricos > 1) return Colors.red;
    if (m.nitrosos > 0.5) return Colors.red;
    if (m.metano > 5) return Colors.red;
    if (m.oxigeno < 19.5 || m.oxigeno > 23.5) return Colors.red;

    return Colors.green;
  }

  Color getColorGas(String gas, double valor) {
    switch (gas) {
      case "CO":
        return valor > 25 ? Colors.red : Colors.green;
      case "CO2":
        return valor > 5000 ? Colors.red : Colors.green;
      case "H2S":
        return valor > 1 ? Colors.red : Colors.green;
      case "NO2":
        return valor > 0.5 ? Colors.red : Colors.green;
      case "CH4":
        return valor > 5 ? Colors.red : Colors.green;
      case "O2":
        return (valor < 19.5 || valor > 23.5)
            ? Colors.red
            : Colors.green;
      default:
        return Colors.black;
    }
  }

  void agregar() {
    try {
      final m = Measurement(
        oxigeno: double.parse(ox.text),
        metano: double.parse(me.text),
        co2: double.parse(co2.text),
        nitrosos: double.parse(ni.text),
        monoxido: double.parse(mo.text),
        sulfuricos: double.parse(su.text),
        observacion: obs.text,
        fecha: DateTime.now(),
      );

      box.add(m); // 🔹 AQUÍ está el cambio clave

      setState(() {}); // 🔹 refrescar UI

      limpiar();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error en los datos")),
      );
    }
  }

  void limpiar() {
    ox.clear();
    me.clear();
    co2.clear();
    ni.clear();
    mo.clear();
    su.clear();
    obs.clear();
  }

  String formatearFecha(DateTime f) {
    return "${f.day}/${f.month}/${f.year} "
        "${f.hour}:${f.minute.toString().padLeft(2, '0')}";
  }

  InputDecoration campo(String label, String rango) {
    return InputDecoration(
      labelText: label,
      helperText: "Rango: $rango",
    );
  }

  Widget buildCard(Measurement m) {
    final colorGlobal = getColorRiesgoTotal(m);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 6,
            height: 120,
            color: colorGlobal,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    formatearFecha(m.fecha),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 12,
                    children: [
                      Text("O2: ${m.oxigeno}",
                          style: TextStyle(color: getColorGas("O2", m.oxigeno))),
                      Text("CH4: ${m.metano}",
                          style: TextStyle(color: getColorGas("CH4", m.metano))),
                      Text("CO2: ${m.co2}",
                          style: TextStyle(color: getColorGas("CO2", m.co2))),
                      Text("CO: ${m.monoxido}",
                          style: TextStyle(color: getColorGas("CO", m.monoxido))),
                    ],
                  ),

                  const SizedBox(height: 6),

                  Wrap(
                    spacing: 12,
                    children: [
                      Text("NO2: ${m.nitrosos}",
                          style: TextStyle(color: getColorGas("NO2", m.nitrosos))),
                      Text("H2S: ${m.sulfuricos}",
                          style: TextStyle(color: getColorGas("H2S", m.sulfuricos))),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text("Observaciones: ${m.observacion}"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Mediciones")),

      body: Column(
        children: [

          // 🔹 LISTA DESDE HIVE
          Expanded(
            child: box.isEmpty
                ? const Center(child: Text("No hay registros"))
                : ListView.builder(
                    itemCount: box.length,
                    itemBuilder: (context, index) {
                      final m = box.getAt(index)!;
                      return buildCard(m);
                    },
                  ),
          ),

          // 🔹 FORMULARIO
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [

                TextField(controller: ox, decoration: campo("O2", "19.5 - 23.5")),
                TextField(controller: me, decoration: campo("CH4", "0 - 5")),
                TextField(controller: co2, decoration: campo("CO2", "0 - 5000")),
                TextField(controller: mo, decoration: campo("CO", "0 - 25")),
                TextField(controller: ni, decoration: campo("NO2", "0 - 0.5")),
                TextField(controller: su, decoration: campo("H2S", "0 - 1")),
                TextField(controller: obs, decoration: campo("Observaciones", "")),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: agregar,
                  child: const Text("Registrar"),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}