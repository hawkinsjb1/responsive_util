import 'package:flutter/material.dart';
import 'package:responsive_util/responsive_util.dart';

class CornerButton extends StatelessWidget {
  final ValueNotifier<bool> pressed;
  final ValueNotifier<Offset?> dragDetails;
  final Function onDoubleTap;
  CornerButton(this.pressed, this.dragDetails, this.onDoubleTap);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(-kCornerButtonSize / 2, -kCornerButtonSize / 2),
      child: GestureDetector(
        onDoubleTap: () => onDoubleTap(),
        onHorizontalDragStart: (details) => pressed.value = true,
        onVerticalDragStart: (details) => pressed.value = true,
        onHorizontalDragDown: (details) => pressed.value = true,
        onVerticalDragDown: (details) => pressed.value = true,
        onHorizontalDragCancel: () => pressed.value = false,
        onVerticalDragCancel: () => pressed.value = false,
        onHorizontalDragEnd: (details) => pressed.value = false,
        onVerticalDragEnd: (details) => pressed.value = false,
        onVerticalDragUpdate: (d) => dragDetails.value = d.globalPosition,
        onHorizontalDragUpdate: (d) => dragDetails.value = d.globalPosition,
        child: Container(
          width: kCornerButtonSize,
          height: kCornerButtonSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(kCornerButtonSize),
            color: Theme.of(context)
                .colorScheme
                .onPrimary
                .withOpacity(pressed.value ? .5 : .3),
          ),
          child: Center(
            child: CircleAvatar(
              radius: kCornerButtonSize / 4,
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
      ),
    );
  }
}
