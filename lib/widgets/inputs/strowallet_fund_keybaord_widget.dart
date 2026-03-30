import 'dart:io';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../backend/model/wallets/wallets_model.dart';
import '../../backend/utils/custom_loading_api.dart';
import '../../backend/utils/custom_snackbar.dart';
import '../../controller/categories/virtual_card/strowallet_card/add_fund_strowallet_controller.dart';
import '../../controller/categories/virtual_card/strowallet_card/strowallelt_info_controller.dart';
import '../../controller/navbar/dashboard_controller.dart';
import '../../utils/basic_screen_imports.dart';
import '../payment_link/custom_drop_down.dart';

class StrowalletAddFundWidget extends StatelessWidget {
  StrowalletAddFundWidget({
    super.key,
    required this.buttonText,
  });
  final String buttonText;
  final controller = Get.put(StrowalletAddFundController());
  final cardController = Get.put(VirtualStrowalletCardController());

  @override
  Widget build(BuildContext context) {
    return Obx(() => controller.isLoadingCharge || cardController.isLoading
        ? const CustomLoadingAPI()
        : _bodyWidget(context));
  }

  _bodyWidget(BuildContext context) {
    var data = Get.find<DashBoardController>().dashBoardModel.data;
    var cardCharge = data.cardReloadCharge;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _inputFieldWidget(context),
        _fromWallet(context),
        Padding(
          padding:
              EdgeInsets.only(left: Dimensions.paddingHorizontalSize * 0.7),
          child: Align(
            alignment: Alignment.centerLeft,
            child: limitWidget(
                fee:
                    "${cardCharge.fixedCharge} ${data.baseCurr} + ${cardCharge.percentCharge} %",
                limit:
                    "${cardCharge.minLimit} ${data.baseCurr} - ${cardCharge.maxLimit} ${data.baseCurr}"),
          ),
        ),
        _customNumKeyBoardWidget(context),
        _buttonWidget(context)
      ],
    );
  }

  _inputFieldWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: Dimensions.marginSizeHorizontal * 0.5,
        top: Dimensions.marginSizeVertical * 2,
      ),
      alignment: Alignment.topCenter,
      height: Dimensions.inputBoxHeight,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.45,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(width: Dimensions.widthSize * 0.7),
                  Expanded(
                    child: TextFormField(
                      style: Get.isDarkMode
                          ? CustomStyle.lightHeading2TextStyle.copyWith(
                              fontSize: Dimensions.headingTextSize3 * 2,
                            )
                          : CustomStyle.darkHeading2TextStyle.copyWith(
                              color: CustomColor.primaryTextColor,
                              fontSize: Dimensions.headingTextSize3 * 2,
                            ),
                      readOnly: true,
                      controller: controller.amountTextController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(
                            RegExp(r'(^-?\d*\.?\d*)')),
                        LengthLimitingTextInputFormatter(
                          6,
                        ),
                      ],
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return Strings.pleaseFillOutTheField;
                        } else {
                          return null;
                        }
                      },
                      decoration: InputDecoration(
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                        contentPadding: EdgeInsets.zero,
                        hintText: '0.0',
                        hintStyle: CustomStyle.darkHeading2TextStyle.copyWith(
                          color: CustomColor.primaryTextColor.withOpacity(alpha:0.7),
                          fontSize: Dimensions.headingTextSize3 * 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: Dimensions.widthSize * 0.5,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: Dimensions.widthSize * 0.7),
          _currencyDropDownWidget(context),
        ],
      ),
    );
  }

  _fromWallet(BuildContext context) {
    return Obx(
      () => Container(
        margin: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSizeHorizontal * 0.7,
        ),
        child: CustomDropDown<MainUserWallet>(
          dropDownHeight: Dimensions.inputBoxHeight * 0.9,
          items: cardController.walletsList,
          title: Strings.fromWallet,
          hint: cardController.selectMainWallet.value!.title,
          onChanged: (value) {
            cardController.selectMainWallet.value = value!;
            controller.fromCurrency.value = value.currency.code.toString();

            print(cardController.fromCurrency.value);
          },
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.paddingHorizontalSize * 0.25,
          ),
          titleTextColor: CustomColor.primaryLightTextColor,
          borderEnable: true,
          dropDownFieldColor: Colors.transparent,
          dropDownIconColor: CustomColor.primaryLightTextColor,
        ),
      ),
    );
  }

  _customNumKeyBoardWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 0.5),
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 3,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 3 / 1.7,
        shrinkWrap: true,
        children: List.generate(
          controller.keyboardItemList.length,
          (index) {
            return controller.inputItem(index);
          },
        ),
      ),
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: Dimensions.marginSizeHorizontal * 0.8,
        right: Dimensions.marginSizeHorizontal * 0.8,
        top: Platform.isAndroid ? Dimensions.marginSizeVertical * 1.8 : 0.0,
      ),
      child: Row(
        children: [
          Expanded(
            child: Obx(
              () => controller.isLoading
                  ? const CustomLoadingAPI()
                  : PrimaryButton(
                      title: buttonText,
                      onPressed: () {
                        if (controller.amountTextController.text.isNotEmpty) {
                          controller.addFundProcess(context);
                        } else {
                          CustomSnackBar.error("Strings.plzEnterAmount");
                        }
                      },
                      borderColor: CustomColor.primaryLightColor,
                      buttonColor: CustomColor.primaryLightColor,
                    ),
            ),
          ),
        ],
      ),
    );
  }

  _currencyDropDownWidget(BuildContext context) {
    return Container(
      height: Dimensions.buttonHeight * 0.65,
      alignment: Alignment.center,
      margin: EdgeInsets.symmetric(
          horizontal: Dimensions.marginSizeHorizontal * 0.1,
          vertical: Dimensions.marginSizeVertical * 0.2),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius * 1.7),
          color: CustomColor.primaryBGDarkColor),
      child: Row(children: [
        horizontalSpace(Dimensions.widthSize),
        TitleHeading3Widget(
          text: controller.cardChargesModel.data.baseCurr,
          color: CustomColor.whiteColor,
          fontWeight: FontWeight.w500,
        ),
        horizontalSpace(Dimensions.widthSize),
      ]),
    );
  }
}

Widget limitWidget({required fee, required limit}) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical * 0.2),
    child: Column(
      crossAxisAlignment: crossStart,
      children: [
        Text(
          "Transfer Fee: $fee ",
          textAlign: TextAlign.left,
          style: GoogleFonts.inter(
            fontSize: Dimensions.headingTextSize5,
            fontWeight: FontWeight.w500,
            color: CustomColor.primaryLightTextColor,
          ),
        ),
        verticalSpace(Dimensions.heightSize * 0.2),
        Text(
          "Limit: $limit",
          textAlign: TextAlign.left,
          style: GoogleFonts.inter(
            fontSize: Dimensions.headingTextSize5,
            fontWeight: FontWeight.w500,
            color: CustomColor.primaryLightTextColor,
          ),
        ),
      ],
    ),
  );
}
