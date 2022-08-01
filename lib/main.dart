import 'package:bitsumb2/app/modules/controllers/LifeCycle_controller.dart';
import 'package:bitsumb2/app/modules/controllers/root_controller.dart';
import 'package:bitsumb2/app/modules/views/root.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import 'app/routes/app_pages.dart';

void main() {
  runApp(
    Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        title: "Application",
        debugShowCheckedModeBanner: false,

        // theme: ThemeData.,
        // initialRoute: AppPages.INITIAL,
        initialBinding: BindingsBuilder(() {
          Get.put(RootController());
          Get.put(LifeCycleController());
        }),
        getPages: AppPages.routes,
        defaultTransition: Transition.fade,
        home: Root(),
        //    getPages: [GetPage(name: '/detailPage', page: () => MainView2())],
      );
    }),
  );
}
