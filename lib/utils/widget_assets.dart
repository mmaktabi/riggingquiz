import 'package:flutter/material.dart';
import 'package:rigging_quiz/utils/constant.dart';
import 'package:rigging_quiz/widgets/custom_text.dart';

widgetButton(Text title, Function() onPressed,
    {color,
    height,
    width,
    margin,
    padding,
    paddingBtn,
    shape,
    radius,
    widthBorder,
    colorBorder,
    align}) {
  return Container(
    width: width,
    height: height,
    margin: margin,
    padding: padding,
    decoration: const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: color ?? ColorsHelpers.primaryColor,
          minimumSize: Size(width, height),
          padding: paddingBtn,
          alignment: align,
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: widthBorder ?? 0.0,
              color: colorBorder ?? Colors.transparent,
            ),
            borderRadius: BorderRadius.circular(radius),
          )),
      onPressed: onPressed,
      child: title,
    ),
  );
}

listItem(Widget leading, String title, String subTitle, Function()? onTap,
    Color? backgroundColor, Color? textColor, Color? textColorSub) {
  return Container(
    decoration: const BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Color.fromRGBO(25, 67, 109, 0.04),
          spreadRadius: 0,
          blurRadius: 16,
          offset: Offset(0, 4),
        )
      ],
    ),
    child: Card(
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
          side: const BorderSide(
            color: ColorsHelpers.grey2,
          ),
          borderRadius: BorderRadius.circular(16)),
      color: backgroundColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              SizedBox.square(dimension: 60, child: leading),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    children: [
                      QText(
                        text: title,
                        weight: FontWeight.w500,
                        fontSize: 14,
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                      QText(
                        text: subTitle,
                        weight: FontWeight.w400,
                        fontSize: 11,
                      ),
                    ],
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: textColor ?? Colors.white,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
