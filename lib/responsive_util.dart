library responsive_util;

import 'package:flutter/material.dart';
import 'package:responsive_util/corner_button.dart';

/// A wrapper that provides draggable manipulation of
/// a widget's size to test it's responsive design.

/// Offsets under this value will snap to the device's edge
const double kEdgeSnapPadding = 20.0;

/// The size of the [cornerButton] used for resizing.
const double kCornerButtonSize = 100.0;

class ResponsiveUtil extends StatefulWidget {
  /// A callback that provides adjusted window size.
  ///
  /// Layouts with conditionals using a device's screen size should replace
  /// wrapperSize references with the provided size during testing
  final void Function(Size)? onResize;

  /// child Widget to be resized, typically wraps a Scaffold.
  final Widget? child;

  /// An alternative structure which directly provides updated [constraints]
  /// Using [child] around a [LayoutBuilder] would have the same effect
  final LayoutWidgetBuilder? builder;

  /// Needed to properly determine a widget's global position in a scrollview.
  final ScrollController? scrollController;

  final bool disabled;

  ResponsiveUtil(
      {Key? key,
      this.child,
      this.builder,
      this.onResize,
      this.disabled = false,
      this.scrollController})
      : super(key: key) {
    assert((this.child != null || this.builder != null),
        'You must provide a child widget or widget builder');
    assert(!(this.child != null && this.builder != null),
        'You cannot provide both a child and widget builder');
  }

  @override
  _ResponsiveUtil createState() => _ResponsiveUtil();
}

class _ResponsiveUtil extends State<ResponsiveUtil>
    with WidgetsBindingObserver {
  /// The size to be updated by dragging.
  Size? wrapperSize;

  /// The parent widget's max-constraint size
  Size? originalSize;

  /// The position of the parent widget's bottom-right corner
  Offset? globalPosition;

  /// True if findWidgetPosition() successfully executed
  bool initialized = false;

  final GlobalKey wrapperKey = GlobalKey();
  final ValueNotifier<bool> pressed = ValueNotifier(false);
  final ValueNotifier<Offset?> dragDetails = ValueNotifier(null);

  double get dragXDistance =>
      originalSize!.width -
      (globalPosition!.dx -
          ((widget.scrollController != null &&
                  widget.scrollController?.position.axis == Axis.horizontal)
              ? widget.scrollController!.position.pixels
              : 0.0) -
          dragDetails.value!.dx);

  double get dragYDistance =>
      originalSize!.height -
      (globalPosition!.dy -
          ((widget.scrollController != null &&
                  widget.scrollController?.position.axis == Axis.vertical)
              ? widget.scrollController!.position.pixels
              : 0.0) -
          dragDetails.value!.dy);

  Size get draggedWrapper => Size(dragXDistance, dragYDistance);

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => findWidgetPosition());

    pressed.addListener(() {
      if (!pressed.value && initialized) {
        var diffX = (originalSize!.width - wrapperSize!.width).abs();
        var diffY = (originalSize!.height - wrapperSize!.height).abs();
        setState(() {
          wrapperSize = Size(
            (diffX <= kEdgeSnapPadding)
                ? originalSize!.width
                : wrapperSize!.width,
            (diffY <= kEdgeSnapPadding)
                ? originalSize!.height
                : wrapperSize!.height,
          );
        });
        if (widget.onResize != null) widget.onResize!(wrapperSize!);
      }
      setState(() {});
    });
    dragDetails.addListener(() {
      if (!initialized || dragDetails.value == null) return;
      if (!pressed.value) pressed.value = true;
      setState(() => wrapperSize = draggedWrapper);
      if (widget.onResize != null) widget.onResize!(wrapperSize!);
    });
    super.initState();
  }

  reset() => {
        setState(() => {
              wrapperSize = Size(originalSize!.width, originalSize!.height),
              pressed.value = false,
            }),
      };

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void findWidgetPosition() {
    final renderObject = wrapperKey.currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      setState(() {
        originalSize = Size(
            renderObject!.paintBounds.width, renderObject.paintBounds.height);
        wrapperSize = originalSize;
        globalPosition = Offset(renderObject.paintBounds.width + translation.x,
            renderObject.paintBounds.height + translation.y);
        initialized = true;
      });
    }
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => findWidgetPosition(),
    );
    super.didChangeMetrics();
  }

  @override
  Widget build(BuildContext context) {
    return widget.disabled || !initialized
        ? LayoutBuilder(
            key: wrapperKey,
            builder: (context, constraints) {
              return widget.child != null
                  ? widget.child!
                  : widget.builder!(context, constraints);
            },
          )
        : Stack(
            key: wrapperKey,
            children: <Widget>[
              SizedBox(
                height: wrapperSize!.height,
                width: wrapperSize!.width,
                child: widget.child != null
                    ? widget.child
                    : widget.builder!(
                        context,
                        BoxConstraints(
                          maxWidth: wrapperSize!.width,
                          maxHeight: wrapperSize!.height,
                        ),
                      ),
              ),
              Positioned(
                left: wrapperSize!.width,
                top: wrapperSize!.height,
                child: CornerButton(pressed, dragDetails, () => reset()),
              ),
              if (wrapperSize != originalSize)
                Positioned(
                  left: wrapperSize!.width,
                  top: wrapperSize!.height,
                  child: Transform.translate(
                    offset: Offset((-kCornerButtonSize / 2) - 104,
                        (-kCornerButtonSize / 2) + 18),
                    child: Material(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'H: ${wrapperSize!.height.round()}    W: ${wrapperSize!.width.round()}',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
  }
}
