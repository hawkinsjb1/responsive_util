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

  /// The widget we are resizing, typically a Scaffold.
  final Widget child;

  /// If True, the build function returns the child.
  final bool disabled;

  /// Needed to properly determine a widget's global position in a scrollview. 
  final ScrollController scrollController;

  ResponsiveUtil(
      {Key key, @required this.child, this.onResize, this.disabled = false, this.scrollController})
      : super(key: key) {
    assert(this.child != null);
  }

  @override
  _ResponsiveUtil createState() => _ResponsiveUtil();
}

class _ResponsiveUtil extends State<ResponsiveUtil> {
  /// The size to be updated by dragging.
  Size resizedSize;

  /// The parent widget's max-constraint size
  Size wrapperSize;

  /// The position of the parent widget's bottom-right corner
  Offset globalPosition;

  /// True if screen is being resized.
  bool pressed = false;

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
        wrapperSize = Size(
            renderObject.paintBounds.width, renderObject.paintBounds.height);
        globalPosition = Offset(renderObject.paintBounds.width + translation.x,
            renderObject.paintBounds.height + translation.y);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.disabled || wrapperSize == null
        ? LayoutBuilder(
            key: wrapperKey,
            builder: (context, snapshot) {
              return widget.child;
            },
          )
        : Container(
            child: Stack(
              children: <Widget>[
                SizedBox(
                  height: (resizedSize?.height == null)
                      ? wrapperSize.height
                      : resizedSize.height,
                  width: (resizedSize?.width == null)
                      ? wrapperSize.width
                      : resizedSize.width,
                  child: widget.child,
                ),
                Positioned(
                  left: resizedSize?.width ?? wrapperSize.width,
                  top: resizedSize?.height ?? wrapperSize.height,
                  child: cornerButton(context),
                ),
                Positioned(
                  left: resizedSize?.width ?? wrapperSize.width,
                  top: resizedSize?.height ?? wrapperSize.height,
                  child: Transform.translate(
                    offset: Offset((-kCornerButtonSize / 2) - 104,
                        (-kCornerButtonSize / 2) + 18),
                    child: Material(
                      color: Theme.of(context).primaryColor,
                      child: (resizedSize?.width != null ||
                              resizedSize?.height != null)
                          ? Text(
                              'H: ${resizedSize.height?.round() ?? wrapperSize.height.round()}    W: ${resizedSize.width?.round() ?? wrapperSize.width.round()}',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              ],
            ),
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
          setState(() {
            resizedSize = Size(
              (resizedSize.width > wrapperSize.width - kEdgeSnapPadding &&
                      resizedSize.width < wrapperSize.width + kEdgeSnapPadding)
                  ? null
                  : resizedSize.width,
              (resizedSize.height > wrapperSize.height - kEdgeSnapPadding &&
                      resizedSize.height <
                          wrapperSize.height + kEdgeSnapPadding)
                  ? null
                  : resizedSize.height,
            );

            pressed = false;
          });
          if (widget.onResize != null) widget.onResize(resizedSize);
        },
        onPanUpdate: (details) {
          var newWidth = wrapperSize.width -
              (globalPosition.dx - ((widget.scrollController?.position?.axis == Axis.horizontal) ? widget.scrollController.position.pixels : 0.0) - details.globalPosition.dx);
          var newHeight = wrapperSize.height -
              (globalPosition.dy - ((widget.scrollController?.position?.axis == Axis.vertical) ? widget.scrollController.position.pixels : 0.0) - details.globalPosition.dy);
          setState(() {
            resizedSize = Size((newWidth > 12) ? newWidth : 12,
                (newHeight > 12) ? newHeight : 12);
          });
          if (widget.onResize != null) widget.onResize(resizedSize);
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
