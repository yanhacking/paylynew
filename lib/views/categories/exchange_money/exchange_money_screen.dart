import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/utils/basic_screen_imports.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';

import '../../../backend/local_storage/local_storage.dart';
import '../../../controller/categories/money_exchange/money_exchange_controller.dart';
import '../../../widgets/inputs/exchange_money_input.dart';
import '../../../widgets/others/limit_information_widget.dart';
import '../../../widgets/text_labels/title_heading5_widget.dart';

class ExchangeMoneyScreen extends StatelessWidget {
  ExchangeMoneyScreen({super.key});

  final controller = Get.put(MoneyExchangeController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.moneyExchange),
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
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.9),
      physics: const BouncingScrollPhysics(),
      children: [
        _inputWidget(context),
        _exchangeRate(context),
        _limitInformation(context),
        _buttonWidget(context),
      ],
    );
  }

  _inputWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 1.6),
      child: Form(
        key: formKey,
        child: Column(
          children: [
            ExchangeMoneyInputWithDropdown(
              controller: controller.exchangeFromAmountController,
              hint: Strings.enterAmount,
              label: Strings.exchangeFrom,
              selectWallet: controller.selectFromWallet,
              isFirst: true,
            ),
            verticalSpace(Dimensions.heightSize),
            ExchangeMoneyInputWithDropdown(
              controller: controller.exchangeToAmountController,
              hint: Strings.zero00,
              label: Strings.exchangeTo,
              selectWallet: controller.selectToWallet,
            ),
          ],
        ),
      ),
    );
  }

  _limitInformation(BuildContext context) {
    int precision = controller.selectFromWallet.value!.currency.type == 'FIAT'
        ? LocalStorages.getFiatPrecision()
        : LocalStorages.getCryptoPrecision();

    return LimitInformationWidget(
      showDailyLimit: controller.dailyLimit.value == 0.0 ? false : true,
      showMonthlyLimit: controller.monthlyLimit.value == 0.0 ? false : true,
      transactionLimit:
          '${controller.limitMin.value.toStringAsFixed(precision)} - ${controller.limitMax.value.toStringAsFixed(precision)} ${controller.selectFromWallet.value!.currency.code}',
      dailyLimit:
          '${controller.dailyLimit.value.toStringAsFixed(precision)} ${controller.selectFromWallet.value!.currency.code}',
      monthlyLimit:
          '${controller.monthlyLimit.value.toStringAsFixed(precision)} ${controller.selectFromWallet.value!.currency.code}',
      remainingMonthLimit:
          '${controller.remainingController.remainingMonthLyLimit.value.toStringAsFixed(precision)} ${controller.selectFromWallet.value!.currency.code}',
      remainingDailyLimit:
          '${controller.remainingController.remainingDailyLimit.value.toStringAsFixed(precision)} ${controller.selectFromWallet.value!.currency.code}',
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical * 4,
        bottom: Dimensions.marginSizeVertical,
      ),
      child: Obx(
        () => controller.isMoneyExchangeLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.moneyExchange,
                buttonColor: double.parse(controller
                                .remainingController.senderAmount.value) >
                            0 &&
                        double.parse(controller
                                .remainingController.senderAmount.value) <=
                            controller.dailyLimit.value &&
                        double.parse(controller
                                .remainingController.senderAmount.value) <=
                            controller.monthlyLimit.value
                    ? CustomColor.primaryLightColor
                    : CustomColor.primaryLightColor.withOpacity(alpha:0.3),
                onPressed: () {
                  if (double.parse(controller
                              .remainingController.senderAmount.value) <=
                          controller.dailyLimit.value &&
                      double.parse(controller
                              .remainingController.senderAmount.value) <=
                          controller.monthlyLimit.value) {
                    Get.toNamed(Routes.exchangeMoneyPreviewScreen);
                  }
                },
              ),
      ),
    );
  }

  _exchangeRate(BuildContext context) {
    int precision = controller.selectFromWallet.value!.currency.type == 'FIAT'
        ? LocalStorages.getFiatPrecision()
        : LocalStorages.getCryptoPrecision();
    double fromRate =
        double.parse(controller.selectFromWallet.value!.currency.rate);
    double totalCharge = (fromRate + controller.totalFee.value);

    return Container(    
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 0.2),
      child: Column(
        children: [
          Row(
            children: [
              TitleHeading5Widget(
                text: Strings.exchangeRate,
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkTextColor.withOpacity(alpha:0.8)
                    : CustomColor.primaryLightColor.withOpacity(alpha:0.6),
              ),
              TitleHeading5Widget(
                text:
                    ": 1 ${controller.selectFromWallet.value!.currency.code} = ${controller.exchangeRate.value.toStringAsFixed(precision)} ${controller.selectToWallet.value!.currency.code}",
                textAlign: TextAlign.left,
                fontWeight: FontWeight.w500,
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkTextColor.withOpacity(alpha:0.8)
                    : CustomColor.primaryLightColor.withOpacity(alpha:0.6),
              ),
            ],
          ),
          verticalSpace(Dimensions.heightSize * 0.1),
          Obx(
            () => Row(
              children: [
                TitleHeading5Widget(
                  text: Strings.feeAndCharge,
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w500,
                  color: Get.isDarkMode
                      ? CustomColor.primaryDarkTextColor.withOpacity(alpha:0.8)
                      : CustomColor.primaryLightColor.withOpacity(alpha:0.6),
                ),
                TitleHeading5Widget(
                  text:
                      ': ${fromRate.toStringAsFixed(precision)} ${controller.selectFromWallet.value!.currency.code} + 1% = ${totalCharge.toStringAsFixed(precision)} ${controller.selectFromWallet.value!.currency.code}',
                  textAlign: TextAlign.left,
                  fontWeight: FontWeight.w500,
                  color: Get.isDarkMode
                      ? CustomColor.primaryDarkTextColor.withOpacity(alpha:0.8)
                      : CustomColor.primaryLightColor.withOpacity(alpha:0.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
}
