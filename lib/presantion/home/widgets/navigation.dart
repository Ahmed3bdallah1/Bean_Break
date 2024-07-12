import 'package:beak_break/core/colors/colours.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/controllers/home/home_controller.dart';

class NavigationBarConfig extends StatefulWidget {
  const NavigationBarConfig({super.key});

  @override
  State<NavigationBarConfig> createState() => _NavigationBarConfigState();
}

class _NavigationBarConfigState extends State<NavigationBarConfig> {
  DateTime? currentBackPressTime;

  Future<bool> onPop() async {
    var index = HomeController.get(context).currentIndex;
    if (index != 0) {
      HomeController.get(context).changeNavigation(0);
      print(currentBackPressTime);
      return false;
    } else {
      var date = DateTime.now();
      if (currentBackPressTime == null ||
          date.difference(currentBackPressTime!) < const Duration(seconds: 2)) {
        currentBackPressTime = date;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Press back again to exit'),
            backgroundColor: ConstantsColors.navigationColor,
            duration: const Duration(seconds: 2),
          ),
        );
        return false;
      }
      return true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        return WillPopScope(
          onWillPop: onPop,
          child: Scaffold(
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12)),
              child: BottomNavigationBar(
                iconSize: 30,
                showSelectedLabels: false,
                backgroundColor: ConstantsColors.navigationColor,
                // Adjust color
                currentIndex: controller.currentIndex,
                onTap: (int index) {
                  controller.changeNavigation(index);
                },
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.grey,
                items: [
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.home),
                      label: '',
                      backgroundColor: ConstantsColors.navigationColor),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.map_outlined),
                      label: '',
                      backgroundColor: ConstantsColors.navigationColor),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.person),
                      label: '',
                      backgroundColor: ConstantsColors.navigationColor),
                  BottomNavigationBarItem(
                      icon: const Icon(Icons.add),
                      label: '',
                      backgroundColor: ConstantsColors.navigationColor)
                ],
              ),
            ),
            body: Stack(
              children: [
                Positioned.fill(
                  child: IndexedStack(
                    index: controller.currentIndex,
                    children: controller.screens,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
