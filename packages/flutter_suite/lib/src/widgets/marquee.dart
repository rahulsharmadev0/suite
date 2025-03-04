import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_suite/flutter_suite.dart';

/// A widget that repeats text and automatically scrolls it infinitely.
///
/// ## Sample code
///
/// This is a minimalistic example:
///
/// ```dart
/// Marquee(
///   text: 'There once was a boy who told this story about a boy: "',
/// )
/// ```
///
/// And here's a piece of code that makes full use of the marquee's
/// customizability:
///
/// ```dart
/// Marquee(
///   text: 'Some sample text that takes some space.',
///   style: TextStyle(fontWeight: FontWeight.bold),
///   scrollAxis: Axis.horizontal,
///   blankSpace: 20.0,
///   velocity: 100.0,
///   pauseAfterRound: Duration(seconds: 1),
///   startPadding: 10.0,
///   accelerationDuration: Duration(seconds: 1),
///   accelerationCurve: Curves.linear,
///   decelerationDuration: Duration(milliseconds: 500),
///   decelerationCurve: Curves.easeOut,
/// )
/// ```
///
/// See also:
///
/// * [ListView.builder], where by returning the same widget to the builder
///   every time, a similar result can be achieved, just without the automatic
///   scrolling and manual scrolling enabled.
class Marquee extends StatefulWidget {
  Marquee({
    super.key,
    this.text,
    this.maxheight,
    this.widget,
    this.style,
    this.textScaler,
    this.textDirection = TextDirection.ltr,
    this.scrollAxis = Axis.horizontal,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.blankSpace = 0.0,
    this.velocity = 50.0,
    this.startAfter = Duration.zero,
    this.pauseAfterRound = Duration.zero,
    this.showFadingOnlyWhenScrolling = true,
    this.fadingEdgeStartFraction = 0.0,
    this.fadingEdgeEndFraction = 0.0,
    this.numberOfRounds,
    this.startPadding = 0.0,
    this.accelerationDuration = Duration.zero,
    Curve accelerationCurve = Curves.decelerate,
    this.decelerationDuration = Duration.zero,
    Curve decelerationCurve = Curves.decelerate,
    this.onDone,
  })  : assert(text == null || widget == null, "text and widget both not null."),
        assert(!blankSpace.isNaN),
        assert(blankSpace >= 0, "The blankSpace needs to be positive or zero."),
        assert(blankSpace.isFinite),
        assert(!velocity.isNaN),
        assert(velocity != 0.0, "The velocity cannot be zero."),
        assert(velocity.isFinite),
        assert(
          pauseAfterRound >= Duration.zero,
          "The pauseAfterRound cannot be negative as time travel isn't "
          "invented yet.",
        ),
        assert(
          fadingEdgeStartFraction >= 0 && fadingEdgeStartFraction <= 1,
          "The fadingEdgeGradientFractionOnStart value should be between 0 and "
          "1, inclusive",
        ),
        assert(
          fadingEdgeEndFraction >= 0 && fadingEdgeEndFraction <= 1,
          "The fadingEdgeGradientFractionOnEnd value should be between 0 and "
          "1, inclusive",
        ),
        assert(numberOfRounds == null || numberOfRounds > 0),
        assert(
          accelerationDuration >= Duration.zero,
          "The accelerationDuration cannot be negative as time travel isn't "
          "invented yet.",
        ),
        assert(
          decelerationDuration >= Duration.zero,
          "The decelerationDuration must be positive or zero as time travel "
          "isn't invented yet.",
        ),
        accelerationCurve = _IntegralCurve(accelerationCurve),
        decelerationCurve = _IntegralCurve(decelerationCurve);

  final String? text;

  final Widget? widget;

  final double? maxheight;

  final TextStyle? style;

  final TextScaler? textScaler;

  /// The text direction of the text to be displayed.
  final TextDirection textDirection;

  /// The scroll axis.
  ///
  /// If set to [Axis.horizontal], the default scrolling direction is to the
  /// right.
  /// If set to [Axis.vertical], the default scrolling direction is to the
  /// bottom.
  final Axis scrollAxis;

