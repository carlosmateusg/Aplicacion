// home_screen.dart
// Pantalla principal de bienvenida del sistema
// Diseño sencillo, limpio y funcional

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar superior
      appBar: AppBar(
        title: const Text("Monitoreo de Gases"),

        // Fondo transparente para que combine con el degradado
        backgroundColor: Colors.transparent,

        // Sin sombra
        elevation: 0,

        // Color texto/iconos
        foregroundColor: Colors.white,
      ),

      // Permite que el fondo llegue detrás del AppBar
      extendBodyBehindAppBar: true,

      // Fondo principal
      body: Container(
        decoration: const BoxDecoration(

          // Fondo degradado vertical
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2C2C2C), // gris oscuro arriba
              Color(0xFFF5F7FA), // gris claro abajo
            ],
          ),
        ),

        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // -------------------------------
                // TÍTULO PRINCIPAL
                // -------------------------------
                const Text(
                  "Bienvenido",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: 10),

                // -------------------------------
                // SUBTÍTULO DESCRIPTIVO
                // -------------------------------
                const Text(
                  "Sistema de registro de gases.\nControl y seguridad en tiempo real.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.white70,
                  ),
                ),

                const SizedBox(height: 40),

                // -------------------------------
                // ICONO CENTRAL
                // -------------------------------
                const Icon(
                  Icons.analytics,
                  size: 80,
                  color: Colors.white,
                ),

                const SizedBox(height: 50),

                // -------------------------------
                // BOTÓN LOGIN
                // -------------------------------
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Ir a pantalla de login
                      Navigator.pushNamed(context, '/login');
                    },

                    icon: const Icon(Icons.login),

                    label: const Text("Ingresar"),

                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // -------------------------------
                // BOTÓN DASHBOARD
                // Nueva pantalla resumen del sistema
                // -------------------------------
                SizedBox(
                  width: double.infinity,

                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/dashboard');
                    },

                    icon: const Icon(Icons.dashboard),

                    label: const Text("Panel de Control"),

                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // -------------------------------
                // BOTÓN HISTORIAL
                // -------------------------------
                SizedBox(
                  width: double.infinity,

                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/history');
                    },

                    icon: const Icon(Icons.history),

                    label: const Text("Ver Historial"),

                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),

                      foregroundColor: Colors.white,

                      side: const BorderSide(
                        color: Colors.white70,
                      ),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}