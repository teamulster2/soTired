import 'dart:async';

import 'package:flutter/material.dart';

/// This class holds the box of a spatial span test that is highlighted when the box is pressed or shown.
class SpatialSpanTaskBox extends StatelessWidget {
  const SpatialSpanTaskBox(
      {required this.onTap, required this.primary, Key? key})
      : super(key: key);
  final VoidCallback onTap;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final ValueNotifier<Color> color =
        ValueNotifier<Color>(Theme.of(context).colorScheme.secondary);
    if (primary) {
      color.value = Theme.of(context).primaryColor;
    }

    return ValueListenableBuilder<Color>(
      valueListenable: color,
      builder: (BuildContext context, Color value, Widget? child) =>
          GestureDetector(
              child: Container(
                color: color.value,
              ),
              onTap: () {
                onTap();

                color.value = Theme.of(context).primaryColor;
                Timer(const Duration(milliseconds: 500), () {
                  color.value = Theme.of(context).colorScheme.secondary;
                });
              }),
    );
  }
}
