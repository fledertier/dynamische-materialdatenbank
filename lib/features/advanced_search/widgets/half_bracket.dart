import 'package:flutter/material.dart';

class HalfBracket extends StatelessWidget {
  const HalfBracket.upper({super.key, this.width = 20}) : isUpper = true;

  const HalfBracket.lower({super.key, this.width = 20}) : isUpper = false;

  final double width;
  final bool isUpper;

  @override
  Widget build(BuildContext context) {
    final borderSide = BorderSide(
      width: 2,
      color: ColorScheme.of(context).primary,
    );

    return Padding(
      padding: EdgeInsets.only(left: width),
      child: SizedBox(
        width: width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              left: borderSide,
              top: isUpper ? borderSide : BorderSide.none,
              bottom: isUpper ? BorderSide.none : borderSide,
            ),
          ),
        ),
      ),
    );
  }
}
