import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';


class InsertaPlantillaDetalle extends StatefulWidget {
  final int dorsal;

  InsertaPlantillaDetalle(this.dorsal);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<InsertaPlantillaDetalle> {
  // controladores de los campos de entrada de datos
  final dorsalControler = TextEditingController();
  final jornadaControler = TextEditingController();
  final golesControler = TextEditingController();
  final asistenciasControler = TextEditingController();
  final valoracionControler = TextEditingController();

  // método para insertar los datos en la base de datos
  Future<void> _insertData() async {
    // establecer la conexión a la base de datos
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'bmf1sdr6ryocueuwseac-mysql.services.clever-cloud.com',
      port: 3306,
      user: 'ucesmv3v36abceb8',
      password: 'd2qopoXBFGrHt7Y955Ck',
      db: 'bmf1sdr6ryocueuwseac',
    ));

    // construir la consulta SQL para insertar los datos
    final result = await conn.query(
        'INSERT INTO detalleJugadores (`dorsal`, `jornada`, `goles`, `asistencias`, `valoracion`) VALUES (?, ?, ?, ?, ?)',
        [
          widget.dorsal,
          double.parse(jornadaControler.text),
          double.parse(golesControler.text),
          double.parse(asistenciasControler.text),
          double.parse(valoracionControler.text)
        ]);

    // cerrar la conexión a la base de datos
    await conn.close();

    // mostrar un mensaje de éxito
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Datos insertados correctamente')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inserta plantilla detalle',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Información de jugadores'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Información general:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Nombre: '),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Edad promedio:'),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Posiciones:'),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Inserción de datos:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: jornadaControler,
                  decoration: InputDecoration(
                    labelText: 'Jornada',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: golesControler,
                  decoration: InputDecoration(
                    labelText: 'Goles',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: asistenciasControler,
                  decoration: InputDecoration(
                    labelText: 'Asistencias',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: valoracionControler,
                  decoration: InputDecoration(
                    labelText: 'Valoración',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                ),
              ),
              SizedBox(height: 16.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton.icon(
                        icon: Icon(Icons.cancel),
                        label: Text('Cancelar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                    SizedBox(width: 16.0),
                    ElevatedButton.icon(
                        icon: Icon(Icons.check),
                        label: Text('Confirmar'),
                        onPressed: () {
                          _insertData();
                          Navigator.of(context).pop();
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
