library responsive_util;

import 'package:flutter/material.dart';

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
  final void Function(Size) onResize;

  /// child Widget to be resized, typically wraps a Scaffold.
  final Widget child;

  /// An alternative structure which directly provides updated [constraints]
  /// Using [child] around a [LayoutBuilder] would have the same effect
  final LayoutWidgetBuilder builder;

  /// Needed to properly determine a widget's global position in a scrollview.
  final ScrollController scrollController;
  
  final bool disabled;

  ResponsiveUtil(
      {Key key,
      this.child,
      this.builder,
      this.onResize,
      this.disabled = false,
      this.scrollController})
      : super(key: key) {
    assert((this.child != null || this.builder != null), 'You must provide a child widget or widget builder');
    assert(!(this.child != null && this.builder != null), 'You cannot provide both a child and widget builder');
  }

  @override
  _ResponsiveUtil createState() => _ResponsiveUtil();
}

class _ResponsiveUtil extends State<ResponsiveUtil> {
  /// The size to be updated by dragging.
  Size wrapperSize;

  /// The parent widget's max-constraint size
  Size screenSize;

  /// The position of the parent widget's bottom-right corner
  Offset globalPosition;

  /// True if finger is touching screen
  bool pressed = false;

  /// True is wrapperSize != screenSize
  bool shifted = false;

  GlobalKey wrapperKey = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => findWidgetPosition());
    super.initState();
  }

  void findWidgetPosition() {
    final renderObject = wrapperKey.currentContext?.findRenderObject();
    var translation = renderObject?.getTransformTo(null)?.getTranslation();
    if (translation != null && renderObject.paintBounds != null) {
      setState(() {
        screenSize = Size(
            renderObject.paintBounds.width, renderObject.paintBounds.height);
        wrapperSize = screenSize;
        globalPosition = Offset(renderObject.paintBounds.width + translation.x,
            renderObject.paintBounds.height + translation.y);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.disabled || screenSize == null
        ? LayoutBuilder(
            key: wrapperKey,
            builder: (context, constraints) {
              return (widget.child != null)
                  ? widget.child
                  : widget.builder(context, constraints);
            },
          )
        : Stack(
            children: <Widget>[
              SizedBox(
                height: wrapperSize.height,
                width: wrapperSize.width,
                child: (widget.child != null)
                    ? widget.child
                    : widget.builder(
                        context,
                        BoxConstraints(
                          maxWidth: wrapperSize.width,
                          maxHeight: wrapperSize.height,
                        ),
                      ),
              ),
              Positioned(
                left: wrapperSize?.width,
                top: wrapperSize?.height,
                child: cornerButton(context),
              ),
              if (shifted || pressed)
                Positioned(
                  left: wrapperSize.width,
                  top: wrapperSize.height,
                  child: Transform.translate(
                    offset: Offset((-kCornerButtonSize / 2) - 104,
                        (-kCornerButtonSize / 2) + 18),
                    child: Material(
                      color: Theme.of(context).primaryColor,
                      child: Text(
                        'H: ${wrapperSize.height.round()}    W: ${wrapperSize.width.round()}',
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

  Widget cornerButton(context) {
    return Transform.translate(
      offset: Offset(-kCornerButtonSize / 2, -kCornerButtonSize / 2),
      child: GestureDetector(
        onPanDown: (details) {
          setState(() {
            pressed = true;
          });
        },
        onPanEnd: (details) {
          var snapWidth = screenSize.width - kEdgeSnapPadding;
          var snapHeight = screenSize.height - kEdgeSnapPadding;
          setState(() {
            wrapperSize = Size(
              (wrapperSize.width > snapWidth)
                  ? screenSize.width
                  : wrapperSize.width,
              (wrapperSize.height > snapHeight)
                  ? screenSize.height
                  : wrapperSize.height,
            );
            pressed = false;
            shifted = wrapperSize != screenSize;
          });
          if (widget.onResize != null) widget.onResize(wrapperSize);
        },
        onPanUpdate: (details) {
          var newWidth = screenSize.width -
              (globalPosition.dx -
                  ((widget.scrollController?.position?.axis == Axis.horizontal)
                      ? widget.scrollController.position.pixels
                      : 0.0) -
                  details.globalPosition.dx);
          var newHeight = screenSize.height -
              (globalPosition.dy -
                  ((widget.scrollController?.position?.axis == Axis.vertical)
                      ? widget.scrollController.position.pixels
                      : 0.0) -
                  details.globalPosition.dy);
          setState(() {
            wrapperSize = Size((newWidth > 12) ? newWidth : 12,
                (newHeight > 12) ? newHeight : 12);
          });
          if (widget.onResize != null) widget.onResize(wrapperSize);
        },
        child: Container(
          width: kCornerButtonSize,
          height: kCornerButtonSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kCornerButtonSize),
            color:
                Theme.of(context).primaryColor.withOpacity(pressed ? .5 : .3),
          ),
          child: Center(
            child: CircleAvatar(
              radius: kCornerButtonSize / 4,
              backgroundColor: Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }
}
