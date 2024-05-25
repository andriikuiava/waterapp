import 'package:flutter/material.dart';
import 'package:waterapp/ColorTheme.dart';

Widget buildDrinkingEntry(BuildContext context, String time, bool isLast) {
  var timeParts = time.split(':');
  var hour = int.parse(timeParts[0].trim());
  var minute = int.parse(timeParts[1].trim());

  var formattedHour = hour < 10 ? '0$hour' : hour.toString();
  var formattedMinute = minute < 10 ? '0$minute' : minute.toString();

  return Column(
    children: [
      Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Spacer(),
            Text(
              "$formattedHour : $formattedMinute",
              style: TextStyle(
                  fontSize: 16,
                  color: AppColors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            Spacer(),
          ],
        ),
      ),
      (isLast ? SizedBox(height: 10) : SizedBox()),
    ],
  );
}
