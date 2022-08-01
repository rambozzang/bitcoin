import 'package:bitsumb2/app/modules/controllers/home_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          body: IndexedStack(
            index: controller.currentIndex.value,
            children: [
              Navigator(
                  key: Get.nestedKey(0),
                  initialRoute: "/",
                  onGenerateRoute: (settings) {
                    if (settings.name == "/")
                      return GetPageRoute(
                        settings: settings,
                        page: () => Text("a"),
                      );
                    else
                      return GetPageRoute(
                        settings: settings,
                        page: () => Text("b"),
                      );
                  }),
            ],
          ),
          extendBodyBehindAppBar: true, // add this line

          bottomNavigationBar: Container(
            color: Color.fromARGB(255, 7, 77, 135),
            child: Container(
              height: 58,
              padding: EdgeInsets.only(bottom: 0, top: 0),
              child: const TabBar(
                //tab 하단 indicator size -> .label = label의 길이
                //tab 하단 indicator size -> .tab = tab의 길이
                indicatorSize: TabBarIndicatorSize.label,
                //tab 하단 indicator color
                indicatorColor: Colors.transparent,
                //tab 하단 indicator weight
                indicatorWeight: 1,
                //label color
                labelColor: Colors.white,
                //unselected label color
                unselectedLabelColor: Colors.grey,
                labelStyle: TextStyle(
                  fontSize: 11,
                ),

                tabs: [
                  Tab(
                    icon: Icon(
                      Icons.home_outlined,
                      size: 18,
                    ),
                    text: '거래소',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.music_note,
                      size: 18,
                    ),
                    text: '코인정보',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.apps,
                      size: 18,
                    ),
                    text: '투자내역',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.settings,
                      size: 18,
                    ),
                    text: '입출금',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.settings,
                    ),
                    text: '내정보',
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
