import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_helpers/src/golden_animation.dart';
import 'package:golden_helpers/src/golden_group.dart';

void main() {
  goldenGroup(
    'goldenAnimationTest tests',
    () {
      goldenAnimationTest(
        description: 'checkbox animation',
        animationName: 'toggle_on',
        version: 1,
        builder: (key) {
          bool value = false;
          return StatefulBuilder(
            builder: (_, setState) => Checkbox(
              key: key,
              value: value,
              onChanged: (_) => setState(() => value = !value),
            ),
          );
        },
        parentDirectory: Uri.directory('animations'),
        act: (tester, key, _) async {
          await tester.tap(find.byKey(key));
          await tester.pump();
        },
      );
    },
  );
}
