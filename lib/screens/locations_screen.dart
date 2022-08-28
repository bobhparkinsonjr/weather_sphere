import 'package:flutter/material.dart';

import '../utilities/named_location.dart';
import '../utilities/settings_manager.dart';

import '../controls/screen_frame.dart';
import '../controls/location_list_item.dart';

import 'specify_location_screen.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

class LocationsScreen extends StatefulWidget {
  const LocationsScreen({Key? key}) : super(key: key);

  @override
  State<LocationsScreen> createState() => _LocationsScreenState();
}

class _LocationsScreenState extends State<LocationsScreen> {
  List<NamedLocation> locations = [];
  int selectedIndex = -1;

  bool removeMode = false;
  List<bool> removeLocations = [];

  @override
  void initState() {
    super.initState();
    refreshLocations();
  }

  void refreshLocations() {
    locations = SettingsManager.getLocations();
    selectedIndex = SettingsManager.getSelectedLocationIndex();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xC01D1E33),
        title: removeMode ? const Text('Choose Locations To Remove') : const Text('Choose Location'),
      ),
      body: ScreenFrame(
        child: ListView.builder(
          itemCount: locations.length,
          itemBuilder: (BuildContext context, int index) {
            return LocationListItem(
              index: index,
              namedLocation: locations[index],
              selected: removeMode ? removeLocations[index] : selectedIndex == index,
              onPress: (index) {
                if (removeMode) {
                  setState(() {
                    removeLocations[index] = !(removeLocations[index]);
                  });
                } else {
                  if (mounted) {
                    SettingsManager.setSelectedLocationIndex(index);
                    SettingsManager.setUseCurrentLocation(false);
                    Navigator.of(context).pop();
                  }
                }
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        elevation: 0.0,
        backgroundColor: const Color(0xC01D1E33),
        selectedItemColor: Color(0xFFFFFFFF),
        unselectedItemColor: Color(0xFFFFFFFF),
        selectedFontSize: 12.0,
        unselectedFontSize: 12.0,
        items: removeMode
            ? [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.clear),
                  label: 'Remove Selected Locations',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.clear),
                  label: 'Cancel',
                ),
              ]
            : [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.add),
                  label: 'Add',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.clear),
                  label: 'Remove',
                ),
              ],
        onTap: (index) async {
          if (removeMode) {
            switch (index) {
              case 0: // remove selected locations
                SettingsManager.removeLocations(removeLocations);
                setState(() {
                  removeMode = false;
                  refreshLocations();
                });
                break;

              case 1: // cancel
                setState(() {
                  removeMode = false;
                });
                break;
            }
          } else {
            switch (index) {
              case 0: // add location
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SpecifyLocationScreen(),
                  ),
                );

                setState(() {
                  refreshLocations();
                });
                break;

              case 1: // enter remove locations mode
                setState(() {
                  removeLocations = [];
                  for (int i = 0; i < locations.length; ++i) removeLocations.add(false);

                  removeMode = true;
                });
                break;
            }
          }
        },
      ),
    );
  }
}
