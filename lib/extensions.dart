import 'package:flutter/material.dart';

extension LayoutUtils on Widget {
  Widget withPadding([EdgeInsetsGeometry padding = const EdgeInsets.all(8)]) {
    return Padding(padding: padding, child: this);
  }

  Widget withSize({double? width, double? height}) {
    return SizedBox(width: width, height: height, child: this);
  }

  Widget withCenter() {
    return Center(child: this);
  }
}
