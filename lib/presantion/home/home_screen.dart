import 'package:beak_break/core/colors/colours.dart';
import 'package:beak_break/core/controllers/location/location_controller.dart';
import 'package:beak_break/presantion/home/widgets/ad_mob_container.dart';
import 'package:beak_break/presantion/home/widgets/coffie_container.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/controllers/home/home_controller.dart';
import '../../models/locations_model/location_model.dart';
import '../maps/widgets/location_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    Provider.of<LocationController>(context)
        .getAllLocations(context)
        .then((value) {
      Provider.of<LocationController>(context, listen: false)
          .getAllFavorites(context);
    });
    return Scaffold(
      backgroundColor: ConstantsColors.backgroundColor3,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  Image.asset(
                    "assets/beens.png",
                    height: 150,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Flexible(
                    child: Text(
                      "BeanBreak",
                      style: TextStyle(
                          fontSize: 40,
                          color: ConstantsColors.navigationColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: ConstantsColors.fillColor3,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(12),
                    topLeft: Radius.circular(12),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5),
                              child: Text(
                                "Recently added:",
                                style: TextStyle(
                                    fontSize: 25,
                                    color: ConstantsColors.navigationColor,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Consumer<LocationController>(
                        builder: (context, controller, _) {
                          return ValueListenableBuilder<List<LocationModel>>(
                            valueListenable:
                                LocationController.locationsNotifier,
                            builder: (context, locations, _) {
                              if (locations.isEmpty) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .18,
                                  child: Center(
                                      child: Text(
                                    "There's nothing here",
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: ConstantsColors.navigationColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )),
                                );
                              }
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .18,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.locationsList.length,
                                  separatorBuilder: (context, index) {
                                    return const SizedBox(width: 5);
                                  },
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        final homeController =
                                            Provider.of<HomeController>(context,
                                                listen: false);
                                        homeController
                                            .navigateToMapWithLocation(
                                                locations[index]);

                                        if (homeController.selectedLocation !=
                                            null) {
                                          print(true);
                                          showLocationDetails(
                                            context,
                                            location: homeController
                                                .selectedLocation!,
                                            isCafe: homeController
                                                    .selectedLocation!
                                                    .instantCoffee ??
                                                false,
                                            isBathroom: homeController
                                                    .selectedLocation!
                                                    .alternateOptions ??
                                                false,
                                          );
                                          homeController.selectedLocation =
                                              null;
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          const SizedBox(width: 5),
                                          CoffeeContainer(
                                            locationModel:
                                                controller.locationsList[index],
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const AdMobBanner(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text(
                              "Favorites:",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: ConstantsColors.navigationColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Consumer<LocationController>(
                          builder: (context, controller, _) {
                        return ValueListenableBuilder<List<LocationModel>>(
                          valueListenable:
                              LocationController.myFavoritesNotifier,
                          builder: (context, locations, _) {
                            if (locations.isEmpty) {
                              return SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .18,
                                child: Center(
                                    child: Text(
                                  "There's nothing here",
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: ConstantsColors.navigationColor,
                                      fontWeight: FontWeight.bold),
                                )),
                              );
                            }
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * .18,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: locations.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      final homeController =
                                          Provider.of<HomeController>(context,
                                              listen: false);
                                      homeController.navigateToMapWithLocation(
                                          locations[index]);

                                      if (homeController.selectedLocation !=
                                          null) {
                                        print(true);
                                        showLocationDetails(
                                          context,
                                          location:
                                              homeController.selectedLocation!,
                                          isCafe: homeController
                                                  .selectedLocation!
                                                  .instantCoffee ??
                                              false,
                                          isBathroom: homeController
                                                  .selectedLocation!
                                                  .alternateOptions ??
                                              false,
                                        );
                                        homeController.selectedLocation = null;
                                      }
                                    },
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 5),
                                        CoffeeContainer(
                                          locationModel: locations[index],
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return const SizedBox(width: 5);
                                },
                              ),
                            );
                          },
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
