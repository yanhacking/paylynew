// ignore_for_file: use_build_context_synchronously

import 'package:google_fonts/google_fonts.dart';
import 'package:qrpay/utils/custom_switch_loading_api.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';
import 'package:qrpay/widgets/others/limit_widget.dart';

import '../../../backend/local_storage/local_storage.dart';
import '../../../backend/model/wallets/wallets_model.dart';
import '../../../backend/utils/custom_loading_api.dart';
import '../../../backend/utils/custom_snackbar.dart';
import '../../../controller/categories/mobile_topup/mobile_topup_controller.dart';
import '../../../controller/navbar/dashboard_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/basic_screen_imports.dart';
import '../../../widgets/dropdown/input_dropdown.dart';
import '../../../widgets/inputs/primary_text_input_widget.dart';
import '../../../widgets/inputs/top_up_phone_number_with_contry_code_input.dart';
import '../../../widgets/others/congratulation_widget.dart';
import '../../../widgets/others/limit_information_widget.dart';

class MobileTopUpScreen extends StatelessWidget {
  final controller = Get.put(MobileTopupController());
  final dashboardController = Get.put(DashBoardController());

  MobileTopUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.mobileTopUp),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal,
      ),
      physics: const BouncingScrollPhysics(),
      children: [
        _selectedTopUpType(context),
        if (controller.selectTopUpType.value == "AUTOMATIC") ...[
          _automaticInputWidget(context),
        ] else if (controller.selectTopUpType.value == "MANUAL") ...[
          _inputWidget(context),
        ],
        if (controller.selectTopUpType.value == "MANUAL" ||
            controller.selectTopUpType.value == "AUTOMATIC") ...[
          _buttonWidget(context),
        ]
      ],
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.marginSizeVertical * 2,
      ),
      child: Obx(
        () => controller.isInsertLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.topUpNow,
                disable: controller.selectTopUpType.value == "AUTOMATIC" &&
                    controller.isGettingOperator.value == false,
                onPressed: () {
                  if (dashboardController.kycStatus.value == 1) {
                    if (controller.selectTopUpType.value == "AUTOMATIC" &&
                        controller.isGettingOperator.value == true) {
                      controller.mobileTopUpAutomaticProcess().then(
                            (value) => StatusScreen.show(
                              context: context,
                              subTitle: Strings.yourTopUpSuccess.tr,
                              onPressed: () {
                                Get.offAllNamed(Routes.bottomNavBarScreen);
                              },
                            ),
                          );
                    } else if (controller.selectTopUpType.value == "MANUAL") {
                      controller.type.value = controller
                          .getType(controller.billMethodselected.value)!;
                      controller
                          .topUpApiProcess(
                              amount: controller.amountController.text,
                              number: controller.mobileNumberController.text,
                              type: controller.type.value)
                          .then(
                            (value) => StatusScreen.show(
                              context: context,
                              subTitle: Strings.yourTopUpSuccess.tr,
                              onPressed: () {
                                Get.offAllNamed(Routes.bottomNavBarScreen);
                              },
                            ),
                          );
                    }
                  } else {
                    CustomSnackBar.error(Strings.pleaseSubmitYourInformation);
                    Future.delayed(const Duration(seconds: 2), () {
                      Get.toNamed(Routes.updateKycScreen);
                    });
                  }
                },
              ),
      ),
    );
  }

