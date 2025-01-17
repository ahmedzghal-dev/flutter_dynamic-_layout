import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum LayoutEnum {
  defaultLayout,
}

class LayoutProvider extends ChangeNotifier {
  LayoutEnum currentLayout = LayoutEnum.defaultLayout;
  Map<String, dynamic>? layoutJson;

  final Map<LayoutEnum, String> layoutPaths = {
    LayoutEnum.defaultLayout: "assets/default_theme.json",
  };

  LayoutProvider._init();
  static final LayoutProvider _instance = LayoutProvider._init();
  static LayoutProvider get instance => _instance;

  Future<void> changeLayout(LayoutEnum layout) async {
    currentLayout = layout;
    await _loadLayoutData();
    notifyListeners();
  }

  Future<void> _loadLayoutData() async {
    String path =
        layoutPaths[currentLayout] ?? layoutPaths[LayoutEnum.defaultLayout]!;
    String layoutStr = await rootBundle.loadString(path);
    layoutJson = jsonDecode(layoutStr);
  }

  dynamic getSetting(String path, {dynamic defaultValue}) {
    if (layoutJson == null) return defaultValue;
    try {
      List<String> keys = path.split('.');
      dynamic value = layoutJson;
      for (var key in keys) {
        value = value[key];
        if (value == null) return defaultValue;
      }
      return value;
    } catch (e) {
      print("Error reading setting for '$path': $e");
      return defaultValue;
    }
  }

  void updateSetting(String path, dynamic newValue) {
    if (layoutJson == null) return;
    List<String> keys = path.split('.');
    Map<String, dynamic> currentMap = layoutJson!;
    for (int i = 0; i < keys.length - 1; i++) {
      currentMap = currentMap[keys[i]] as Map<String, dynamic>;
    }
    currentMap[keys.last] = newValue;
    notifyListeners();
  }

  /// Generic visibility method.
  bool isVisible(String componentKey, {bool defaultValue = true}) {
    return getSetting(componentKey, defaultValue: defaultValue) as bool;
  }
}
