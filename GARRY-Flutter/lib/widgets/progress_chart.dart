import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';

///
/// The line graph widget used to show users their progress throughout a session 
/// relative to the goal value.
///
class ProgressChart extends StatelessWidget {
  final double height;
  final List<FlSpot> dataPoints;
  final List<Color> colors;
  final List<FlSpot> thresholdLine;

  ProgressChart({
    this.height,
    this.dataPoints,
    this.colors,
    this.thresholdLine,
  });

  @override
  Widget build(BuildContext context) {
    // Width of the background takes up 90% of the screen space at all times
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = 0.90 * screenWidth;

    // determines what the largest data point (in terms of y) is in the list as it gets streamed in
    double largestY = dataPoints.reduce(
      (value, element) => value.y > element.y ? value : element
    ).y;

    return Container(
      height: height,
      width: containerWidth,
      child: LineChart(LineChartData(
          minX: 0,
          maxX: this.dataPoints.length * 1.0, //iA2Data.length,
          minY: this.height / 2, // Controls where the top of the plot is, roughly
          maxY: largestY, // Controls where the bottom of the plot is, this is variable so it always encompasses the height of the data
          backgroundColor: CupertinoColors.white, // deals with the background color inside the graph
          clipData: FlClipData.all(),
          axisTitleData: FlAxisTitleData(show: false),
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            show: false,
          ),
          lineBarsData: [
            LineChartBarData(
              spots: this.dataPoints,
              isCurved: true,
              colors: [
                const Color(0xff23b6e6),
                CupertinoColors.systemRed,
              ],
              barWidth: 1,
              dotData: FlDotData(show: false), //turns off the point (dots) at each coordinate (makes it easier to see the line/trend)
            ),
            LineChartBarData(
              spots: this.thresholdLine,
              colors: [CupertinoColors.systemRed],
              barWidth: 1,
              dotData: FlDotData(show: false),
              dashArray: [5, 5],
            )
          ])),
      // Implement the chart visualization using the provided data
      // You can use Flutter's built-in widgets like CustomPaint, Container, or third-party chart libraries
    );
  }
}