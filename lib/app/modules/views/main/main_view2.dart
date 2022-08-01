import 'package:bitsumb2/app/utils/Utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class MainView2 extends GetView {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Center(
                child: Column(
      children: [
        Text("0.01 : ${Utils.getMoneyformat(0.01)}"),
        Text("0.001 : ${Utils.getMoneyformat(0.001)}"),
        Text("0.0001 : ${Utils.getMoneyformat(0.0101)}"),
        Text("0.00001 : ${Utils.getMoneyformat(0.00101)}"),
        Text("0.000001 : ${Utils.getMoneyformat(0.0001001)}"),
        Text("0.0000001 : ${Utils.getMoneyformat(0.0000001)}"),
        Text("0.00000001 : ${Utils.getMoneyformat(0.00000001)}"),
      ],
    ))));
  }
}
