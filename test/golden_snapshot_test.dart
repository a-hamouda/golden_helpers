import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_helpers/src/golden_configuration.dart';
import 'package:golden_helpers/src/golden_snapshot.dart';

void main() {
  group('goldenSnapshotTest tests', () {
    setUpAll(() {
      GoldenConfiguration.builder
        ..cachingSetup = ((context) async {
          final fontLoader = FontLoader('Roboto');
          final fontByteData = File('test/fonts/Roboto-Regular.ttf')
              .readAsBytes()
              .then((bytes) => ByteData.view(Uint8List.fromList(bytes).buffer));
          fontLoader.addFont(fontByteData);
          await fontLoader.load();
        })
        ..locale = const Locale('en');
    });
    Checkbox buildCheckbox(Key key) =>
        Checkbox(key: key, value: true, onChanged: (_) {});

    Text buildText(Key key) => Text(
          'Hello, world',
          key: key,
          style: const TextStyle(fontFamily: 'Roboto'),
        );

    goldenSnapshotTest(
        description: 'generates checkbox golden snapshot',
        snapshotName: 'checkbox',
        version: 1,
        builder: buildCheckbox);

    goldenSnapshotTest(
      description: 'generates checkbox golden snapshot',
      snapshotName: 'checkbox',
      version: 1,
      locales: const [Locale('en'), Locale('ar')],
      builder: buildCheckbox,
    );

    goldenSnapshotTest(
      description: 'renders text after precaching font',
      snapshotName: 'simple_text',
      version: 1,
      builder: buildText,
    );
  });
}
