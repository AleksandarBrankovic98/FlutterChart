import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RadarChartSample extends StatefulWidget {
  @override
  _RadarChartSampleState createState() => _RadarChartSampleState();
}

class _RadarChartSampleState extends State<RadarChartSample> {
  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.3,
      child: Card(
        color: Colors.white,
        child: RadarChart(
          RadarChartData(
            titleCount: 3,
            fillColor: Colors.grey,
            dataSets: showingDataSets(),
            tickCount: 4,
            getTitle: (index) => '$index + values',
          ),
        ),
      ),
    );
  }

  List<RadarDataSet> showingDataSets() {
    return [
      RadarDataSet(
        dataEntries: [
          RadarEntry(value: 5),
          RadarEntry(value: 1),
          RadarEntry(value: 25),
        ],
        strokeWidth: 3,
        color: Colors.red,
      ),
      RadarDataSet(
        dataEntries: [
          RadarEntry(value: 18),
          RadarEntry(value: 20),
          RadarEntry(value: 30),
        ],
        strokeWidth: 3,
        color: Colors.orange,
      ),
    ];
  }
}
