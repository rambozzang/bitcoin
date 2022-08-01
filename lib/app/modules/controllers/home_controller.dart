import 'package:bitsumb2/app/modules/views/main/main_view1.dart';
import 'package:bitsumb2/app/modules/views/main/main_view2.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitList_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();

  final currentIndex = 0.obs;

  final pages = <Widget>[
    UpbitListView(),
    MainView1(),
    MainView2(),
  ];

  Widget get currentPage => pages[currentIndex()];

  changePage(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {}
}
