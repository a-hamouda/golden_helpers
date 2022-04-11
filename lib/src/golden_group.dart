// Copyright (c) 2022, Abdulhamid Yusuf. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:meta/meta.dart';

import 'golden_configuration.dart';
import 'helper_file_comparator.dart';

/// Defines a group of golden tests.
///
/// This function sets up a group of tests that compare widget snapshots
/// (golden files) to ensure UI consistency. It allows configuring the
/// directory for storing snapshots, whether to force update the golden files,
/// and a caching setup function.
///
/// Parameters:
/// - [description]: A description of the test group.
/// - [body]: A function containing the tests to be executed in this group.
/// - [snapshotsDir]: An optional URI specifying the directory for storing snapshots.
/// - [forceUpdateGolden]: An optional flag to force update the golden files.
/// - [skip]: An optional flag to skip this test group.
/// - [cachingSetup]: An optional function to preload resources needed for golden tests.
@isTestGroup
void goldenGroup(
  Object description,
  void Function() body, {
  Uri? snapshotsDir,
  bool? forceUpdateGolden,
  dynamic skip,
  Future<void> Function(BuildContext context)? cachingSetup,
}) {
  final effectiveSnapshotsDir = snapshotsDir ?? path.toUri('goldens');
  final effectiveForceUpdateGolden = forceUpdateGolden ?? false;
  final baseDir = (goldenFileComparator as LocalFileComparator).basedir;
  final helperGoldenFileComparator = HelperGoldenFileComparator(
    snapshotsDir:
        Uri.directory(path.join(baseDir.path, effectiveSnapshotsDir.path)),
    forceUpdateGolden: effectiveForceUpdateGolden,
  );

  currentConfiguration.cachingSetup = cachingSetup;

  group(description, () {
    final originalGoldenFileComparator = goldenFileComparator;
    setUp(() => goldenFileComparator = helperGoldenFileComparator);
    body();
    tearDown(() => goldenFileComparator = originalGoldenFileComparator);
  }, skip: skip);
}
