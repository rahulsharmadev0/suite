import 'package:flutter/material.dart';
import 'dart:math' show min, max;
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';

/// Builder called during layout to allow the header's content to be animated or styled based
/// on the amount of stickiness the header has.
///
/// [context] for your build operation.
///
/// [stuckAmount] will have the value of:
/// ```
///   0.0 <= value <= 1.0: about to be stuck
///          0.0 == value: at top
///  -1.0 >= value >= 0.0: past stuck
/// ```
///
typedef StickyHeaderWidgetBuilder = Widget Function(
    BuildContext context, double stuckAmount);

/// Called every layout to provide the amount of stickyness a header is in.
/// This lets the widgets animate their content and provide feedback.
///
typedef RenderStickyHeaderCallback = void Function(double stuckAmount);

/// Stick Header Widget
///
/// Will layout the [header] above the [content] unless the [overlapHeaders] boolean is set to true.
/// The [header] will remain stuck to the top of its parent [Scrollable] content.
///
/// Place this widget inside a [ListView], [GridView], [CustomScrollView], [SingleChildScrollView] or similar.
///
class SuiteStickyHeader extends MultiChildRenderObjectWidget {
  /// Constructs a new [SuiteStickyHeader] widget.
  SuiteStickyHeader({
    super.key,
    required this.header,
    required this.content,
    this.overlapHeaders = false,
    this.controller,
    this.callback,
  }) : super(
          children: [content, header],
        );

  /// Header to be shown at the top of the parent [Scrollable] content.
  final Widget header;

  /// Content to be shown below the header.
  final Widget content;

  /// If true, the header will overlap the Content.
  final bool overlapHeaders;

  /// Optional [ScrollController] that will be used by the widget instead of the default inherited one.
  final ScrollController? controller;

  /// Optional callback with stickiness value. If you think you need this, then you might want to
  /// consider using [StickyHeaderBuilder] instead.
  final RenderStickyHeaderCallback? callback;

  @override
  _RenderStickyHeader createRenderObject(BuildContext context) {
    final scrollPosition = controller?.position ?? Scrollable.of(context).position;
    return _RenderStickyHeader(
      scrollPosition: scrollPosition,
      callback: callback,
      overlapHeaders: overlapHeaders,
    );
  }

  @override
  void updateRenderObject(BuildContext context, _RenderStickyHeader renderObject) {
    final scrollPosition = controller?.position ?? Scrollable.of(context).position;
    renderObject
      ..scrollPosition = scrollPosition
      ..callback = callback
      ..overlapHeaders = overlapHeaders;
  }
}

/// Sticky Header Builder Widget.
///
/// The same as [SuiteStickyHeader] but instead of supplying a Header view, you supply a [builder] that
/// constructs the header with the appropriate stickyness.
///
/// Place this widget inside a [ListView], [GridView], [CustomScrollView], [SingleChildScrollView] or similar.
///
class StickyHeaderBuilder extends StatefulWidget {
  /// Constructs a new [StickyHeaderBuilder] widget.
  const StickyHeaderBuilder({
    super.key,
    required this.builder,
    required this.content,
    this.overlapHeaders = false,
    this.controller,
  });

  /// Called when the sticky amount changes for the header.
  /// This builder must not return null.
  final StickyHeaderWidgetBuilder builder;

  /// Content to be shown below the header.
  final Widget content;

  /// If true, the header will overlap the Content.
  final bool overlapHeaders;

  /// Optional [ScrollController] that will be used by the widget instead of the default inherited one.
  final ScrollController? controller;

  @override
  State<StickyHeaderBuilder> createState() => _StickyHeaderBuilderState();
}

class _StickyHeaderBuilderState extends State<StickyHeaderBuilder> {
  double? _stuckAmount;

  @override
  Widget build(BuildContext context) {
    return SuiteStickyHeader(
      overlapHeaders: widget.overlapHeaders,
      header: LayoutBuilder(
        builder: (context, _) => widget.builder(context, _stuckAmount ?? 0.0),
      ),
      content: widget.content,
      controller: widget.controller,
      callback: (double stuckAmount) {
        if (_stuckAmount != stuckAmount) {
          _stuckAmount = stuckAmount;
          WidgetsBinding.instance.endOfFrame.then((_) {
            if (mounted) {
              setState(() {});
            }
          });
        }
      },
    );
  }
}

//------------------------------------------RenderObject for StickyHeader widget------------------------------------------------
//
// Monitors given [Scrollable] and adjusts its layout based on its offset to
// the scrollables' [RenderObject]. The header will be placed above content
// unless overlapHeaders is set to true. The supplied callback will be used
// to report  the amount of stickiness the header has.
//
//------------------------------------------------------------------------------------------------------------------------------
class _RenderStickyHeader extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, MultiChildLayoutParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, MultiChildLayoutParentData> {
  RenderStickyHeaderCallback? _callback;
  ScrollPosition _scrollPosition;
  bool _overlapHeaders;

