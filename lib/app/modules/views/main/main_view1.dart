import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:webview_flutter/webview_flutter.dart';

class MainView1 extends GetView {
  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) WebView.platform = AndroidWebView();
    return Scaffold(
        body: SafeArea(
      child: WebView(
        initialUrl: 'https://upbit.com/trends',
      ),
    ));
  }
}
