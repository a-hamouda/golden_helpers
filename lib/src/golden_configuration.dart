// Copyright (c) 2022, Abdulhamid Yusuf. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.

import 'package:flutter/material.dart';
import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';

GoldenConfiguration currentConfiguration = GoldenConfiguration._();

class GoldenConfiguration extends ChangeNotifier {
  GoldenConfiguration._() {
    addListener(_saveCurrentConfiguration);
  }

  static GoldenConfiguration get builder => currentConfiguration;

  final tester = TestWidgetsFlutterBinding.ensureInitialized();

  @override
  void dispose() {
    removeListener(_saveCurrentConfiguration);
    super.dispose();
  }

  void _saveCurrentConfiguration() => currentConfiguration = this;

  set themeData(ThemeData value) {
    if (_themeData == value) return;
    _themeData = value;
    notifyListeners();
  }

  ThemeData? _themeData;

  ThemeData get themeData => _themeData ?? ThemeData.light();

  set localizationDelegates(Iterable<LocalizationsDelegate<dynamic>> value) {
    const iterableEquality = IterableEquality<LocalizationsDelegate<dynamic>>();
    if (iterableEquality.equals(_localizationDelegates, value)) return;
    _localizationDelegates = value;
    notifyListeners();
  }

  Iterable<LocalizationsDelegate<dynamic>>? _localizationDelegates;

  Iterable<LocalizationsDelegate<dynamic>> get localizationDelegates =>
      _localizationDelegates ?? [];

  set locale(Locale value) {
    if (_locale == value) return;
    _locale = value;
    notifyListeners();
  }

  Locale? _locale;

  Locale get locale => _locale ?? tester.window.locale;

  set cachingSetup(Future<void> Function(BuildContext context)? value) {
    if (_cachingSetup == value) return;
    _cachingSetup = value;
    notifyListeners();
  }

  Future<void> Function(BuildContext context)? _cachingSetup;

  Future<void> Function(BuildContext context)? get cachingSetup =>
      _cachingSetup;
}
