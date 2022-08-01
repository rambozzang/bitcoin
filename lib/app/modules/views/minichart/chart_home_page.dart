import 'package:bitsumb2/app/modules/views/minichart/chart.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:sizer/sizer.dart';
import 'package:unicons/unicons.dart';

Padding chartHomePage(
  bool isHomePage,
  IconData cryptoIcon,
  String crypto,
  String cryptoCode,
  String exchangeCurrency,
  List<FlSpot> spots,
  ThemeData? themeData,
  double yesterdayPrice,
) {
  if (spots.length == 0) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: SizedBox.shrink(),
    );
  }

  Rx<double> minY = 0.0.obs;
  Rx<double> maxY = 0.0.obs;
  List sortedSpots = spots.toList();
  sortedSpots.sort((a, b) => a.y.compareTo(b.y));
  minY.value = sortedSpots.first.y;
  maxY.value = sortedSpots.last.y;
  // double profitPercent =
  //     ((spots.last.y - spots[spots.length - 2].y) / spots[spots.length - 2].y) *
  //         100;

  //전일 종가랑 비교해야 하지만 종가가 없으므로 first.y 시초가랑 비교해서 제일마지막값이 몇% 인지 계산.
  //전일 종가르 알고있어도 원화여서 btc로 계산해서 %을 계산해야 하는 어려움이 있음.
  // double profitPercent = ((spots.last.y - spots.first.y) / spots.first.y) * 100;
  double profitPercent =
      ((spots.last.y - yesterdayPrice) / yesterdayPrice) * 100;

  return Padding(
    padding: const EdgeInsets.all(0.0),
    child: Center(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
        ),
        child: Column(
          children: [
            SizedBox(
              width: 40.w,
              height: 5.h,
              child: Obx(
                () => LineChart(chart(isHomePage, spots, minY.value, maxY.value,
                    profitPercent >= 0)),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Container profitPercentageWidget(double profitPercent) {
  return Container(
    decoration: BoxDecoration(
      color: profitPercent >= 0 ? Colors.green[600] : Colors.red[600],
      borderRadius: BorderRadius.circular(20),
    ),
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.5.h),
      child: Row(
        children: [
          Text(
            '(${profitPercent.toStringAsFixed(2).replaceFirst('.', ',')}%)',
            style: GoogleFonts.poppins(
              color: Colors.white,
              letterSpacing: 0.5,
              fontWeight: FontWeight.bold,
              fontSize: 10.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Icon(
            profitPercent >= 0
                ? UniconsLine.arrow_growth
                : UniconsLine.chart_down,
            color: Colors.white,
            size: 18.sp,
          ),
        ],
      ),
    ),
  );
}
