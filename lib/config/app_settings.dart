import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppSettings extends ChangeNotifier {
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  late Box box;
  Map<String, dynamic> settings = {
    'darkMode': false,
    'locale': 'pt_BR',
    'name': 'R\$',
  };

  AppSettings() {
    _startSettings();
  }

  _startSettings() async {
    await _startPreferences();
  }

  Future<void> _startPreferences() async {
    box = await Hive.openBox('settings');
  }

  _readLocale() {
    final local = box.get('locale', defaultValue: 'pt_BR');
    final name = box.get('name', defaultValue: 'R\$');

    settings = {
      'locale': local,
      'name': name,
    };
    notifyListeners();
  }

  setLocale(String local, String name) async {
    await box.put('local', local);
    await box.put('name', name);
    _readLocale();
  }
}
