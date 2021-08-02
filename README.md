# metooltip

Reference flutter native Tooltip to implement a configurable Tooltip, as a project to learn flutter by myself. I will complete some business logic step by step, Ensure the stability of api.

According to the case, you can customize the appearance of the tip box. Custom animations will be supported in the future.

## Future

-   [ ] Animation Configuration
-   [ ] Optimize configuration items
-   [ ] Add Test

## Example

```dart
MeTooltip(
    message:
        "This is a bottom tooltip,This is a bottom tooltip,This is a bottom tooltip,This is a bottom tooltip",
    child: Text("bottom tooltip"),
    preferOri: PreferOrientation.bottom,
),
```

-   [example1](./example/example-1/)

    ![<img width="300px" height="300px" src="https://github.com/secret344/flutter-tooltip/blob/dev/screenshots/example-1-1.png"/>](https://github.com/secret344/flutter-tooltip/blob/dev/screenshots/example-1-1.png)

-   [example2](./example/example-2/)

    ![<img width="300px" height="300px" src="https://github.com/secret344/flutter-tooltip/blob/dev/screenshots/example-2.png"/>](https://github.com/secret344/flutter-tooltip/blob/dev/screenshots/example-2.png)
    ![<img width="300px" height="300px" src="https://github.com/secret344/flutter-tooltip/blob/dev/screenshots/example-2.gif"/>](https://github.com/secret344/flutter-tooltip/blob/dev/screenshots/example-2.gif)

-   [example3](./example/example-3/)

    ![<img width="300px" height="300px" src="https://github.com/secret344/flutter-tooltip/blob/dev/screenshots/example-3.gif"/>](https://github.com/secret344/flutter-tooltip/blob/dev/screenshots/example-3.gif)

## Getting Started

This project is a starting point for a Dart
[package](https://flutter.dev/developing-packages/),
a library module containing code that can be shared easily across
multiple Flutter or Dart projects.

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
