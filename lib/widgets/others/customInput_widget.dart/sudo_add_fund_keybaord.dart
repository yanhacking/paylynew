import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/utils/size.dart';

import '../../../backend/model/wallets/wallets_model.dart';
import '../../../controller/categories/virtual_card/sudo_virtual_card/sudo_adfund_controller.dart';
import '../../../language/english.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/dimensions.dart';
import '../../buttons/primary_button.dart';
import '../../inputs/custom_input_with_drop_down.dart';
import '../../payment_link/custom_drop_down.dart';
import '../limit_widget.dart';

class SudoAddFundCustomAmountWidget extends StatelessWidget {
  SudoAddFundCustomAmountWidget({
    super.key,
    required this.buttonText,
    required this.onTap,
  });
  final String buttonText;
  final VoidCallback onTap;
  final controller = Get.put(SudoAddFundController());

  @override
  Widget build(BuildContext context) {
    return _bodyWidget(context);
  }

  _bodyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _inputFields(context),
          _chargeAndFee(context),
          _buttonWidget(context)
        ],
      ),
    );
  }

  _inputFields(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: Dimensions.paddingSize),
          child: CustomInputWithDropDown(
            controller: controller.virtualCardController.fundAmountController,
            hint: Strings.zero00,
            label: Strings.amount,
            selectedItem:
                controller.virtualCardController.selectedSupportedCurrency,
            itemList: controller.virtualCardController.supportedCurrencyList,
            displayItem: (item) => item.code,
            onDropChanged: (value) {
              controller.virtualCardController.selectedSupportedCurrency.value =
                  value;
              controller.virtualCardController.updateLimit();
              controller.virtualCardController.calculation();
            },
            onFieldChanged: (value) {
              controller.virtualCardController.calculation();
            },
          ),
        ),
        verticalSpace(Dimensions.marginBetweenInputBox),
        _fromWallet(context),
      ],
    );
  }

  _chargeAndFee(BuildContext context) {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(top: Dimensions.paddingVerticalSize * 0.4),
        child: LimitWidget(
          fee:
              '${controller.virtualCardController.totalCharge.value.toStringAsFixed(4)} ${controller.virtualCardController.selectMainWallet.value!.currency.code}',
          limit:
              '${controller.virtualCardController.limitMin} - ${controller.virtualCardController.limitMax} ${controller.virtualCardController.selectedSupportedCurrency.value!.code}',
        ),
      ),
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Platform.isAndroid ? Dimensions.marginSizeVertical * 1.8 : 0.0,
      ),
      child: Row(
        mainAxisAlignment: mainCenter,
        children: [
          Obx(
            () => controller.isLoading
                ? const CustomLoadingAPI()
                : Expanded(
                    child: PrimaryButton(
                      title: buttonText,
                      onPressed: onTap,
                      borderColor: CustomColor.primaryLightColor,
                      buttonColor: CustomColor.primaryLightColor,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  _fromWallet(BuildContext context) {
    return Obx(
      () => CustomDropDown<MainUserWallet>(
        dropDownHeight: Dimensions.inputBoxHeight * 0.9,
        items: controller.virtualCardController.walletsList,
        title: Strings.fromWallet,
        hint: controller.virtualCardController.selectMainWallet.value!.title,
        onChanged: (value) {
          controller.virtualCardController.selectMainWallet.value = value!;
        },
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.paddingHorizontalSize * 0.25,
        ),
        titleTextColor: CustomColor.primaryLightTextColor,
        borderEnable: true,
        dropDownFieldColor: Colors.transparent,
        dropDownIconColor: CustomColor.primaryLightTextColor,
      ),
    );
  }
}
