import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/utils/custom_style.dart';
import 'package:qrpay/widgets/text_labels/custom_title_heading_widget.dart';
import 'package:qrpay/widgets/text_labels/title_heading3_widget.dart';

import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/size.dart';

class NotificationWidget extends StatelessWidget {
  const NotificationWidget({
    super.key,
    required this.subtitle,
    required this.title,
    required this.dateText,
    required this.monthText,
  });

  final String title, monthText, dateText, subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: Dimensions.marginSizeVertical * 0.3),
      child: Container(
        margin: EdgeInsets.symmetric(
            horizontal: Dimensions.marginSizeVertical * 0.7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius),
          color: Get.isDarkMode
              ? CustomColor.whiteColor.withOpacity(alpha:0.06)
              : CustomColor.whiteColor,
        ),
        padding: EdgeInsets.only(right: Dimensions.paddingSize * 0.2),
        child: Row(
          children: [
            Expanded(
                flex: 2,
                child: Container(
                  margin: EdgeInsets.only(
                    left: Dimensions.marginSizeVertical * 0.4,
                    top: Dimensions.marginSizeVertical * 0.5,
                    bottom: Dimensions.marginSizeVertical * 0.4,
                    right: Dimensions.marginSizeVertical * 0.2,
                  ),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: CustomColor.primaryLightColor.withOpacity(alpha:0.04),
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius * 0.6),
                  ),
                  child: Column(
                    mainAxisAlignment: mainStart,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CustomTitleHeadingWidget(
                        text: dateText,
                        style: CustomStyle.darkHeading4TextStyle.copyWith(
                            fontSize: Dimensions.headingTextSize3 * 1.5,
                            fontWeight: FontWeight.w800,
                            color: CustomColor.primaryLightColor),
                      ),
                      CustomTitleHeadingWidget(
                        text: monthText,
                        style: CustomStyle.darkHeading4TextStyle.copyWith(
                            fontSize: Dimensions.headingTextSize6 * 0.7,
                            fontWeight: FontWeight.w600,
                            color: CustomColor.primaryLightColor),
                      ),
                      verticalSpace(Dimensions.heightSize * 0.3)
                    ],
                  ),
                )),
            Expanded(
              flex: 7,
              child: Column(
                crossAxisAlignment: crossStart,
                mainAxisAlignment: mainCenter,
                children: [
                  TitleHeading3Widget(
                    text: title,
                  ),
                  CustomTitleHeadingWidget(
                    text: subtitle,
                    style: Get.isDarkMode
                        ? CustomStyle.darkHeading4TextStyle.copyWith(
                            fontSize: Dimensions.headingTextSize5,
                            fontWeight: FontWeight.w400,
                          )
                        : CustomStyle.lightHeading4TextStyle.copyWith(
                            fontSize: Dimensions.headingTextSize5,
                            fontWeight: FontWeight.w400,
                          ),
                    opacity: 0.8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
