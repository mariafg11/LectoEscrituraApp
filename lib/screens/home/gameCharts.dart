import 'dart:ui';
import 'package:LectoEscrituraApp/models/game.dart';
import 'package:LectoEscrituraApp/models/progress.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GameCharts extends StatefulWidget {
  final List<Game> games;
  final List<Progress> progress;

  const GameCharts({Key key, this.games, this.progress}) : super(key: key);

  @override
  _GameChartsState createState() => _GameChartsState();
}

class _GameChartsState extends State<GameCharts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Area de Padres"),
          backgroundColor: Colors.red[400],
        ),
        body: Column(children: [
          //Initialize the chart widget
          SfCartesianChart(
            title: ChartTitle(text: 'Progreso de ' + widget.games.first.title),
            series: <ChartSeries<Progress, int>>[
              ColumnSeries(
                  dataSource: widget.progress,
                  xValueMapper: (Progress p, _) => p.score.length,
                  yValueMapper: (Progress p, _) => p.score.first,
                  name: 'Progreso')
            ],
          ),
        ]));
  }
}
