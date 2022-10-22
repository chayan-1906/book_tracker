import 'package:book_tracker/constants/constants.dart';
import 'package:flutter/material.dart';

class TwoSidedRoundedButton extends StatelessWidget {
  final String text;
  final double radius;
  final Function press;
  final Color color;

  const TwoSidedRoundedButton({
    Key key,
    this.text,
    this.radius,
    this.press,
    this.color = kBlackColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: press,
      child: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomRight: Radius.circular(radius),
          ),
        ),
        child: Text(text, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