  final CrossAxisAlignment crossAxisAlignment;

  /// The extend of blank space to display between instances of the text.
  ///
  /// ## Sample code
  ///
  /// In this example, there's 300 density pixels between the text instances:
  ///
  /// ```dart
  /// Marquee(
  ///   blankSpace: 300.0,
  ///   child: 'Wait for it...',
  /// )
  /// ```
  final double blankSpace;

  /// The scrolling velocity in pixels per second.
  ///
  /// If a negative velocity is provided, the marquee scrolls in the reverse
  /// direction (to the right for horizontal marquees and to the top for
  /// vertical ones).
  ///
  final double velocity;

  /// Start scrolling after this duration after the widget is first displayed.
  ///
  /// ## Sample code
  ///
  /// This [Marquee] starts scrolling one second after being displayed.
  ///
  /// ```dart
  /// Marquee(
  ///   startAfter: const Duration(seconds: 1),
  ///   text: 'Starts one second after being displayed.',
  /// )
  /// ```
  final Duration startAfter;

  /// After each round, a pause of this duration occurs.
  ///
  /// ## Sample code
  ///
  /// After every round, this marquee pauses for one second.
  ///
  /// ```dart
  /// Marquee(
  ///   pauseAfterRound: const Duration(seconds: 1),
  ///   text: 'Pausing for some time after every round.',
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [accelerationDuration] and [decelerationDuration] to make the
  ///   transitions between moving and paused state smooth.
  /// * [accelerationCurve] and [decelerationCurve] to have more control about
  ///   how the transition between moving and pausing state occur.
  final Duration pauseAfterRound;

  /// When the text scrolled around [numberOfRounds] times, it will stop scrolling
  /// `null` indicates there is no limit
  ///
  /// ## Sample code
  ///
  /// This marquee stops after 3 rounds
  ///
  /// ```dart
  /// Marquee(
  ///   numberOfRounds:3,
  ///   text: 'Stopping after three rounds.'
  /// )
  /// ```
  final int? numberOfRounds;

  /// Whether the fading edge should only appear while the text is
  /// scrolling.
  ///
  /// ## Sample code
  ///
  /// This marquee will only show the fade while scrolling.
  ///
  /// ```dart
  /// Marquee(
  ///   showFadingOnlyWhenScrolling: true,
  ///   fadingEdgeStartFraction: 0.1,
  ///   fadingEdgeEndFraction: 0.1,
  ///   text: 'Example text.',
  /// )
  /// ```
  final bool showFadingOnlyWhenScrolling;

  /// The fraction of the [Marquee] that will be faded on the left or top.
  /// By default, there won't be any fading.
  ///
  /// ## Sample code
  ///
  /// This marquee fades the edges while scrolling
  ///
  /// ```dart
  /// Marquee(
  ///   showFadingOnlyWhenScrolling: true,
  ///   fadingEdgeStartFraction: 0.1,
  ///   fadingEdgeEndFraction: 0.1,
  ///   text: 'Example text.',
  /// )
  /// ```
  final double fadingEdgeStartFraction;

  /// The fraction of the [Marquee] that will be faded on the right or down.
  /// By default, there won't be any fading.
  ///
  /// ## Sample code
  ///
  /// This marquee fades the edges while scrolling
  ///
  /// ```dart
  /// Marquee(
  ///   showFadingOnlyWhenScrolling: true,
  ///   fadingEdgeStartFraction: 0.1,
  ///   fadingEdgeEndFraction: 0.1,
  ///   text: 'Example text.',
  /// )
  /// ```
  final double fadingEdgeEndFraction;

  /// A padding for the resting position.
  ///
  /// In between rounds, the marquee stops at this position. This parameter is
  /// especially useful if the marquee pauses after rounds and some other
  /// widgets are stacked on top of the marquee and block the sides, like
  /// fading gradients.
  ///
  /// ## Sample code
  ///
  /// ```dart
  /// Marquee(
  ///   startPadding: 20.0,
  ///   pauseAfterRound: Duration(seconds: 1),
  ///   text: "During pausing, this text is shifted 20 pixel to the right."
  /// )
  /// ```
  final double startPadding;

