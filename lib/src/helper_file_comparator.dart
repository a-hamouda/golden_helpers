// Copyright (c) 2022, Abdulhamid Yusuf. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.

import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as path;
import 'package:flutter_test/flutter_test.dart';

/// A custom golden file comparator for Flutter widget tests.
///
/// This class extends [LocalFileComparator] to provide additional functionality
/// for managing golden files, including the ability to force update golden files
/// and custom file path validation.
///
/// Parameters:
/// - [snapshotsDir]: The directory where the golden snapshots are stored.
/// - [forceUpdateGolden]: A flag indicating whether to force update the golden files.
class HelperGoldenFileComparator extends LocalFileComparator {
  HelperGoldenFileComparator(
      {required Uri snapshotsDir, required bool forceUpdateGolden})
      : _forceUpdateGolden = forceUpdateGolden,
        super(Uri.directory(path.join(snapshotsDir.path, 'placeholder')));

  /// A regular expression to validate the golden file path.
  static final _goldenFilePathRegex = RegExp(r'.+_v\d+(?:.frame_\d+)?\.png');

  /// A flag indicating whether to force update the golden files.
  final bool _forceUpdateGolden;

  /// Updates the golden file with the provided image bytes.
  ///
  /// If [_forceUpdateGolden] is true or the golden file does not exist,
  /// the golden file is updated with the new image bytes. Otherwise, a warning
  /// message is printed.
  ///
  /// Parameters:
  /// - [golden]: The URI of the golden file.
  /// - [imageBytes]: The image bytes to update the golden file with.
  @override
  Future<void> update(Uri golden, Uint8List imageBytes) async {
    final goldenFile = File(path.join(path.fromUri(basedir), golden.path));

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

  /// Compares the provided image bytes with the golden file.
  ///
  /// Parameters:
  /// - [imageBytes]: The image bytes to compare.
  /// - [golden]: The URI of the golden file.
  ///
  /// Returns:
  /// A [Future] that completes with a boolean indicating whether the comparison was successful.
  @override
  Future<bool> compare(Uint8List imageBytes, Uri golden) {
    return super.compare(imageBytes, Uri.file(golden.path));
  }
}
