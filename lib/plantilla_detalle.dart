import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'package:pescarlos2023/insertaPlantillaDetalle.dart';

class Plantilla_Detalle extends StatefulWidget {
  final int dorsal;

  Plantilla_Detalle(this.dorsal);

  @override
  Plantilla_DetalleVista createState() => Plantilla_DetalleVista();
}

class Plantilla_DetalleVista extends State<Plantilla_Detalle> {
  List<Map<String, dynamic>> partidos = [];

  Future<void> fetchData() async {
    final conn = await MySqlConnection.connect(ConnectionSettings(
      host: 'bmf1sdr6ryocueuwseac-mysql.services.clever-cloud.com',
      port: 3306,
      user: 'ucesmv3v36abceb8',
      password: 'd2qopoXBFGrHt7Y955Ck',
      db: 'bmf1sdr6ryocueuwseac',
    ));

    final results = await conn.query(
        'Select p.jornada,p.rival, d.goles, d.asistencias, d.valoracion from partidos p JOIN detalleJugadores d on p.jornada = d.jornada where d.dorsal = ${widget.dorsal}');

    setState(() {
      partidos = results.map((row) => row.fields).toList();
    });

    await conn.close();
  }

  Color recuperoColor(double value) {
    if (value >= 6) {
      return Colors.green;
    } else if (value >= 5.0 && value <= 5.9) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    final passwordController =
        TextEditingController(); // Controlador para el TextField
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text('Tabla de datos'),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Ingrese la contraseña'),
                      content: TextField(
                        controller: passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Contraseña',
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Aceptar'),
                          onPressed: () {

                            if (passwordController.text == 'hola') {
                              Navigator.of(context).pop();
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => InsertaPlantillaDetalle(widget.dorsal)),

                              );
                            } else {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Contraseña incorrecta'),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    );
                  },
                );
              },
              icon: Icon(Icons.add_box),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: DataTable(
            columnSpacing: 15,
            headingRowHeight: 50,
            horizontalMargin: 20,
            dataRowHeight: 50,
            columns: [
              DataColumn(label: Text('Jornada')),
              DataColumn(label: Text('Rival')),
              DataColumn(label: Text('Goles')),
              DataColumn(label: Text('Asist.')),
              DataColumn(label: Text('Valoración')),
            ],
            rows: partidos
                .map(
                  (row) => DataRow(cells: [
                    DataCell(Text(row['jornada'].toString())),
                    DataCell(Text(row['rival'].toString())),
                    DataCell(Text(row['goles'].toString())),
                    DataCell(Text(row['asistencias'].toString())),
                    DataCell(Text(row['valoracion'].toString(),
                        style: TextStyle(
                            color: recuperoColor(row['valoracion']),
                            fontWeight: FontWeight.w900))),
                  ]),
                )
                .toList(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: fetchData,
          tooltip: 'Actualizar datos',
          child: Icon(Icons.refresh),
        ),
      ),
    );
  }
}