  /// How long the acceleration takes.
  ///
  /// At the start of each round, the scrolling speed gains momentum for this
  /// duration. This parameter is only useful if you embrace a pause after
  /// every round.
  ///
  /// ## Sample code
  ///
  /// A marquee that slowly accelerates in two seconds.
  ///
  /// ```dart
  /// Marquee(
  ///   accelerationDuration: Duration(seconds: 2),
  ///   text: 'Gaining momentum in two seconds.'
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [accelerationCurve] to define a custom curve for accelerating.
  /// * [decelerationDuration], the equivalent for decelerating.
  final Duration accelerationDuration;

  /// The acceleration at the start of each round.
  ///
  /// At the start of each round, the acceleration is defined by this curve
  /// where 0.0 stands for not moving and 1.0 for the target [velocity].
  /// Notice that it's useless to set the curve if you leave the
  /// [accelerationDuration] at the default of [Duration.zero].
  /// Also notice that you don't provide the scroll positions, but the actual
  /// velocity, so this curve gets integrated.
  ///
  /// ## Sample code
  ///
  /// A marquee that accelerates with a custom curve.
  ///
  /// ```dart
  /// Marquee(
  ///   accelerationDuration: Duration(seconds: 1),
  ///   accelerationCurve: Curves.easeInOut,
  ///   text: 'Accelerating with a custom curve.'
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [accelerationDuration] to change the duration of the acceleration.
  /// * [decelerationCurve], the equivalent for decelerating.
  final _IntegralCurve accelerationCurve;

  /// How long the deceleration takes.
  ///
  /// At the end of each round, the scrolling speed gradually comes to a
  /// halt in this duration. This parameter is only useful if you embrace a
  /// pause after every round.
  final Duration decelerationDuration;

  /// The deceleration at the end of each round.
  ///
  /// At the end of each round, the deceleration is defined by this curve where
  /// 0.0 stands for not moving and 1.0 for the target [velocity].
  /// Notice that it's useless to set this curve if you leave the
  /// [accelerationDuration] at the default of [Duration.zero].
  /// Also notice that you don't provide the scroll position, but the actual
  /// velocity, so this curve gets integrated.
  ///
  /// ## Sample code
  ///
  /// A marquee that decelerates with a custom curve.
  ///
  /// ```dart
  /// Marquee(
  ///   decelerationDuration: Duration(seconds: 1),
  ///   decelerationCurve: Curves.easeInOut,
  ///   text: 'Decelerating with a custom curve.'
  /// )
  /// ```
  ///
  /// See also:
  ///
  /// * [decelerationDuration] to change the duration of the acceleration.
  /// * [accelerationCurve], the equivalent for decelerating.
  final _IntegralCurve decelerationCurve;

  /// This function will be called if [numberOfRounds] is set and the [Marquee]
  /// finished scrolled the specified number of rounds.
  final VoidCallback? onDone;

  @override
  State<StatefulWidget> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  /// The controller for the scrolling behavior.
  final ScrollController _controller = ScrollController();
  double? _maxHeight;
  // The scroll positions at various scrolling phases.
  late double _startPosition; // At the start, before accelerating.
  late double _accelerationTarget; // After accelerating, before moving linearly.
  late double _linearTarget; // After moving linearly, before decelerating.
  late double _decelerationTarget; // After decelerating.

  // The durations of various scrolling phases.
  late Duration _totalDuration;

  Duration get _accelerationDuration => widget.accelerationDuration;
  Duration? _linearDuration; // The duration of linearly scrolling.
  Duration get _decelerationDuration => widget.decelerationDuration;

