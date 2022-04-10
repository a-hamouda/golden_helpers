import 'package:flutter_test/flutter_test.dart';
import 'package:golden_helpers/src/golden_group.dart';
import 'package:golden_helpers/src/helper_file_comparator.dart';

void main() {
  goldenGroup('goldenGroup tests', () {
    test(
        'should have $HelperGoldenFileComparator'
        ' as the default comparator',
        () => expect(goldenFileComparator, isA<HelperGoldenFileComparator>()));
  });
}
