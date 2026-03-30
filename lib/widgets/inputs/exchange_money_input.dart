import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:qrpay/backend/utils/custom_snackbar.dart';
import 'package:qrpay/language/language_controller.dart';
import 'package:qrpay/utils/size.dart';

import '../../backend/model/wallets/wallets_model.dart';
import '../../controller/categories/money_exchange/money_exchange_controller.dart';
import '../../language/english.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../text_labels/title_heading4_widget.dart';

class ExchangeMoneyInputWithDropdown extends StatefulWidget {
  final String hint, icon, label;
  final int maxLines;
  final bool isValidator;
  final EdgeInsetsGeometry? paddings;
  final TextEditingController controller;
  final Rxn<MainUserWallet> selectWallet;
  final bool isFirst;

  const ExchangeMoneyInputWithDropdown(
      {super.key,
      required this.controller,
      required this.hint,
      this.icon = "",
      this.isValidator = true,
      this.maxLines = 1,
      this.paddings,
      required this.label,
      required this.selectWallet,
      this.isFirst = false});

  @override
  State<ExchangeMoneyInputWithDropdown> createState() =>
      _PrimaryInputWidgetState();
}

class _PrimaryInputWidgetState extends State<ExchangeMoneyInputWithDropdown> {
  FocusNode? focusNode;
  final currencyController = Get.put(MoneyExchangeController());

  @override
  void initState() {
    super.initState();
    focusNode = FocusNode();
  }

  @override
  void dispose() {
    focusNode!.dispose();
    super.dispose();
  }

  final languageController = Get.put(LanguageController());
  @override
  Widget build(BuildContext context) {
    bool isTablet() {
      return MediaQuery.of(context).size.shortestSide >= 600;
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleHeading4Widget(
          text: widget.label,
          fontWeight: FontWeight.w600,
        ),
        verticalSpace(Dimensions.marginBetweenInputTitleAndBox),
        Row(
          children: [
            Expanded(
              flex: 9,
              child: TextFormField(
                validator: widget.isValidator == false
                    ? null
                    : (String? value) {
                        if (value!.isEmpty) {
                          return Get.find<LanguageController>()
                              .getTranslation(Strings.pleaseFillOutTheField);
                        } else {
                          return null;
                        }
                      },
                textInputAction: TextInputAction.done,
                controller: widget.controller,
                onTap: () {
                  setState(() {
                    focusNode!.requestFocus();
                  });
                },
                cursorColor: CustomColor.primaryLightColor,
                onChanged: (v) {
                  if (widget.label == Strings.exchangeFrom) {
                    currencyController.updateExchangeRateWithToAmount();
                    if (currencyController
                        .exchangeFromAmountController.text.isEmpty) {
                      currencyController.exchangeFromAmountController.text = "";
                    } else {
                      currencyController
                              .remainingController.senderAmount.value =
                          currencyController.exchangeFromAmountController.text;
                      currencyController.remainingController
                          .getRemainingBalanceProcess();
                    }
                  } else {
                    currencyController.updateExchangeRateWithFromAmount();
                  }
                },
                onFieldSubmitted: (value) {
                  setState(
                    () {
                      focusNode!.unfocus();
                    },
                  );
                },
                focusNode: focusNode,
                textAlign: TextAlign.left,
                style: Get.isDarkMode
                    ? CustomStyle.darkHeading3TextStyle
                    : CustomStyle.lightHeading3TextStyle,
                keyboardType: TextInputType.number,
                maxLines: widget.maxLines,
                decoration: InputDecoration(
                  hintText: languageController.getTranslation(widget.hint),
                  hintStyle: GoogleFonts.inter(
                    fontSize: Dimensions.headingTextSize3,
                    fontWeight: FontWeight.w500,
                    color: Get.isDarkMode
                        ? CustomColor.primaryDarkTextColor.withOpacity(0.2)
                        : CustomColor.primaryTextColor.withOpacity(0.2),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius * 0.5),
                    borderSide: BorderSide(
                      color: CustomColor.primaryLightColor.withOpacity(0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius * 0.5),
                    borderSide: BorderSide(
                        width: 2, color: CustomColor.primaryLightColor),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius * 0.5),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius * 0.5),
                    borderSide: const BorderSide(color: Colors.red, width: 2),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: Dimensions.widthSize * 1.7,
                    vertical: Dimensions.heightSize,
                  ),
                  suffixIcon: Container(
                    height: Dimensions.inputBoxHeight,
                    padding: EdgeInsets.only(left: Dimensions.widthSize * 0.5),
                    alignment: Alignment.centerRight,
                    width: isTablet()
                        ? Dimensions.widthSize * 6
                        : Dimensions.widthSize * 8,
                    decoration: BoxDecoration(
                        color: CustomColor.primaryLightColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(Dimensions.radius * 0.5),
                          bottomRight: Radius.circular(Dimensions.radius * 0.5),
                        )),
                    child: Obx(
                      () => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: DropdownButton<MainUserWallet>(
                          hint: Text(
                            widget.selectWallet.value!.currency.code,
                            style: GoogleFonts.inter(
                              color: CustomColor.whiteColor,
                              fontSize: Dimensions.headingTextSize4,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          iconEnabledColor: CustomColor.whiteColor,
                          iconSize: Dimensions.heightSize * 1.5,
                          dropdownColor: CustomColor.primaryLightColor,
                          underline: Container(),
                          items: currencyController.walletsList
                              .map<DropdownMenuItem<MainUserWallet>>(
                            (value) {
                              return DropdownMenuItem<MainUserWallet>(
                                value: value,
                                child: Text(
                                  value.currency.code,
                                  style: GoogleFonts.inter(
                                    color: CustomColor.whiteColor,
                                    fontSize: Dimensions.headingTextSize4,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                          onChanged: (MainUserWallet? value) {
                            if (widget.label == Strings.exchangeFrom) {
                              if (value !=
                                  currencyController.selectToWallet.value) {
                                widget.selectWallet.value = value;

                                currencyController
                                    .updateExchangeRateWithToAmount();

                                currencyController
                                    .remainingController
                                    .senderCurrency
                                    .value = value!.currency.code;

                                currencyController.remainingController
                                    .getRemainingBalanceProcess();
                              } else {
                                CustomSnackBar.error(
                                    Get.find<LanguageController>()
                                        .getTranslation(
                                            Strings.theSelectedWallet));
                              }
                            } else {
                              if (value !=
                                  currencyController.selectFromWallet.value) {
                                widget.selectWallet.value = value;
                                currencyController
                                    .updateExchangeRateWithToAmount();
                              } else {
                                CustomSnackBar.error(
                                    Get.find<LanguageController>()
                                        .getTranslation(
                                            Strings.theSelectedWallet));
                              }
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
