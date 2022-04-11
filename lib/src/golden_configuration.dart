// Copyright (c) 2022, Abdulhamid Yusuf. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// The current configuration for golden tests.
GoldenConfiguration currentConfiguration = GoldenConfiguration._();

/// A class that manages the configuration for golden tests.
///
/// This class extends [ChangeNotifier] to allow listeners to be notified
/// when the configuration changes.
class GoldenConfiguration extends ChangeNotifier {
  /// Private constructor to initialize the configuration and add a listener
  /// to save the current configuration.
  GoldenConfiguration._() {
    addListener(_saveCurrentConfiguration);
  }

  /// A static getter to access the current configuration.
  static GoldenConfiguration get builder => currentConfiguration;

  /// The [TestWidgetsFlutterBinding] instance used for testing.
  final tester = TestWidgetsFlutterBinding.ensureInitialized();

  /// Disposes the configuration and removes the listener.
  @override
  void dispose() {
    removeListener(_saveCurrentConfiguration);
    super.dispose();
  }

  /// Saves the current configuration.
  void _saveCurrentConfiguration() => currentConfiguration = this;

  /// Sets the caching setup function and notifies listeners if it changes.
  ///
  /// The [cachingSetup] function is used to preload fonts or other resources
  /// needed for golden tests.
  set cachingSetup(Future<void> Function(BuildContext context)? value) {
    if (_cachingSetup == value) return;
    _cachingSetup = value;
    notifyListeners();
  }

  /// The caching setup function.
  Future<void> Function(BuildContext context)? _cachingSetup;

  /// Gets the caching setup function.
  Future<void> Function(BuildContext context)? get cachingSetup =>
      _cachingSetup;
}
