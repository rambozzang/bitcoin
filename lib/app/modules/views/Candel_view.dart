import 'package:bitsumb2/app/modules/controllers/Candle_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CandleView extends GetView<CandelController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BTCUSDT 1H Chart"),
      ),
      body: Center(child: Text("a")),
    );
  }
}
