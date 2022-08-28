import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert' as convert;

import '../devtools/logger.dart';

import 'named_location.dart';
import 'named_locations_collection.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

const Color kAppDefaultBackgroundFillColor = Color(0xFF090918);

///////////////////////////////////////////////////////////////////////////////////////////////////

class SettingsManager {
  static const String _kSettingsFileName = 'weather_sphere_settings.json';

  static String _settingsFolder = '';

  static bool _useCurrentLocation = true;
  static NamedLocationsCollection _locations = NamedLocationsCollection();

  static String _backgroundImageFilePath = '';
  static BoxFit _backgroundImageBoxFit = BoxFit.cover;
  static Alignment _backgroundImageAlignment = Alignment.center;
  static Color _backgroundFillColor = kAppDefaultBackgroundFillColor;

  static Future<void> setup() async {
    if (isReady()) return;
    Directory d = await getApplicationDocumentsDirectory();
    _settingsFolder = d.path;
    Logger.print('settings folder: \'$_settingsFolder\' | path: \'${getFilePath()}\'');
    await load();
  }

  static bool isReady() {
    return (_settingsFolder != '');
  }

  static String getFilePath() {
    return '$_settingsFolder/$_kSettingsFileName';
  }

  static String getFolder() {
    return '$_settingsFolder/';
  }

  static void restoreDefaultSettings() {
    _useCurrentLocation = true;
    _locations = NamedLocationsCollection();

    _backgroundImageFilePath = '';
    _backgroundImageBoxFit = BoxFit.cover;
    _backgroundImageAlignment = Alignment.center;
    _backgroundFillColor = kAppDefaultBackgroundFillColor;
  }

  static Map toJson() {
    return {
      '_useCurrentLocation': _useCurrentLocation,
      '_locations': _locations.toJson(),
      '_backgroundImageFilePath': _backgroundImageFilePath,
      '_backgroundImageBoxFit': _backgroundImageBoxFit.name,
      '_backgroundImageAlignment.x': _backgroundImageAlignment.x,
      '_backgroundImageAlignment.y': _backgroundImageAlignment.y,
      '_backgroundFillColor': _backgroundFillColor.value,
    };
  }

  static void fromJson(dynamic jsonObject) {
    _useCurrentLocation = jsonObject['_useCurrentLocation'];
    _locations = NamedLocationsCollection.fromJson(jsonObject['_locations']);
    _backgroundImageFilePath = jsonObject['_backgroundImageFilePath'];
    _backgroundImageBoxFit = BoxFit.values.byName(jsonObject['_backgroundImageBoxFit']);
    _backgroundImageAlignment = Alignment(jsonObject['_backgroundImageAlignment.x'], jsonObject['_backgroundImageAlignment.y']);
    _backgroundFillColor = Color(jsonObject['_backgroundFillColor']);
  }

  static Future<bool> save() async {
    String destFilePath = getFilePath();

    Logger.print('attempting to save settings into \'$destFilePath\' ...');

    try {
      File dest = File(destFilePath);
      await dest.writeAsString(convert.jsonEncode(toJson()), flush: true);
    } catch (e) {
      Logger.print('failed to save settings into \'$destFilePath\' | exception: \'${e.toString()}\'');
      return false;
    }

    Logger.print('saved settings into \'$destFilePath\'');
    return true;
  }

  static Future<bool> load() async {
    String sourceFilePath = getFilePath();

    try {
      File source = File(sourceFilePath);
      String jsonContent = await source.readAsString();
      Logger.print('read settings info from \'$sourceFilePath\' | content:\n$jsonContent\n');
      fromJson(convert.jsonDecode(jsonContent));
    } catch (e) {
      Logger.print('failed to load settings info from \'$sourceFilePath\' | exception: \'${e.toString()}\'');
      restoreDefaultSettings();
      return false;
    }

    Logger.print('loaded settings info from \'$sourceFilePath\'');
    return true;
  }

  static void setBackgroundImageFilePath(String v) {
    _backgroundImageFilePath = v;
  }

  static String getBackgroundImageFilePath() {
    return _backgroundImageFilePath;
  }

  static void setBackgroundImageBoxFit(BoxFit v) {
    _backgroundImageBoxFit = v;
  }

  static BoxFit getBackgroundImageBoxFit() {
    return _backgroundImageBoxFit;
  }

  static void setBackgroundImageAlignment(Alignment v) {
    _backgroundImageAlignment = v;
  }

  static Alignment getBackgroundImageAlignment() {
    return _backgroundImageAlignment;
  }

  static void setBackgroundFillColor(Color v) {
    _backgroundFillColor = v;
  }

  static Color getBackgroundFillColor() {
    return _backgroundFillColor;
  }

  static void setUseCurrentLocation(bool v) {
    _useCurrentLocation = v;
  }

  static bool getUseCurrentLocation() {
    return _useCurrentLocation;
  }

  static bool hasLocationInfo() {
    return _locations.hasSelectedIndex();
  }

  static String getDisplayFullLocation() {
    if (hasLocationInfo()) return _locations.getSelectedLocation().getDisplayFullLocation();
    return '';
  }

  static NamedLocation getSelectedLocation() {
    return _locations.getSelectedLocation();
  }

  static void setSelectedLocationIndex(int v) {
    _locations.setSelectedIndex(v);
  }

  static int getSelectedLocationIndex() {
    return _locations.getSelectedIndex();
  }

  static void mergeLocation(NamedLocation v, {bool select = false}) {
    _locations.merge(v, select: select);
  }

  static List<NamedLocation> getLocations() {
    return _locations.getLocations();
  }

  static void removeLocations(List<bool> locationsToRemove) {
    _locations.removeLocations(locationsToRemove);
  }
}
