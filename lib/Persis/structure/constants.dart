import 'package:flutter/material.dart';

const int rethrowMax = 0;

const minimaxDepth = 2;

const List<int> transitionsIndices = [1, 2, 3, 4, 6, 10, 12, 25];

const List<String> transitionsNames = ['خال', 'دواق', 'ثلاثة', 'أربعة', 'شكة', 'دست', 'بارا', 'بنج'];

void navigateTo(context, widget) => Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
      (route) => false,
);

Widget defaultButton({
  double width = double.infinity,
  double height = 45,
  double borderRadius = 15,
  required void Function()? onPressed,
  required String text,
  double fontSize = 16,
  Color textColor = Colors.white,
  Color buttonColor = Colors.orange,
}) =>
    Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(borderRadius)),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );