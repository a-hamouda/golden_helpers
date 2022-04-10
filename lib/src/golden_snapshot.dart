// Copyright (c) 2022, Abdulhamid Yusuf. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'golden_configuration.dart';

@isTest
void goldenSnapshotTest({
  required String description,
  required String snapshotName,
  required int version,
  required Widget Function(Key key) builder,
  Future<void> Function(WidgetTester tester, Key key, BuildContext context)?
      act,
  List<Locale> locales = const [],
  bool skip = false,
}) async {
  if (locales.isEmpty) {
    _testUsecase(
      description: description,
      snapshotName: snapshotName,
      builder: builder,
      version: version,
      act: act,
      skip: skip,
    );
  } else {
    for (final locale in locales) {
      _testUsecase(
        description: description,
        snapshotName: snapshotName,
        builder: builder,
        version: version,
        locale: locale,
        act: act,
        skip: skip,
      );
    }
  }
}

void _testUsecase({
  required String description,
  required String snapshotName,
  required Widget Function(Key key) builder,
  required int version,
  Future<void> Function(WidgetTester tester, Key key, BuildContext context)?
      act,
  Locale? locale,
  bool? skip,
}) {
  final effectiveDescription = locale == null
      ? description
      : '$description - Locale_${locale.languageCode}';

  testWidgets(effectiveDescription, (tester) async {
    // arrange
    final key = UniqueKey();

    // act
    final effectiveLocale = locale ?? currentConfiguration.locale;
    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Theme(
          data: currentConfiguration.themeData,
          child: Localizations(
            locale: effectiveLocale,
            delegates: currentConfiguration.localizationDelegates.toList(),
            child: Center(
              child: RepaintBoundary(
                child: Material(child: builder(key)),
              ),
            ),
          ),
        ),
      ),
    );

    final context = tester.element(find.byKey(key));
    await tester.runAsync<void>(
        () async => currentConfiguration.cachingSetup?.call(context));
    await tester.pumpAndSettle();
    await act?.call(tester, key, context);

    // assert
    final snapshotFileName = locale == null
        ? '${snapshotName}_v$version.png'
        : '${snapshotName}_${locale.languageCode}_v$version.png';
    await expectLater(find.byKey(key), matchesGoldenFile(snapshotFileName));
  }, skip: skip);
}
