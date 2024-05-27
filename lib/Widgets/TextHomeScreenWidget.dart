import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:waterapp/ColorTheme.dart';

Widget TextHomeScreenWidget(BuildContext context, String text) {
  return Container(
      width: MediaQuery.of(context).size.width * 0.7,
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
                fontSize: 16,
                color: AppColors.white,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Spacer(),
        ],
      )
  );
}