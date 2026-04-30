// measurement_screen.dart
// Diseño mejorado:
// - Campos de gases en 2 columnas
// - Más orden visual
// - Observaciones en caja amplia
// - Conserva GPS + Hive + historial

import 'package:flutter/material.dart';
import 'package:hive_ce/hive.dart';
import 'package:geolocator/geolocator.dart';

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

  @override
  void dispose() {
    ox.dispose();
    me.dispose();
    co2.dispose();
    ni.dispose();
    mo.dispose();
    su.dispose();
    obs.dispose();
    super.dispose();
  }

  // ------------------------------------------------
  // GPS
  // ------------------------------------------------
  Future<Position> obtenerUbicacion() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled =
        await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      throw Exception("Ubicación desactivada");
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission =
          await Geolocator.requestPermission();
    }

    if (permission ==
        LocationPermission.deniedForever) {
      throw Exception("Permiso denegado");
    }

    return await Geolocator.getCurrentPosition();
  }

  // ------------------------------------------------
  // Guardar medición
  // ------------------------------------------------
  void agregar() async {
    try {
      final pos = await obtenerUbicacion();

      final m = Measurement(
        oxigeno: double.parse(ox.text),
        metano: double.parse(me.text),
        co2: double.parse(co2.text),
        nitrosos: double.parse(ni.text),
        monoxido: double.parse(mo.text),
        sulfuricos: double.parse(su.text),
        observacion: obs.text,
        fecha: DateTime.now(),
        latitud: pos.latitude,
        longitud: pos.longitude,
      );

      box.add(m);

      setState(() {});

      limpiar();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Medición registrada"),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error en datos"),
        ),
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

  // ------------------------------------------------
  // Diseño inputs
  // ------------------------------------------------
  InputDecoration campo(
      String titulo,
      String rango,
      IconData icono) {
    return InputDecoration(
      labelText: titulo,
      helperText: rango,
      prefixIcon: Icon(icono),
      border: OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(12),
      ),
    );
  }

  // ------------------------------------------------
  // Caja individual para grid
  // ------------------------------------------------
  Widget cajaGas(
    TextEditingController controller,
    String titulo,
    String rango,
    IconData icono,
  ) {
    return TextField(
      controller: controller,
      keyboardType:
          const TextInputType.numberWithOptions(
        decimal: true,
      ),
      decoration: campo(
        titulo,
        rango,
        icono,
      ),
    );
  }

  // ------------------------------------------------
  // UI
  // ------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrar Medición"),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(16),

          child: Column(
            children: [

              // --------------------------
              // GRID DE GASES
              // --------------------------
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                physics:
                    const NeverScrollableScrollPhysics(),

                children: [

                  cajaGas(
                    ox,
                    "O2",
                    "19.5 - 23.5 %",
                    Icons.air,
                  ),

                  cajaGas(
                    me,
                    "CH4",
                    "0 - 5 %",
                    Icons.local_fire_department,
                  ),

                  cajaGas(
                    co2,
                    "CO2",
                    "0 - 5000 ppm",
                    Icons.cloud,
                  ),

                  cajaGas(
                    mo,
                    "CO",
                    "0 - 25 ppm",
                    Icons.warning,
                  ),

                  cajaGas(
                    ni,
                    "NO2",
                    "0 - 0.5 ppm",
                    Icons.science,
                  ),

                  cajaGas(
                    su,
                    "H2S",
                    "0 - 1 ppm",
                    Icons.biotech,
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // --------------------------
              // OBSERVACIONES
              // --------------------------
              TextField(
                controller: obs,
                maxLines: 3,
                decoration:
                    InputDecoration(
                  labelText:
                      "Observaciones",
                  alignLabelWithHint:
                      true,
                  prefixIcon:
                      const Icon(
                    Icons.notes,
                  ),
                  border:
                      OutlineInputBorder(
                    borderRadius:
                        BorderRadius
                            .circular(
                                12),
                  ),
                ),
              ),

              const SizedBox(height: 22),

              // --------------------------
              // BOTÓN
              // --------------------------
              SizedBox(
                width: double.infinity,
                child:
                    ElevatedButton.icon(
                  onPressed: agregar,
                  icon: const Icon(
                    Icons.save,
                  ),
                  label: const Text(
                    "Registrar",
                  ),
                  style:
                      ElevatedButton
                          .styleFrom(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 14,
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
}