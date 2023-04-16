import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:pescarlos2023/plantilla_detalle.dart';

class Plantilla extends StatelessWidget {
  const Plantilla({super.key});

  @override
  Widget build(BuildContext context) {
    return PlantillaVista();
  }
}

class PlantillaVista extends StatefulWidget {
  @override
  PlantillaCodigo createState() => PlantillaCodigo();
}

class PlantillaCodigo extends State<PlantillaVista> {
  List jugadores = [];
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  String filtroSql = '';
  bool _mostrarTextField = false;
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchJugadores(filtroSql);
  }

  fetchJugadores(filtro) async {
    jugadores = [];
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'bmf1sdr6ryocueuwseac-mysql.services.clever-cloud.com',
      port: 3306,
      user: 'ucesmv3v36abceb8',
      password: 'd2qopoXBFGrHt7Y955Ck',
      db: 'bmf1sdr6ryocueuwseac',
    ));

    final ListaJugadores;

    if (filtro.isEmpty) {
      print('prueba2');
      ListaJugadores = await conn.query(
          'SELECT j.nombre, j.apellidos, j.dorsal, (SELECT sum(p.goles) FROM detalleJugadores p where j.dorsal = p.dorsal) as goles, (SELECT sum(p.asistencias) FROM detalleJugadores p where j.dorsal = p.dorsal) as asistencias, (SELECT AVG(p.valoracion) FROM detalleJugadores p where j.dorsal = p.dorsal) as valoracion From jugadores j order by dorsal');
    } else {
      print('prueba3');
      ListaJugadores = await conn.query(
          'SELECT j.nombre, j.apellidos, j.dorsal, (SELECT sum(p.goles) FROM detalleJugadores p where j.dorsal = p.dorsal) as goles, (SELECT sum(p.asistencias) FROM detalleJugadores p where j.dorsal = p.dorsal) as asistencias, (SELECT AVG(p.valoracion) FROM detalleJugadores p where j.dorsal = p.dorsal) as valoracion From jugadores j where j.nombre like "%' +
              filtro +
              '%"');
    }

    setState(() {
      jugadores = ListaJugadores.map((r) => r.fields).toList();
    });

    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas de los Jugadores'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              setState(() {
                if (_mostrarTextField == false) {
                  _mostrarTextField = true;
                  fetchJugadores(_textEditingController.text);
                } else {
                  _mostrarTextField = false;
                  _textEditingController.text = '';
                  fetchJugadores(_textEditingController.text);
                }
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (_mostrarTextField ==
              true) // Mostrar el TextField si _mostrarTextField es true
            TextField(
              controller: _textEditingController,
              maxLines: 1,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                hintText: 'Buscar ...',
                hintStyle: TextStyle(color: Colors.grey),
                prefixIcon: Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _textEditingController.text = '';
                    fetchJugadores(_textEditingController.text);
                  },
                ),
              ),
              onChanged: (value) {
                fetchJugadores(_textEditingController.text);
              },
            ),
          Expanded(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: jugadores.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(
                      color: Colors.blue,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          //builder: (context) => MyApp(myNumber: index + 1),
                          builder: (context) =>
                              Plantilla_Detalle(jugadores[index]['dorsal']),
                        ),
                      );
                    },
                    leading: CircleAvatar(
                        radius: 28,
                        backgroundImage: AssetImage('assets/' +
                            jugadores[index]['nombre'] +
                            jugadores[index]['dorsal']
                                .toString()
                                .replaceAll(regex, '0') +
                            '.PNG')),
                    title: Text(jugadores[index]['nombre'] +
                        ' ' +
                        jugadores[index]['apellidos']),
                    isThreeLine: true,
                    subtitle: Text('Dorsal: ' +
                        jugadores[index]['dorsal']
                            .toString()
                            .replaceAll(regex, '0') +
                        '\n' +
                        'Goles: ' +
                        jugadores[index]['goles']
                            .toString()
                            .replaceAll(regex, '') +
                        '\t' +
                        '\t' +
                        '\t' +
                        'Asistencias: ' +
                        jugadores[index]['asistencias']
                            .toString()
                            .replaceAll(regex, '') +
                        '\n' +
                        'Valoración: ' +
                        jugadores[index]['valoracion'].toString()),
                    trailing: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.navigate_next, size: 50),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