  /// A timer that is fired at the start of each round.
  bool _running = false;
  bool _isOnPause = false;
  int _roundCounter = 0;
  bool get isDone => widget.numberOfRounds == null ? false : widget.numberOfRounds == _roundCounter;
  bool get showFading => !widget.showFadingOnlyWhenScrolling ? true : !_isOnPause;

  @override
  void initState() {
    super.initState();
    _maxHeight = widget.maxheight;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_running) {
        _running = true;
        if (_controller.hasClients) {
          _controller.jumpTo(_startPosition);
          await Future<void>.delayed(widget.startAfter);
          Future.doWhile(_scroll);
        }
      }
    });
  }

  Future<bool> _scroll() async {
    await _makeRoundTrip();
    if (isDone && widget.onDone != null) {
      widget.onDone!();
    }
    return _running && !isDone && _controller.hasClients;
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget as Marquee);
  }

  @override
  void dispose() {
    _running = false;
    super.dispose();
  }

  /// Calculates all necessary values for animating, then starts the animation.
  void _initialize(BuildContext context) {
    // Calculate lengths (amount of pixels that each phase needs).

    final totalLength =
        (widget.widget != null ? context.widthOf(100) : _getTextWidth(context)) + widget.blankSpace;

    final accelerationLength =
        widget.accelerationCurve.integral * widget.velocity * _accelerationDuration.inMilliseconds / 1000.0;
    final decelerationLength =
        widget.decelerationCurve.integral * widget.velocity * _decelerationDuration.inMilliseconds / 1000.0;
    final linearLength =
        (totalLength - accelerationLength.abs() - decelerationLength.abs()) * (widget.velocity > 0 ? 1 : -1);

    // Calculate scroll positions at various scrolling phases.
    _startPosition = 2 * totalLength - widget.startPadding;
    _accelerationTarget = _startPosition + accelerationLength;
    _linearTarget = _accelerationTarget + linearLength;
    _decelerationTarget = _linearTarget + decelerationLength;

    // Calculate durations for the phases.
    _totalDuration = _accelerationDuration +
        _decelerationDuration +
        Duration(milliseconds: (linearLength / widget.velocity * 1000).toInt());
    _linearDuration = _totalDuration - _accelerationDuration - _decelerationDuration;

    assert(
      _totalDuration > Duration.zero,
      "With the given values, the total duration for one round would be "
      "negative. As time travel isn't invented yet, this shouldn't happen.",
    );
    assert(
      _linearDuration! >= Duration.zero,
      "Acceleration and deceleration phase overlap. To fix this, try a "
      "combination of these approaches:\n"
      "* Make the text longer, so there's more room to animate within.\n"
      "* Shorten the accelerationDuration or decelerationDuration.\n"
      "* Decrease the velocity, so the duration to animate within is longer.\n",
    );
  }

  /// Causes the controller to scroll one round.
  Future<void> _makeRoundTrip() async {
    // Reset the controller, then accelerate, move linearly and decelerate.
    if (!_controller.hasClients) return;
    _controller.jumpTo(_startPosition);
    if (!_running) return;

    await _accelerate();
    if (!_running) return;

    await _moveLinearly();
    if (!_running) return;

    await _decelerate();

    _roundCounter++;

    if (!_running || !mounted) return;

    if (widget.pauseAfterRound > Duration.zero) {
      setState(() => _isOnPause = true);

      await Future.delayed(widget.pauseAfterRound);

      if (!mounted || isDone) return;
      setState(() => _isOnPause = false);
    }
  }

  // Methods that animate the controller.
  Future<void> _accelerate() async {
    await _animateTo(
      _accelerationTarget,
      _accelerationDuration,
      widget.accelerationCurve,
    );
  }

  Future<void> _moveLinearly() async {
    await _animateTo(_linearTarget, _linearDuration, Curves.linear);
  }

  Future<void> _decelerate() async {
    await _animateTo(
      _decelerationTarget,
      _decelerationDuration,
      widget.decelerationCurve.flipped,
    );
  }

  /// Helping method that either animates to the given target position or jumps
  /// right to it if the duration is Duration.zero.
  Future<void> _animateTo(
    double? target,
    Duration? duration,
    Curve curve,
  ) async {
    if (!_controller.hasClients) return;
    if (duration! > Duration.zero) {
      await _controller.animateTo(target!, duration: duration, curve: curve);
    } else {
      _controller.jumpTo(target!);
    }
  }

  /// Returns the width of the text.
  double _getTextWidth(BuildContext context) {
    final span = Text(widget.text!, style: widget.style);
    const constraints = BoxConstraints(maxWidth: double.infinity);
    final richTextWidget = span.build(context) as RichText;
    final renderObject = richTextWidget.createRenderObject(context);
    renderObject.layout(constraints);
    _maxHeight = renderObject.size.height;
    return renderObject.size.width;
  }

  @override
  Widget build(BuildContext context) {
    _initialize(context);

    Alignment? alignment;
    bool isHorizontal = widget.scrollAxis == Axis.horizontal;
    switch (widget.crossAxisAlignment) {
      case CrossAxisAlignment.start:
        alignment = isHorizontal ? Alignment.topCenter : Alignment.centerLeft;
        break;
      case CrossAxisAlignment.end:
        alignment = isHorizontal ? Alignment.bottomCenter : Alignment.centerRight;
        break;
      case CrossAxisAlignment.center:
        alignment = Alignment.center;
        break;
      case CrossAxisAlignment.stretch:
      case CrossAxisAlignment.baseline:
        alignment = null;
        break;
    }
    var text = Text(widget.text ?? '', style: widget.style, textScaler: widget.textScaler);

    var child = ListView.builder(
      shrinkWrap: true,
      controller: _controller,
      scrollDirection: widget.scrollAxis,
      reverse: widget.textDirection == TextDirection.rtl,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (_, i) {
        final child = i.isEven ? (widget.widget ?? text) : _buildBlankSpace();
        return alignment == null ? child : Align(alignment: alignment, child: child);
      },
    );

    return _maxHeight != null
        ? SizedBox(height: _maxHeight, child: child)
        : _prototypeHeight(
            prototype: widget.widget ?? text,
            listView: child,
          );
  }

  /// Builds the blank space between children.
  Widget _buildBlankSpace() {
    return SizedBox(
      width: widget.scrollAxis == Axis.horizontal ? widget.blankSpace : null,
      height: widget.scrollAxis == Axis.vertical ? widget.blankSpace : null,
    );
  }

  Widget _prototypeHeight({
    required Widget prototype,
    required Widget listView,
  }) =>
      Stack(
        children: [
          IgnorePointer(
            child: prototype.opacity(0),
          ),
          const SizedBox(width: double.infinity),
          Positioned.fill(child: listView),
        ],
      );
}

