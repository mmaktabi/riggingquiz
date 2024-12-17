/*import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:quezzy/utils/chart_series.dart';

class DeveloperChart extends StatelessWidget {
  final List<ChartSeries> data;

  const DeveloperChart({super.key, @required required this.data});
  @override
  Widget build(BuildContext context) {
    List<charts.Series<ChartSeries, String>> series = [
      charts.Series(
        id: "quiz",
        data: data,
        domainFn: (ChartSeries series, _) => series.year!,
        measureFn: (ChartSeries series, _) => series.developers,
        colorFn: (ChartSeries series, _) => series.barColor!,
      ),
    ];

    return charts.BarChart(
      series,
      animate: true,
      defaultRenderer: charts.BarRendererConfig(
          cornerStrategy: const charts.ConstCornerStrategy(8)),
      primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.GridlineRendererSpec(
        labelStyle: charts.TextStyleSpec(
            fontSize: 10,
            color: charts.ColorUtil.fromDartColor(
                Colors.white)), //chnage white color as per your requirement.
      )),
      domainAxis: charts.OrdinalAxisSpec(
          renderSpec: charts.SmallTickRendererSpec(
        labelStyle: charts.TextStyleSpec(
            fontSize: 10,
            color: charts.ColorUtil.fromDartColor(
                Colors.white)), //chnage white color as per your requirement.
      )),
    );
  }
}
*/
