import 'dart:developer';

import 'package:LectoEscrituraApp/models/nGames.dart';
import 'package:LectoEscrituraApp/models/progress.dart';
import 'package:LectoEscrituraApp/models/userCustom.dart';
import 'package:LectoEscrituraApp/screens/home/gameCharts.dart';
import 'package:LectoEscrituraApp/services/database.dart';
import 'package:LectoEscrituraApp/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ParentsArea extends StatefulWidget {
  const ParentsArea({Key key}) : super(key: key);

  @override
  _ParentsAreaState createState() => _ParentsAreaState();
}

class _ParentsAreaState extends State<ParentsArea> {
  List<Progress> progress;
  Future<List<NGames>> nGames;
  List<NGames> data = [];
  @override
  Future<List<NGames>> waitFromBd() async {
    final user = Provider.of<UserCustom>(context);
    DatabaseService db = DatabaseService(uid: user.uid);
    progress = await db.getProgress();

    return db.ntipeGames();
  }

  Widget build(BuildContext context) {
    return FutureBuilder<List<NGames>>(
      future: waitFromBd(),
      builder: (BuildContext context, AsyncSnapshot<List<NGames>> snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.hasData && !snapshot.data.isNotEmpty) {
          return Text("Document does not exist");
        }
        if (snapshot.connectionState == ConnectionState.done) {
          data = snapshot.data;

          return Scaffold(
              appBar: AppBar(
                title: Text("Area de Padres"),
              ),
              body: Column(children: [
                //Initialize the chart widget
                SfCircularChart(

                    // Chart title
                    title: ChartTitle(text: 'Progreso por tipo de juego'),
                    // Enable legend
                    legend: Legend(
                        isVisible: true,
                        orientation: LegendItemOrientation.vertical,
                        position: LegendPosition.bottom,
                        overflowMode: LegendItemOverflowMode.wrap),
                    // Enable tooltip
                    tooltipBehavior: TooltipBehavior(enable: true),
                    series: <CircularSeries<NGames, String>>[
                      RadialBarSeries<NGames, String>(
                          dataSource: data,
                          xValueMapper: (NGames tipeProgress, _) =>
                              tipeProgress.tipeGame,
                          yValueMapper: (NGames tipeProgress, _) =>
                              tipeProgress.nTipeGames,
                          name: 'Progreso',
                          maximumValue: 10,
                          innerRadius: '10',
                          radius: '80',
                          onPointTap: (pointInteractionDetails) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => GameCharts(
                                          games: data
                                              .elementAt(pointInteractionDetails
                                                  .pointIndex)
                                              .games,
                                          progress: progress,
                                        )));
                          },
                          // Enable data label
                          dataLabelSettings:
                              DataLabelSettings(isVisible: true)),
                    ]),
              ]));
        }

        return Loading();
      },
    );
  }
}
