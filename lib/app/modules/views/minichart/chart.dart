import 'package:bitsumb2/app/utils/Utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

LineChartData chart(
  bool isHomePage,
  List<FlSpot> spots,
  double minY,
  double maxY,
  bool profit,
) {
  // 상승
  List<Color> redColors = [Utils.upbgcolor, Utils.upbgcolor2, Colors.white];
  //하락
  List<Color> blueColors = [
    Utils.downbgcolor,
    Utils.downbgcolor2,
    Colors.white
  ];

  return LineChartData(
    borderData: FlBorderData(show: false),
    backgroundColor: Colors.white,
    gridData: FlGridData(
      show: !isHomePage,
      drawVerticalLine: !isHomePage,
      drawHorizontalLine: true,
      verticalInterval: 1,
      getDrawingHorizontalLine: (value) {
        return FlLine(
          color: const Color(0xff37434d),
          strokeWidth: 1,
        );
      },
      getDrawingVerticalLine: (value) {
        return FlLine(
          // color: const Color(0xff37434d),
          color: Color.fromARGB(255, 252, 252, 252),
          strokeWidth: 1,
        );
      },
    ),
    titlesData: FlTitlesData(show: false),
    lineTouchData: LineTouchData(
      touchTooltipData: LineTouchTooltipData(
        tooltipBgColor: Colors.black,
        getTooltipItems: (List<LineBarSpot> touchedBarSpots) {
          return touchedBarSpots.map((barSpot) {
            final flSpot = barSpot;
            return LineTooltipItem(
              flSpot.y
                  .toStringAsFixed(2)
                  .replaceFirst('.', ',')
                  .replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), '.'),
              GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 12.sp,
                letterSpacing: 0.5,
              ),
            );
          }).toList();
        },
      ),
    ),
    minX: 0,
    maxX: 96,
    minY: minY,
    maxY: maxY,
    lineBarsData: [
      LineChartBarData(
        spots: spots,
        isCurved: true,
        color: profit
            ? Color.fromARGB(255, 183, 0, 0).withOpacity(0.3)
            : Color.fromARGB(255, 18, 0, 210).withOpacity(0.2),
        barWidth: 1,
        isStrokeCapRound: true,
        dotData: FlDotData(
          show: false,
        ),
        belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: profit
                  ? redColors.map((color) => color.withOpacity(0.3)).toList()
                  : blueColors.map((color) => color.withOpacity(0.7)).toList(),
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            )
            // colors: profit
            //     ? greenColors.map((color) => color.withOpacity(0.3)).toList()
            //     : redColors.map((color) => color.withOpacity(0.3)).toList(),
            ),
      ),
    ],
  );
}
