// Copyright (c) 2022, Abdulhamid Yusuf. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meta/meta.dart';

import 'golden_configuration.dart';
import 'package:path/path.dart' as path;

const _frameDuration = Duration(milliseconds: 16, microseconds: 683);

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
        theme: currentConfiguration.themeData,
        localizationsDelegates: currentConfiguration.localizationDelegates,
        home: Center(
          child: RepaintBoundary(
            child: Material(child: builder(key)),
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