  _RenderStickyHeader({
    required ScrollPosition scrollPosition,
    RenderStickyHeaderCallback? callback,
    bool overlapHeaders = false,
    RenderBox? header,
    RenderBox? content,
  })  : _scrollPosition = scrollPosition,
        _callback = callback,
        _overlapHeaders = overlapHeaders {
    if (content != null) add(content);
    if (header != null) add(header);
  }

  set scrollPosition(ScrollPosition newValue) {
    if (_scrollPosition == newValue) {
      return;
    }
    final ScrollPosition oldValue = _scrollPosition;
    _scrollPosition = newValue;
    markNeedsLayout();
    if (attached) {
      oldValue.removeListener(markNeedsLayout);
      newValue.addListener(markNeedsLayout);
    }
  }

  set callback(RenderStickyHeaderCallback? newValue) {
    if (_callback == newValue) {
      return;
    }
    _callback = newValue;
    markNeedsLayout();
  }

  set overlapHeaders(bool newValue) {
    if (_overlapHeaders == newValue) {
      return;
    }
    _overlapHeaders = newValue;
    markNeedsLayout();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _scrollPosition.addListener(markNeedsLayout);
  }

  @override
  void detach() {
    _scrollPosition.removeListener(markNeedsLayout);
    super.detach();
  }

  // short-hand to access the child RenderObjects
  RenderBox get _headerBox => lastChild!;

  RenderBox get _contentBox => firstChild!;

  double get devicePixelRatio =>
      ui.PlatformDispatcher.instance.implicitView?.devicePixelRatio ?? 1.5;

  double roundToNearestPixel(double offset) {
    return (offset * devicePixelRatio).roundToDouble() / devicePixelRatio;
  }

  @override
  void performLayout() {
    // layout both header and content widget
    final childConstraints = constraints.loosen();
    _headerBox.layout(childConstraints, parentUsesSize: true);
    _contentBox.layout(childConstraints, parentUsesSize: true);

    final headerHeight = roundToNearestPixel(_headerBox.size.height);
    final contentHeight = roundToNearestPixel(_contentBox.size.height);

    // determine size of ourselves based on content widget
    final width = constraints.constrainWidth(
      max(constraints.minWidth, _contentBox.size.width),
    );
    final height = constraints.constrainHeight(
      max(constraints.minHeight,
          _overlapHeaders ? contentHeight : headerHeight + contentHeight),
    );
    size = Size(width, height);

    // place content underneath header
    final contentParentData = _contentBox.parentData as MultiChildLayoutParentData;
    contentParentData.offset = Offset(0.0, _overlapHeaders ? 0.0 : headerHeight);

    // determine by how much the header should be stuck to the top
    final double stuckOffset = roundToNearestPixel(determineStuckOffset());

    // place header over content relative to scroll offset
    final double maxOffset = height - headerHeight;
    final headerParentData = _headerBox.parentData as MultiChildLayoutParentData;
    headerParentData.offset = Offset(0.0, max(0.0, min(-stuckOffset, maxOffset)));

    // report to widget how much the header is stuck.
    if (_callback != null) {
      final stuckAmount =
          max(min(headerHeight, stuckOffset), -headerHeight) / headerHeight;
      _callback!(stuckAmount);
    }
  }

  double determineStuckOffset() {
    final scrollBox = _scrollPosition.context.notificationContext!.findRenderObject();
    if (scrollBox?.attached ?? false) {
      try {
        return localToGlobal(Offset.zero, ancestor: scrollBox).dy;
      } catch (e) {
        // ignore and fall-through and return 0.0
      }
    }
    return 0.0;
  }

  @override
  void setupParentData(RenderObject child) {
    super.setupParentData(child);
    if (child.parentData is! MultiChildLayoutParentData) {
      child.parentData = MultiChildLayoutParentData();
    }
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _contentBox.getMinIntrinsicWidth(height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _contentBox.getMaxIntrinsicWidth(height);
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    return _overlapHeaders
        ? _contentBox.getMinIntrinsicHeight(width)
        : (_headerBox.getMinIntrinsicHeight(width) +
            _contentBox.getMinIntrinsicHeight(width));
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    return _overlapHeaders
        ? _contentBox.getMaxIntrinsicHeight(width)
        : (_headerBox.getMaxIntrinsicHeight(width) +
            _contentBox.getMaxIntrinsicHeight(width));
  }

  @override
  double? computeDistanceToActualBaseline(TextBaseline baseline) {
    return defaultComputeDistanceToHighestActualBaseline(baseline);
  }

  @override
  bool hitTestChildren(HitTestResult result, {required Offset position}) {
    return defaultHitTestChildren(result as BoxHitTestResult, position: position);
  }

  @override
  bool get isRepaintBoundary => true;

  @override
  void paint(PaintingContext context, Offset offset) {
    defaultPaint(context, offset);
  }
}