//automatic
  _inputWidget(BuildContext context) {
    int precision = controller.selectMainWallet.value!.currency.type == 'FIAT'
        ? LocalStorages.getFiatPrecision()
        : LocalStorages.getCryptoPrecision();
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 0.5),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          CustomTitleHeadingWidget(
            text: Strings.mobileTopUp,
            style: CustomStyle.darkHeading4TextStyle.copyWith(
              fontWeight: FontWeight.w600,
              color: Get.isDarkMode
                  ? CustomColor.primaryDarkTextColor
                  : CustomColor.primaryTextColor,
            ),
          ),
          verticalSpace(Dimensions.heightSize * 0.5),
          InputDropDown(
            itemsList: controller.billList,
            selectMethod: controller.billMethodselected,
            onChanged: ((p0) => controller.billMethodselected.value = p0!),
          ),
          verticalSpace(Dimensions.heightSize),
          TopUpPhoneNumberInputWidget(
            isoCode: controller.isoCode,
            countryCode: controller.countryCode,
            controller: controller.mobileNumberController,
            hint: Strings.xxx,
            label: Strings.phoneNumber,
            keyBoardType: TextInputType.number,
          ),
          verticalSpace(Dimensions.heightSize),
          PrimaryTextInputWidget(
            controller: controller.amountController,
            hint: Strings.zero00,
            labelText: Strings.amount,
            keyboardType: TextInputType.number,
            onChanged: (v) {
              controller.getFee(
                rate: double.parse(
                    controller.selectMainWallet.value!.currency.rate),
              );
            },
            suffixIcon: _walletsWidget(context),
          ),
          Obx(
            () {
              return LimitWidget(
                fee:
                    '${controller.totalFee.value.toStringAsFixed(precision)} ${controller.selectMainWallet.value!.currency.code}',
                limit:
                    '${controller.limitMin.toStringAsFixed(precision)} - ${controller.limitMax.toStringAsFixed(precision)} ${controller.selectMainWallet.value!.currency.code}',
              );
            },
          ),
          LimitInformationWidget(
            showDailyLimit: controller.dailyLimit.value == 0.0 ? false : true,
            showMonthlyLimit:
                controller.monthlyLimit.value == 0.0 ? false : true,
            transactionLimit:
                '${controller.limitMin.value.toStringAsFixed(precision)} - ${controller.limitMax.value.toStringAsFixed(precision)} ${controller.selectMainWallet.value!.currency.code}',
            dailyLimit:
                '${controller.dailyLimit.value.toStringAsFixed(precision)} ${controller.selectMainWallet.value!.currency.code}',
            monthlyLimit:
                '${controller.monthlyLimit.value.toStringAsFixed(precision)} ${controller.selectMainWallet.value!.currency.code}',
            remainingMonthLimit:
                '${controller.remainingController.remainingMonthLyLimit.value.toStringAsFixed(precision)} ${controller.selectMainWallet.value!.currency.code}',
            remainingDailyLimit:
                '${controller.remainingController.remainingDailyLimit.value.toStringAsFixed(precision)} ${controller.selectMainWallet.value!.currency.code}',
          ),
        ],
      ),
    );
  }

  _selectedTopUpType(BuildContext context) {
    return Column(
      crossAxisAlignment: crossStart,
      children: [
        CustomTitleHeadingWidget(
          text: Strings.selectTopUpType,
          style: CustomStyle.darkHeading4TextStyle.copyWith(
            fontWeight: FontWeight.w600,
            color: Get.isDarkMode
                ? CustomColor.primaryDarkTextColor
                : CustomColor.primaryTextColor,
          ),
        ),
        verticalSpace(Dimensions.heightSize * 0.5),
        InputDropDown(
          itemsList: controller.topUpTypeList,
          selectMethod: controller.selectTopUpType,
          onChanged: ((p0) => controller.selectTopUpType.value = p0!),
        ),
      ],
    );
  }

  _automaticInputWidget(BuildContext context) {
    int precision = controller.selectMainWallet.value!.currency.type == 'FIAT'
        ? LocalStorages.getFiatPrecision()
        : LocalStorages.getCryptoPrecision();
    return Obx(
      () => Column(
        crossAxisAlignment: crossStart,
        children: [
          verticalSpace(Dimensions.heightSize * 0.5),
          TopUpPhoneNumberInputWidget(
            isoCode: controller.isoCode,
            countryCode: controller.countryCode,
            controller: controller.mobileNumberController,
            hint: Strings.xxx,
            label: Strings.phoneNumber,
            keyBoardType: TextInputType.number,
            onTapOutside: (v) {
              controller.isCountry.value = false;
              controller.getDetectOperator();
              controller.remainingController.getRemainingBalanceProcess();
            },
            onFieldSubmitted: (v) {
              controller.getDetectOperator();
              controller.isCountry.value = false;
              controller.remainingController.getRemainingBalanceProcess();
            },
          ),
          if (controller.isDetectLoading) ...[
            Padding(
              padding: EdgeInsets.only(
                top: Dimensions.paddingVerticalSize * 0.35,
              ),
              child: CustomSwitchLoading(
                color: CustomColor.primaryDarkColor,
              ),
            )
          ],
          if (controller.isGettingOperator.value) ...[
            verticalSpace(Dimensions.heightSize * 0.5),
            if (controller.detectOperatorModel.data.data!.denominationType !=
                'FIXED')
              Column(
                children: [
                  PrimaryTextInputWidget(
                    controller: controller.amountController,
                    hint: Strings.zero00,
                    keyboardType: TextInputType.number,
                    labelText: Strings.amount,
                    onChanged: (v) {
                      controller.getFee(
                        rate: double.parse(
                            controller.selectMainWallet.value!.currency.rate),
                      );
                    },
                    suffixIcon: _walletsWidget(context),
                  ),
                  verticalSpace(Dimensions.heightSize),
                ],
              ),
            // const TitleHeading4Widget(
            //   text: Strings.amount,
            //   fontWeight: FontWeight.w600,
            // ),
            verticalSpace(Dimensions.heightSize * 0.7),
            if (controller.detectOperatorModel.data.data!.denominationType ==
                'FIXED') ...[
              Wrap(
                children: List.generate(
                  controller
                      .detectOperatorModel.data.data!.localFixedAmounts!.length,
                  (index) {
                    var amount = double.parse(controller.detectOperatorModel
                        .data.data!.localFixedAmounts![index]
                        .toString());
                    return InkWell(
                      highlightColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      onTap: () {
                        controller.selectedAmount.value = index;
                        controller.amountController.text = amount.toString();
                        controller.getFee(rate: controller.rate.value);
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width * 0.18,
                        padding: EdgeInsets.all(Dimensions.paddingSize * 0.4),
                        margin: EdgeInsets.only(
                          right: Dimensions.marginSizeHorizontal * 0.4,
                          bottom: Dimensions.marginSizeVertical * 0.4,
                        ),
                        decoration: BoxDecoration(
                          color: controller.selectedAmount.value == index
                              ? CustomColor.primaryLightColor
                              : CustomColor.kDarkBlue,
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius),
                        ),
                        child: Center(
                          child: TitleHeading4Widget(
                            text: amount.toString(),
                            color: controller.selectedAmount.value != index
                                ? CustomColor.primaryLightColor
                                : Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

            Obx(
              () {
                var data = controller.detectOperatorModel.data.data!;
                bool isNotLocalLimit = data.supportsLocalAmounts == true &&
                    data.destinationCurrencyCode == data.senderCurrencyCode &&
                    data.localMinAmount == 0.0 &&
                    data.localMaxAmount == 0.0;
                bool isLocalLimitFx = data.supportsLocalAmounts == true &&
                    data.localMinAmount != 0.0 &&
                    data.localMaxAmount != 0.0;

                return LimitWidget(
                    showLimit: controller
                            .detectOperatorModel.data.data!.denominationType !=
                        'FIXED',
                    fee:
                        '${controller.feesAndCharge.value.toStringAsFixed(precision)} ${controller.isCountry.value == false ? controller.operatorCurrency.value : controller.selectMainWallet.value!.currency.code} ${controller.percentCharge.value.toStringAsFixed(precision)}%',
                    limit: isNotLocalLimit
                        ? '${double.parse(controller.operatorLimitMin.toStringAsFixed(precision))} - ${double.parse(controller.operatorLimitMax.toStringAsFixed(precision))} ${controller.isCountry.value == false ? controller.operatorCurrency.value : controller.selectMainWallet.value!.currency.code}'
                        : isLocalLimitFx
                            ? '${double.parse(controller.operatorLocalLimitMin.toStringAsFixed(precision))} - ${double.parse(controller.operatorLocalLimitMax.toStringAsFixed(precision))} ${controller.isCountry.value == false ? controller.operatorCurrency.value : controller.selectMainWallet.value!.currency.code}'
                            : '${double.parse(controller.operatorLimitFxMin.toStringAsFixed(precision))} - ${double.parse(controller.operatorLimitFxMax.toStringAsFixed(precision))} ${controller.isCountry.value == false ? controller.operatorCurrency.value : controller.selectMainWallet.value!.currency.code}');
              },
            ),

            Obx(() {
              var currency =
                  '${controller.isCountry.value == false ? controller.operatorCurrency.value : controller.selectMainWallet.value!.currency.code} ';
              var data = controller.detectOperatorModel.data.data!;
              bool isNotLocalLimit = data.supportsLocalAmounts == true &&
                  data.destinationCurrencyCode == data.senderCurrencyCode &&
                  data.localMinAmount == 0.0 &&
                  data.localMaxAmount == 0.0;
              bool isLocalLimitFx = data.supportsLocalAmounts == true &&
                  data.localMinAmount != 0.0 &&
                  data.localMaxAmount != 0.0;
              return LimitInformationWidget(
                showDailyLimit:
                    controller.dailyLimit.value == 0.0 ? false : true,
                showMonthlyLimit:
                    controller.monthlyLimit.value == 0.0 ? false : true,
                transactionLimit: isNotLocalLimit
                    ? '${double.parse(controller.operatorLimitMin.toStringAsFixed(precision))} - ${double.parse(controller.operatorLimitMax.toStringAsFixed(precision))} ${controller.isCountry.value == false ? controller.operatorCurrency.value : controller.selectMainWallet.value!.currency.code}'
                    : isLocalLimitFx
                        ? '${double.parse(controller.operatorLocalLimitMin.toStringAsFixed(precision))} - ${double.parse(controller.operatorLocalLimitMax.toStringAsFixed(precision))} $currency'
                        : '${double.parse(controller.operatorLimitFxMin.toStringAsFixed(precision))} - ${double.parse(controller.operatorLimitFxMax.toStringAsFixed(precision))} $currency',
                dailyLimit:
                    '${controller.dailyLimit.value.toStringAsFixed(precision)} $currency',
                monthlyLimit:
                    '${controller.monthlyLimit.value.toStringAsFixed(precision)} $currency',
                remainingMonthLimit:
                    '${controller.remainingController.remainingMonthLyLimit.value.toStringAsFixed(precision)} $currency',
                remainingDailyLimit:
                    '${controller.remainingController.remainingDailyLimit.value.toStringAsFixed(precision)} $currency',
              );
            }),
          ]
        ],
      ),
    );
  }

//wallet widget
  _walletsWidget(BuildContext context) {
    return Container(
      height: Dimensions.inputBoxHeight,
      alignment: Alignment.center,
      width: Dimensions.widthSize * 7.5,
      decoration: BoxDecoration(
        color: CustomColor.primaryLightColor,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(Dimensions.radius * 0.5),
          bottomRight: Radius.circular(Dimensions.radius * 0.5),
        ),
      ),
      child: Obx(
        () => DropdownButton<MainUserWallet>(
          hint: Text(
            controller.isCountry.value == false
                ? controller.isoCode.value
                : controller.selectMainWallet.value!.currency.code,
            style: GoogleFonts.inter(
              color: CustomColor.whiteColor,
              fontSize: 16.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          iconEnabledColor: CustomColor.whiteColor,
          iconSize: Dimensions.heightSize * 1.5,
          dropdownColor: CustomColor.primaryLightColor,
          underline: Container(),
          items: controller.walletsList.map<DropdownMenuItem<MainUserWallet>>(
            (value) {
              return DropdownMenuItem<MainUserWallet>(
                value: value,
                child: Text(
                  value.currency.code,
                  style: GoogleFonts.inter(
                    color: CustomColor.whiteColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            },
          ).toList(),
          onChanged: (MainUserWallet? value) {
            controller.isCountry.value = true;
            controller.selectMainWallet.value = value;
            if (controller.selectTopUpType.value == "AUTOMATIC") {
              controller.exchangeRate.value = controller.operatorRate.value /
                  double.parse(value!.currency.rate);
              controller.getAutomaticFee(
                  rate: double.parse(value.currency.rate));
              //operator limit
              controller.operatorLimitMin.value =
                  controller.detectOperatorModel.data.data!.minAmount! /
                      controller.exchangeRate.value;
              controller.operatorLimitMax.value =
                  (controller.detectOperatorModel.data.data!.maxAmount! /
                      controller.exchangeRate.value);
              //operator limit local
              controller.operatorLocalLimitMin.value =
                  controller.detectOperatorModel.data.data!.minAmount! /
                      controller.exchangeRate.value;
              controller.operatorLocalLimitMin.value =
                  (controller.detectOperatorModel.data.data!.maxAmount! /
                      controller.exchangeRate.value);
              //Fx filteer limit
              controller.operatorLimitFxMin.value =
                  ((controller.detectOperatorModel.data.data!.minAmount! *
                          controller.detectOperatorModel.data.data!.fx!.rate) /
                      controller.exchangeRate.value);

              controller.operatorLimitFxMax.value =
                  ((controller.detectOperatorModel.data.data!.minAmount! *
                          controller.detectOperatorModel.data.data!.fx!.rate) /
                      controller.exchangeRate.value);

              controller.limitMin.value =
                  controller.topUpInfoData.data.topupCharge.minLimit *
                      double.parse(value.currency.rate);
              controller.limitMax.value =
                  controller.topUpInfoData.data.topupCharge.maxLimit *
                      double.parse(value.currency.rate);

              controller.dailyLimit.value =
                  controller.topUpInfoData.data.topupCharge.dailyLimit *
                      double.parse(value.currency.rate);
              controller.monthlyLimit.value =
                  controller.topUpInfoData.data.topupCharge.dailyLimit *
                      double.parse(value.currency.rate);
              controller.remainingController.senderCurrency.value =
                  value.currency.code;
              controller.remainingController.getRemainingBalanceProcess();
              controller.getFee(rate: double.parse(value.currency.rate));
            } else {
              controller.getFee(rate: double.parse(value!.currency.rate));

              controller.limitMin.value =
                  controller.topUpInfoData.data.topupCharge.minLimit *
                      double.parse(value.currency.rate);
              controller.limitMax.value =
                  controller.topUpInfoData.data.topupCharge.maxLimit *
                      double.parse(value.currency.rate);

              controller.remainingController.senderCurrency.value =
                  value.currency.code;

              controller.remainingController.getRemainingBalanceProcess();
              controller.getFee(rate: double.parse(value.currency.rate));

              controller.dailyLimit.value =
                  controller.topUpInfoData.data.topupCharge.dailyLimit *
                      double.parse(value.currency.rate);
              controller.monthlyLimit.value =
                  controller.topUpInfoData.data.topupCharge.dailyLimit *
                      double.parse(value.currency.rate);
            }
          },
        ),
      ),
    );
  }
}
