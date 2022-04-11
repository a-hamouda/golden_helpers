// Copyright (c) 2022, Abdulhamid Yusuf. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'golden_configuration.dart';

/// A function to perform golden snapshot tests.
///
/// This function sets up a widget test that captures a snapshot of a widget
/// and compares it against a golden file to ensure the widget renders correctly.
///
/// Parameters:
/// - [description]: A description of the test.
/// - [snapshotName]: The name of the snapshot being tested.
/// - [version]: The version of the golden file.
/// - [builder]: A function that builds the widget to be tested.
/// - [act]: An optional function that performs actions on the widget tester.
/// - [skip]: Whether to skip this test.
@isTest
void goldenSnapshotTest({
  required String description,
  required String snapshotName,
  required int version,
  required Widget Function(Key key) builder,
  Future<void> Function(WidgetTester tester, Key key, BuildContext context)?
      act,
  bool skip = false,
}) async {
  testWidgets(description, (tester) async {
    // arrange
    final key = UniqueKey();

    // act

    await tester.pumpWidget(
      MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Center(
          child: RepaintBoundary(
            child: Material(
              type: MaterialType.transparency,
              child: builder(key),
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
    final snapshotFileName = '${snapshotName}_v$version.png';
    await expectLater(find.byKey(key), matchesGoldenFile(snapshotFileName));
  }, skip: skip);
}
