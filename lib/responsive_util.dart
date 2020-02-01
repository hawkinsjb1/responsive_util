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
  /// MediaQuery.of(context).size references with the provided size during testing
  final void Function(Size) onResize;

  /// The widget we are resizing, typically a Scaffold.
  final Widget child;

  /// If false, the build function returns the child
  final bool enabled;

  ResponsiveUtil(
      {Key key, @required this.child, this.onResize, this.enabled = true});

  @override
  _ResponsiveUtil createState() => _ResponsiveUtil();
}

class _ResponsiveUtil extends State<ResponsiveUtil> {
  /// The distance from the device's right edge.
  double resizedWidth;

  /// The distance from the device's bottom edge.
  double resizedHeight;

  /// True if screen is being resized.
  bool pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (details) {
        setState(() {
          pressed = true;
        });
      },
      onPanEnd: (details) {
        setState(() {
          resizedWidth = (resizedWidth >
                  MediaQuery.of(context).size.width - kEdgeSnapPadding)
              ? null
              : resizedWidth;
          resizedHeight = (resizedHeight >
                  MediaQuery.of(context).size.height - kEdgeSnapPadding)
              ? null
              : resizedHeight;
          pressed = false;
        });
        widget.onResize(Size(resizedWidth, resizedHeight));
      },
      onPanUpdate: (details) {
        setState(() {
          resizedWidth = details.globalPosition.dx;
          resizedHeight = details.globalPosition.dy;
        });
        widget.onResize(Size(resizedWidth, resizedHeight));
      },
      child: Stack(
        children: <Widget>[
          SizedBox(
            height: (resizedHeight == null ||
                    resizedHeight > MediaQuery.of(context).size.height)
                ? MediaQuery.of(context).size.height
                : resizedHeight,
            width: (resizedWidth == null ||
                    resizedWidth > MediaQuery.of(context).size.width)
                ? MediaQuery.of(context).size.width
                : resizedWidth,
            child: widget.child,
          ),
          Positioned(
            left: resizedWidth ?? MediaQuery.of(context).size.width,
            top: resizedHeight ?? MediaQuery.of(context).size.height,
            child: cornerButton(context),
          ),
          Positioned(
            left: resizedWidth ?? MediaQuery.of(context).size.width,
            top: resizedHeight ?? MediaQuery.of(context).size.height,
            child: Transform.translate(
              offset: Offset((-kCornerButtonSize / 2) - 104,
                  (-kCornerButtonSize / 2) + 18),
              child: Material(
                color: Theme.of(context).primaryColor,
                child: (resizedWidth != null || resizedHeight != null)
                    ? Text(
                        'H: ${resizedHeight?.round() ?? MediaQuery.of(context).size.height.round()}    W: ${resizedWidth?.round() ?? MediaQuery.of(context).size.width.round()}',
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
      child: Container(
        width: kCornerButtonSize,
        height: kCornerButtonSize,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(kCornerButtonSize),
          color: Theme.of(context).primaryColor.withOpacity(pressed ? .5 : .3),
        ),
        child: Center(
          child: CircleAvatar(
            radius: kCornerButtonSize / 4,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        ),
      ),
    );
  }
}
