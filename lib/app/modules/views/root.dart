import 'package:bitsumb2/app/modules/controllers/root_controller.dart';
import 'package:bitsumb2/app/modules/views/main/main_view1.dart';
import 'package:bitsumb2/app/modules/views/main/main_view2.dart';
import 'package:bitsumb2/app/modules/views/main/main_view3.dart';
import 'package:bitsumb2/app/modules/views/main/main_view4.dart';
import 'package:bitsumb2/app/modules/bindings/upbit/UpbitList_Binding.dart';
import 'package:bitsumb2/app/modules/views/upbit/UpbitList_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Root extends GetView<RootController> {
  Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: controller.onWillPop,
      child: Obx(
        () => Scaffold(
          body: IndexedStack(
            index: controller.rootPageIndex.value,
            children: [
              GetNavigator(
                key: controller.navigatorKey,
                pages: [
                  GetPage(
                    name: "/UpbitList",
                    page: () => UpbitListView(),
                    binding: UpbitListBinding(),
                  ),
                ],
              ),
              MainView1(),
              MainView2(),
              MainView3(),
              MainView4(),
            ],
          ),
          bottomNavigationBar: Container(
            height: 55,
            color: Color.fromARGB(255, 7, 77, 135),
            padding: EdgeInsets.only(bottom: 0, top: 0),
            child: BottomNavigationBar(
              currentIndex: controller.rootPageIndex.value,
              showSelectedLabels: true,
              showUnselectedLabels: true,
              backgroundColor: Color.fromARGB(255, 22, 39, 84), //
              iconSize: 20,
              onTap: controller.changeRootPageIndex,
              selectedFontSize: 11,
              unselectedFontSize: 10,
              items: const [
                BottomNavigationBarItem(
                    backgroundColor:
                        Color.fromARGB(255, 22, 39, 84), // Utils.bgcolor,
                    icon: Icon(
                      Icons.home_outlined,
                      color: Colors.white38,
                    ),
                    label: '거래소',
                    activeIcon: Icon(Icons.home, color: Colors.white)),
                BottomNavigationBarItem(
                    backgroundColor: Color.fromARGB(255, 22, 39, 84), //
                    icon: Icon(Icons.equalizer_outlined, color: Colors.white70),
                    label: '코인정보',
                    activeIcon: Icon(Icons.equalizer, color: Colors.white)),
                BottomNavigationBarItem(
                    backgroundColor: Color.fromARGB(255, 22, 39, 84), //
                    icon: Icon(
                      Icons.article_outlined,
                      color: Colors.white,
                    ),
                    label: '투자내역',
                    activeIcon: Icon(Icons.article, color: Colors.white)),
                BottomNavigationBarItem(
                  backgroundColor: Color.fromARGB(255, 22, 39, 84), //
                  icon: Icon(
                    Icons.swap_horiz_outlined,
                    color: Colors.grey,
                  ),
                  label: '입출금',
                  activeIcon: Icon(Icons.swap_horiz, color: Colors.white),
                ),
                BottomNavigationBarItem(
                  backgroundColor: Color.fromARGB(255, 22, 39, 84), //
                  icon: Icon(
                    Icons.person_outlined,
                    color: Colors.grey,
                  ),
                  label: '내정보',
                  activeIcon: Icon(Icons.person, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
