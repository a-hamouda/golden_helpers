// Copyright (c) 2022, Abdulhamid Yusuf. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'package:path/path.dart' as path;

const _frameDuration = Duration(milliseconds: 16, microseconds: 683);

/// A function to perform golden animation tests.
///
/// This function sets up a widget test that captures frames of an animation
/// and compares them against golden files to ensure the animation renders
/// correctly over time.
///
/// Parameters:
/// - [description]: A description of the test.
/// - [animationName]: The name of the animation being tested.
/// - [version]: The version of the golden file.
/// - [builder]: A function that builds the widget to be tested.
/// - [act]: An optional function that performs actions on the widget tester.
/// - [timeout]: The maximum duration to wait for the animation to complete.
/// - [parentDirectory]: The directory where the golden files are stored.
/// - [skip]: Whether to skip this test.
@isTest
void goldenAnimationTest({
  required String description,
  required String animationName,
  required int version,
  required Widget Function(Key key) builder,
  Future<void> Function(WidgetTester tester, Key key, BuildContext context)?
      act,
  Duration timeout = const Duration(seconds: 30),
  Uri? parentDirectory,
  bool skip = false,
}) {
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

    final finder = find.byKey(key);
    final context = tester.element(finder);
    await act?.call(tester, key, context);

    // assert
    final effectiveParentDirectory = parentDirectory?.path ?? '.';
    final maxFrameCount =
        (timeout.inMicroseconds / _frameDuration.inMicroseconds).round();
    int frameCount = 0;

    while (tester.hasRunningAnimations) {
      frameCount++;
      if (frameCount > maxFrameCount) {
        throw Exception('Golden animation test "$description" timed-out'
            ' before testing all frames.');
      }

      final goldenFrameFilePath = path.join(effectiveParentDirectory,
          '${animationName}_v$version', 'frame_$frameCount.png');

      await expectLater(finder, matchesGoldenFile(goldenFrameFilePath));
      await tester.pump(_frameDuration);
    }
  }, skip: skip);
}
