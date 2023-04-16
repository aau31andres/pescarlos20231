import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:pescarlos2023/plantilla_detalle.dart';

void main() {
  runApp(Equipo());
}

class Equipo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Equipo',
      home: EquipoVista(),
    );
  }
}

class EquipoVista extends StatefulWidget {
  @override
  EquipoCodigo createState() => EquipoCodigo();
}

class EquipoCodigo extends State<EquipoVista> {
  List partidos = [];
  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');

  @override
  void initState() {
    super.initState();
    _getDataFromMySQL();
  }

  _getDataFromMySQL() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'bmf1sdr6ryocueuwseac-mysql.services.clever-cloud.com',
      port: 3306,
      user: 'ucesmv3v36abceb8',
      password: 'd2qopoXBFGrHt7Y955Ck',
      db: 'bmf1sdr6ryocueuwseac',
    ));

    final ListaPartidos = await conn.query(
        'SELECT p.jornada, p.rival, p.local_visitante, p.goles_rival, p.goles_equipo FROM partidos p');

    setState(() {
      partidos = ListaPartidos.map((r) => r.fields).toList();
    });

    await conn.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas del Equipo'),
      ),
      body: ListView.builder(
        shrinkWrap: true,
        itemCount: partidos.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
                radius: 28, backgroundImage: AssetImage('assets/' + partidos[index]['local_visitante'])),
            title: Text('\n' +
                'Pescarlos FC' + ' VS ' + partidos[index]['rival']),
            isThreeLine: true,
            subtitle: Text('Resultado:  ' + partidos[index]['goles_equipo'].toString().replaceAll(regex, '0') + '  -  ' + partidos[index]['goles_rival'].toString().replaceAll(regex, '0')
            ),
            trailing: const Icon(Icons.arrow_forward),
          );
        },
      ),
    );
  }
}
