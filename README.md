# directional_rotation

A widget that implicitly rotates its child to the provided angle
in the direction allowed by the constraints: closest, furthest,
clockwise, or counter-clockwise.

# Usage

```dart
import 'package:directional_rotation/directional_rotation.dart';
```

[DirectionalRotation] accepts an [angle], in degrees by default, and implicitly
rotates its [child] to the [angle] whenever the [angle] is updated.

```dart
/// Whenever [angle] is modified, the [DirectionalRotation]
/// will rotate its child to the new [angle].
var angle = 180.0;

DirectionalRotation(
  angle: angle,
  child: MyWidget(),
);
```

## Scale

The [angle] can be normalized to any [scale]. By default, [angle] equates to
degrees (a [scale] of `360`.)

```dart
/// This [DirectionalRotation] is normalized to a `0` to `1` scale and currently
/// rotated to `0.5`, which is the equivalent of `180` on the default scale.
DirectionalRotation(
  angle: 0.5,
  scale: 1.0,
  child: MyWidget(),
);
```

## Duration

With the default settings, the [duration] of each animation will be factored
by the difference between the old [angle] and the new [angle], whenever [angle]
is updated. In this case, [duration] will equate to one whole rotation.

[factorDuration] can be set to `false` to have each animation last the entire
[duration].

[duration] defaults to `1` second.

```dart
/// If [angle] was changed from `0` to `180`, the duration of the
/// animation would be factored by `0.5` and last `500` milliseconds.
DirectionalRotation(
  angle: 180,
  duration: Duration(seconds: 1),
  child: MyWidget(),
);

/// In this case, where [factorDuration] is `false`, the duration
/// will last for the entire second.
DirectionalRotation(
  angle: 180,
  duration: Duration(seconds: 1),
  factorDuration: false,
  child: MyWidget(),
);
```

## Directionality

By default the [child] will rotate in the direction that has the shorest span
to the new [angle] from the current [angle], whenever [angle] is updated.

[Direction] can be set to change how the direction of the rotation is
determined.

```dart
/// This [DirectionalRotation] will only rotate its child
/// in a clockwise direction.
DirectionalRotation(
  angle: 0,
  direction: RotationDirection.clockwise,
  child: MyWidget(),
);

/// This [DirectionalRotation] will only rotate its child
/// in a counter-clockwise direction.
DirectionalRotation(
  angle: 0,
  direction: RotationDirection.counterClockwise,
  child: MyWidget(),
);

/// This [DirectionalRotation] will rotate its child in the direction with
/// the shortest span from the current angle to the new angle.
DirectionalRotation(
  angle: 0,
  direction: RotationDirection.closest,
  child: MyWidget(),
);

/// This [DirectionalRotation] will rotate its child in the direction with
/// the longest span from the current angle to the new angle.
DirectionalRotation(
  angle: 0,
  direction: RotationDirection.furthest,
  child: MyWidget(),
);
```