/// A curve that represents the integral of another curve.
///
/// The constructor takes an other curve and calculates the integral. The
/// values of this curve are then being normalized onto the interval from 0 to
/// 1, but the integration value can always be obtained using the [interval]
/// property.
class _IntegralCurve extends Curve {
  /// Delta for integrating.
  static double delta = 0.01;

  const _IntegralCurve._(this.original, this.integral, this._values);

  /// The original curve that was integrated.
  final Curve original;

  /// The integral value.
  final double integral;

  /// Cached cumulative values of the integral.
  final Map<double, double> _values;

  /// The constructor that takes the [original] curve.
  factory _IntegralCurve(Curve original) {
    double integral = 0.0;
    final values = <double, double>{};

    for (double t = 0.0; t <= 1.0; t += delta) {
      integral += original.transform(t) * delta;
      values[t] = integral;
    }
    values[1.0] = integral;

    // Normalize.
    for (final double t in values.keys) {
      values[t] = values[t]! / integral;
    }

    return _IntegralCurve._(original, integral, values);
  }

  /// Transforms a value to the normalized integrated value of the [original]
  /// curve.
  @override
  double transform(double t) {
    if (t < 0) return 0.0;
    for (final key in _values.keys) {
      if (key > t) return _values[key]!;
    }
    return 1.0;
  }
}
