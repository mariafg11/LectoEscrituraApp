import 'dart:developer';
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
  List<List<_Data>> createList() {
    List<Progress> p = [];
    int i = 0;

    for (var item in widget.games) {
      for (var it in widget.progress) {
        if (item.uid == it.gameId) {
          p.add(it);
        }
      }
    }
    List<List<_Data>> result = [];

    for (var item in p) {
      List<_Data> l = [];
      for (var it in item.wrong) {
        _Data d = _Data(index: (i + 1), wrong: item.wrong.elementAt(i));
        l.add(d);
        i++;
      }

      result.add(l);
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    final List<List<_Data>> list = createList();
    return Scaffold(
        appBar: AppBar(
          title: Text("Area de Padres"),
        ),
        body: Column(children: [
          //Initialize the chart widget
          SfCartesianChart(
            title: ChartTitle(
                text: 'Errores cometidos en ' + widget.games.first.title),
            series: <ChartSeries<_Data, int>>[
              ColumnSeries(
                  dataSource: list.first,
                  xValueMapper: (_Data p, _) => p.index,
                  yValueMapper: (_Data p, _) => p.wrong,
                  name: 'Progreso')
            ],
          ),
        ]));
  }
}

class _Data {
  final int index;
  final int wrong;
  _Data({this.index, this.wrong});
}
