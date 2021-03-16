import 'dart:math' as math;
import 'package:flutter/widgets.dart';

/// The direction the [DirectionalRotation] will rotate its child in.
enum RotationDirection {
  /// The child will only rotate clockwise.
  clockwise,

  /// The child will only rotate counter-clockwise.
  counterClockwise,

  /// The child will rotate in whichever direction has the
  /// smaller span from the current angle to the new angle.
  closest,

  /// The child will rotate in whichever direction has the
  /// larger span from the current angle to the new angle.
  furthest,
}

/// A widget that implicitly rotates its child to the provided angle.
class DirectionalRotation extends StatefulWidget {
  /// A widget that implicitly rotates its [child] to the provided angle.
  ///
  /// [angle] is the rotation currently applied to the [child], by default
  /// [angle] equates to degrees, but can be normalized to any [scale].
  /// [scale] must not be `null`.
  ///
  /// [scale] defines the scale the [angle] relates to, [scale] defaults
  /// to `360` and must not be `null` or `0`.
  ///
  /// [curve] sets the easing curve applied to each rotation animation.
  ///
  /// [duration] defines the length of each animation. If [factorDuration]
  /// is `true`, the [duration] will be factored by the difference between
  /// the current angle and the new angle, when [angle] is updated, and will
  /// equate the one whole rotation. If `false`, the [duration] will be the
  /// length of each animation, regardless of the distance of the rotation.
  ///
  /// [direction] constrains the direction the [child] may rotate in, by default
  /// the [child] will rotate in the direction that has the shorest span to the
  /// new angle from the current angle, when [angle] is updated.
  ///
  /// [onComplete] is a callback that's called each time the animation
  /// completes.
  const DirectionalRotation({
    Key? key,
    required this.angle,
    required this.child,
    this.scale = 360.0,
    this.curve = Curves.linear,
    this.duration = const Duration(seconds: 1),
    this.factorDuration = true,
    this.direction = RotationDirection.closest,
    this.onComplete,
  })  : assert(scale != 0),
        super(key: key);

  /// The angle currently applied to the child.
  ///
  /// The rotation applied to the child is extrapolated from
  /// a `0` to `1` scale, calculated from `angle / scale`.
  /// [scale] defaults to `360`.
  final num angle;

  /// The child the rotation is applied to.
  final Widget child;

  /// The size of the scale [angle] relates to. (Degrees
  /// are scaled to `360`.)
  final num scale;

  /// The easing curve applied to the rotation animation.
  final Curve curve;

  /// The duration applied to the rotation animation.
  final Duration duration;

  /// If `true`, [duration] will equate to the length of one complete
  /// rotation, and will be scaled to the difference between the old
  /// angle and new angle when [angle] is updated. If `false`, each
  /// rotation, no matter the distance, will last for [duration].
  final bool factorDuration;

  /// The direction(s) the rotation animation is constrained to or
  /// derived from.
  final RotationDirection direction;

  /// A callback called each time the animation completes.
  final VoidCallback? onComplete;

  @override
  _DirectionalRotationState createState() => _DirectionalRotationState();
}

class _DirectionalRotationState extends State<DirectionalRotation>
    with SingleTickerProviderStateMixin<DirectionalRotation> {
  /// The animation controller controlling the [Transform.rotate] widget.
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController.unbounded(
      value: widget.angle / widget.scale,
      vsync: this,
    );

    _controller.addListener(() {
      if (mounted) setState(() {});
    });

    if (widget.onComplete != null) {
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete!();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.removeStatusListener((_) {});
    _controller.removeListener(() {});
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(DirectionalRotation oldWidget) {
    // Animate the rotation of the child if the angle has changed.
    if (widget.angle != oldWidget.angle) {
      // Factor the angle to a 0 to 1 scale and normalize it to the current
      // value of the animation controller.
      var angle = (widget.angle / widget.scale) + _controller.value.floor();

      // Determine which direction to rotate the child in.
      RotationDirection? direction;

      if (widget.direction == RotationDirection.furthest ||
          widget.direction == RotationDirection.closest) {
        final clockwise = (angle > _controller.value ? angle : angle + 1.0) -
            _controller.value;
        final counterClockwise = _controller.value -
            (angle < _controller.value ? angle : angle - 1.0);

        if (widget.direction == RotationDirection.furthest) {
          direction = clockwise >= counterClockwise
              ? RotationDirection.clockwise
              : RotationDirection.counterClockwise;
        } else {
          direction = clockwise <= counterClockwise
              ? RotationDirection.clockwise
              : RotationDirection.counterClockwise;
        }
      }

      direction ??= widget.direction;

      // Adjust the angle if needed to rotate in the defined direction.
      if (direction == RotationDirection.clockwise) {
        if (angle < _controller.value) angle += 1.0;
      } else {
        if (angle > _controller.value) angle -= 1.0;
      }

      // If [widget.factorDuration] is `true`, factor the duration by
      // the difference between the current angle and the new angle.
      if (widget.factorDuration) {
        final difference = (_controller.value - angle).abs();
        _controller.duration = Duration(
          milliseconds: (widget.duration.inMilliseconds * difference).round(),
        );
      }

      // Animate to the new angle.
      _controller.animateTo(angle, curve: widget.curve);
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: (_controller.value * 360) * (math.pi / 180),
      child: widget.child,
    );
  }
}
