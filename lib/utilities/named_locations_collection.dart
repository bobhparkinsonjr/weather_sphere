import 'named_location.dart';

///////////////////////////////////////////////////////////////////////////////////////////////////

class NamedLocationsCollection {
  List<NamedLocation> _locations = [];
  int _selectedIndex = -1;

  NamedLocationsCollection();

  void merge(NamedLocation v, {bool select = false}) {
    int index = -1;

    if (!(contains(v))) {
      _locations.add(v);
      index = _locations.length - 1;
    }

    if (select) {
      if (index >= 0) {
        _selectedIndex = index;
      } else {
        _selectedIndex = findIndex(v);
      }
    } else {
      if (_locations.isNotEmpty && !(hasSelectedIndex())) _selectedIndex = 0;
    }
  }

  bool contains(NamedLocation v) {
    return _locations.contains(v);
  }

  int findIndex(NamedLocation v) {
    for (int i = 0; i < _locations.length; ++i) {
      if (_locations[i] == v) {
        return i;
      }
    }

    return -1;
  }

  List<NamedLocation> getLocations() {
    return List<NamedLocation>.from(_locations);
  }

  NamedLocation getSelectedLocation() {
    return _locations[_selectedIndex];
  }

  bool get isNotEmpty => _locations.isNotEmpty;
  bool get isEmpty => _locations.isEmpty;

  bool hasSelectedIndex() {
    return (_selectedIndex >= 0 && _selectedIndex < _locations.length);
  }

  int getSelectedIndex() {
    return _selectedIndex;
  }

  void setSelectedIndex(int v) {
    _selectedIndex = v;
  }

  void removeLocations(List<bool> locationsToRemove) {
    if (locationsToRemove.length == _locations.length) {
      List<NamedLocation> newLocations = [];

      for (int i = 0; i < _locations.length; ++i) {
        if (!(locationsToRemove[i])) newLocations.add(_locations[i]);
      }

      _locations = newLocations;

      if (_locations.isNotEmpty) {
        _selectedIndex = 0;
      } else {
        _selectedIndex = -1;
      }
    }
  }

  Map toJson() {
    return {
      '_locations': _locations.map((i) => i.toJson()).toList(),
      '_selectedIndex': _selectedIndex,
    };
  }

  NamedLocationsCollection.fromJson(dynamic jsonObject) {
    _locations = [];
    jsonObject['_locations'].forEach((i) {
      _locations.add(NamedLocation.fromJson(i));
    });

    _selectedIndex = jsonObject['_selectedIndex'];
  }
}
