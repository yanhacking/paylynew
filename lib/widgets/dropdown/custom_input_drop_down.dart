// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../backend/model/categories/bill_pay_model/bill_pay_model.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';

class CustomInputDropDown extends StatelessWidget {
  final RxString selectMethod;
  final List<BillType> itemsList;
  final void Function(BillType?)? onChanged;

  const CustomInputDropDown({
    required this.itemsList,
    super.key,
    required this.selectMethod,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        height: Dimensions.inputBoxHeight * 0.72,
        decoration: BoxDecoration(
          border: Border.all(
            color: CustomColor.primaryLightColor,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
        ),
        child: DropdownButtonHideUnderline(
          child: Padding(
            padding: const EdgeInsets.only(left: 5, right: 20),
            child: DropdownButton<BillType>(
              hint: Padding(
                padding: EdgeInsets.only(left: Dimensions.paddingSize * 0.7),
                child: Text(
                  selectMethod.value,
                  style: GoogleFonts.inter(
                      fontSize: Dimensions.headingTextSize4,
                      fontWeight: FontWeight.w600,
                      color: CustomColor.primaryLightColor),
                ),
              ),
              icon: const Padding(
                padding: EdgeInsets.only(right: 4),
                child: Icon(
                  Icons.arrow_drop_down,
                  color: CustomColor.primaryTextColor,
                ),
              ),
              isExpanded: true,
              underline: Container(),
              borderRadius: BorderRadius.circular(Dimensions.radius),
              menuMaxHeight: MediaQuery.sizeOf(context).height*0.5,
              items: itemsList.map<DropdownMenuItem<BillType>>((value) {
              
                return DropdownMenuItem<BillType>(
                  value: value,
                  child: Text(
                    value.name!,
                    style: CustomStyle.lightHeading3TextStyle,
                  ),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ),
    );
  }
}
