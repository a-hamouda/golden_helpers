// Copyright (c) 2022, Abdulhamid Yusuf. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for details.

import 'package:flutter_test/flutter_test.dart';
import 'package:path/path.dart' as path;
import 'package:meta/meta.dart';

import 'helper_file_comparator.dart';

@isTestGroup
void goldenGroup(Object description, void Function() body,
    {Uri? snapshotsDir, bool? forceUpdateGolden, dynamic skip}) {
  final effectiveSnapshotsDir = snapshotsDir ?? path.toUri('goldens');
  final effectiveForceUpdateGolden = forceUpdateGolden ?? false;
  final baseDir = (goldenFileComparator as LocalFileComparator).basedir;
  final helperGoldenFileComparator = HelperGoldenFileComparator(
    snapshotsDir:
        Uri.directory(path.join(baseDir.path, effectiveSnapshotsDir.path)),
    forceUpdateGolden: effectiveForceUpdateGolden,
  );

  group(description, () {
    final originalGoldenFileComparator = goldenFileComparator;
    setUp(() => goldenFileComparator = helperGoldenFileComparator);
    body();
    tearDown(() => goldenFileComparator = originalGoldenFileComparator);
  }, skip: skip);
}
