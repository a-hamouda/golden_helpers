// Copyright (c) 2022, Abdulhamid Yusuf. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_test/flutter_test.dart';

class HelperGoldenFileComparator extends LocalFileComparator {
  HelperGoldenFileComparator(
      {required Uri snapshotsDir, required bool forceUpdateGolden})
      : _forceUpdateGolden = forceUpdateGolden,
        super(Uri.directory(path.join(snapshotsDir.path, 'placeholder')));

  static final _goldenFilePathRegex = RegExp(r'.+_v\d+(?:.frame_\d+)?\.png');

  final bool _forceUpdateGolden;

  @override
  Future<void> update(Uri golden, Uint8List imageBytes) async {
    final goldenFile =
        File(path.join(path.fromUri(basedir), golden.path));

    assert(_goldenFilePathRegex.hasMatch(goldenFile.path), """
Golden file path doesn't conform to the accepted file path style.
Expected  : ${_goldenFilePathRegex.pattern}
Actual    : ${goldenFile.path}""");

    if (_forceUpdateGolden || !(await goldenFile.exists())) {
      await super.update(Uri.file(golden.path), imageBytes);
    } else {
      debugPrint('''\u001b[33m
WARNING: Golden file cannot be overridden.
Delete the golden file manually first, or set "forceUpdateGolden = true" in goldenGroup
if you want to regenerate a golden for this test.
file://${goldenFile.absolute.path}\u001b[0m''');
    }
  }

  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) {
    return super.compare(imageBytes, Uri.file(path.basename(golden.path)));
  }
}
