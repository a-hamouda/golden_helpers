# Golden Helpers

## What is it

Golden Helpers is a Dart library that provides a set of utilities to facilitate golden tests in Flutter applications. Golden tests are used to ensure UI consistency by comparing widget snapshots (golden files) against actual results.

## Features

- **Golden Animation Tests**: Capture frames of an animation and compare them against golden files.
- **Golden Snapshot Tests**: Capture a snapshot of a widget and compare it against a golden file.
- **Golden Test Groups**: Organize and manage groups of golden tests.
- **Custom Golden File Comparator**: Manage golden files with additional functionality, including forced updates and custom file path validation.
- **Caching Setup**: Preload resources needed for golden tests.

## Example

Here is an example of using the library to write a golden snapshot test:

```dart
void main() {
  group('goldenSnapshotTest tests', () {
    setUpAll(() {
      GoldenConfiguration.builder.cachingSetup = ((context) async {
        final fontLoader = FontLoader('Roboto');
        final fontByteData = File('test/fonts/Roboto-Regular.ttf')
            .readAsBytes()
            .then((bytes) =>
            ByteData.view(Uint8List
                .fromList(bytes)
                .buffer));
        fontLoader.addFont(fontByteData);
        await fontLoader.load();
      });
    });
    Checkbox buildCheckbox(Key key) =>
        Checkbox(key: key, value: true, onChanged: (_) {});

    Text buildText(Key key) =>
        Text(
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
      description: 'renders text after precaching font',
      snapshotName: 'simple_text',
      version: 1,
      builder: buildText,
    );
  });
}
```

Here is an example of using the library to write a golden animation test:

```dart
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
```

## Running the Tests

To run the golden tests for this library, use the following command:

```bash
flutter test --update-goldens
```

This command will run all the golden tests and update the golden files with the new snapshots.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
```
