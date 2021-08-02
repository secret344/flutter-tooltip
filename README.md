# metooltip

Reference flutter native Tooltip to implement a configurable Tooltip, as a project to learn flutter by myself. I will complete some business logic step by step, Ensure the stability of api.

According to the case, you can customize the appearance of the tip box. Custom animations will be supported in the future.

## installing

With Dart:

```
dart pub add metooltip
```

With Flutter:

```
flutter pub add metooltip
```

pubspec.yaml :

```
dependencies:
  metooltip: <latest_version>
```

### Import it

```dart
import 'package:metooltip/metooltip.dart';
```

## Future

-   [x] Animation Configuration
-   [ ] Optimize configuration items
-   [ ] Add Test

## Example(please be sure to review all examples when using)

```dart
MeTooltip(
    message:
        "This is a bottom tooltip,This is a bottom tooltip,This is a bottom tooltip,This is a bottom tooltip",
    child: Text("bottom tooltip"),
    preferOri: PreferOrientation.bottom,
),
```

-   [example1](./example/example-1/)

    <img width="500px" height="500px" src="https://raw.githubusercontent.com/secret344/flutter-tooltip/main/screenshots/example-1-1.png"/>

-   [example2](./example/example-2/)

    <img width="500px" height="500px" src="https://raw.githubusercontent.com/secret344/flutter-tooltip/main/screenshots/example-2.png"/>
    <img width="500px" height="500px" src="https://raw.githubusercontent.com/secret344/flutter-tooltip/main/screenshots/example-2.gif"/>

-   [example3](./example/example-3/)

    <img width="500px" height="500px" src="https://raw.githubusercontent.com/secret344/flutter-tooltip/main/screenshots/example-3.gif"/>

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
