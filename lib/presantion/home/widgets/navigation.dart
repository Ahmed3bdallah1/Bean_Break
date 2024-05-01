import 'package:bath_room_app/core/colors/colours.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/controllers/home/home_controller.dart';

class NavigationBarConfig extends StatefulWidget {
  const NavigationBarConfig({super.key});

  @override
  State<NavigationBarConfig> createState() => _NavigationBarConfigState();
}

class _NavigationBarConfigState extends State<NavigationBarConfig> {
  @override
  Widget build(BuildContext context) {
    return Consumer<HomeController>(
      builder: (context, controller, _) {
        return Scaffold(
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
        );
      },
    );
  }
}
