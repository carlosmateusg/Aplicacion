# Gas monitor APP 

## Getting Started

Esta apliación la hago como un modelo de prueba para la medición de gases en mineria subterranea, la 
principal motivación para hacerla es que soy ingeniero de minas y tengo varios años de experiencia en este tema y he evidenciado que es necesario realiar por ley, la medicion de gases periodica y tenerla 
guardada en datos fisicos. No obstante, con la actualización de todo, veo que puede ser una gran posibilidad para el día de mañana utilizar una apliación que no necesite una conexión estable a internet, pero si pueda subir los datos en tiempo real, dejando constancia de todo o que se este realizando.

##Funcionalidades
- Un inicio de sesión sencillo, donde se piden credenciales y son ADMIN 1234
- Un registro de mediciones, donde se van a registrar las medidas en tiempo real y tiene un juego de colores según se encuentren en el rango permisible o no 
- Historial completo de todas las mediciones que se han hecho.
- Elimiancion de registros: eliminar un registro en caso de que se hayan diligenciado de una forma incorrecta. 
-Panel de control o dashboard: En este panel de control, encontramos el total mediciones, si se encuentrar aletras detectadas según el diligenciamiento de los datos que se dieron, a continuación esto se encuentra según el estado actual que nos arroja un seguro o en otro caso una alerta en color rojo. 
- Geolocalización GPS: Una geolocalización en tiempo real para el momento donde se realiza una lectura. 
- Persistencia local con hive: se almacenan datos en una nube provisional para que los datos queden almacenados. 

##Arquitectura
UI (Screens)
│
├── HomeScreen
├── LoginScreen
├── MeasurementScreen
├── HistoryScreen
└── DashboardScreen

Routes
│
└── app_routes.dart

Models
│
└── measurement.dart

Database
│
└── Hive Local Storage