import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

/*
 업비트 요청은 크게 [{ticket field}, {type field}, {format field}] 
*/
class UpbitChartController extends GetxController
    // ignore: deprecated_member_use
    with
        GetSingleTickerProviderStateMixin {
  final GlobalKey scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    print("dispose!!!!!! ");

    super.dispose();
  }
}
