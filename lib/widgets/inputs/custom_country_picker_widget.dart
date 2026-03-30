import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';

class CustomCountryPickerWidget extends StatefulWidget {
  final String hintText;
  final bool? readOnly;
  final Color? color;
  final double focusedBorderWidth;
  final double enabledBorderWidth;

  final String? value;
  final List<Map<String, List<String>>> items;
  final void Function(String?) onChanged;
  final double width;

  const CustomCountryPickerWidget({
    super.key,
    required this.hintText,
    this.readOnly = false,
    this.focusedBorderWidth = 1,
    this.enabledBorderWidth = 2,
    this.color = Colors.white,
    required this.items,
    required this.onChanged,
    this.value,
    this.width = double.infinity,
  });

  @override
  State<CustomCountryPickerWidget> createState() =>
      _CustomCountryPickerWidgetState();
}

class _CustomCountryPickerWidgetState extends State<CustomCountryPickerWidget> {
  // final authController = Get.put(SignUpController());
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: Dimensions.inputBoxHeight * 0.72,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
              border: Border.all(color: CustomColor.primaryLightColor)),
          width: widget.width,
          child: Theme(
            data: Theme.of(context).copyWith(
              canvasColor: CustomColor.whiteColor,
              buttonTheme: ButtonTheme.of(context).copyWith(
                alignedDropdown: true,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                hint: Text(
                  widget.hintText,
                  style: Get.isDarkMode
                      ? CustomStyle.darkHeading3TextStyle.copyWith(
                          color:
                              CustomColor.primaryDarkTextColor.withOpacity(0.3),
                          fontWeight: FontWeight.normal,
                          fontSize: Dimensions.headingTextSize5,
                        )
                      : CustomStyle.lightHeading3TextStyle.copyWith(
                          color: CustomColor.primaryLightTextColor
                              .withOpacity(0.3),
                          fontWeight: FontWeight.normal,
                          fontSize: Dimensions.headingTextSize5,
                        ),
                ),
                isExpanded: true,
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white.withOpacity(0.5),
                  size: Dimensions.iconSizeDefault * 1.5,
                ),
                value: widget.value,
                items: widget.items.map((valueItem) {
                  return DropdownMenuItem(
                    value: valueItem['name']!.first.toString(),
                    child: Text(
                      valueItem['name']!.first.toString(),
                      style: TextStyle(
                        color: CustomColor.primaryLightColor,
                        fontSize: Dimensions.headingTextSize5,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: widget.onChanged,
              ),
            ),
          ),
        ),
        SizedBox(
          height: Dimensions.heightSize,
        )
        // CustomSize.heightBetween()
      ],
    );
  }
}
