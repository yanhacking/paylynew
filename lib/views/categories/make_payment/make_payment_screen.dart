// ignore_for_file: use_build_context_synchronously

import 'package:qrpay/backend/local_storage/local_storage.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/custom_assets/assets.gen.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';

import '../../../backend/utils/custom_snackbar.dart';
import '../../../controller/categories/make_payment/make_payment_controller.dart';
import '../../../controller/navbar/dashboard_controller.dart';
import '../../../utils/basic_screen_imports.dart';
import '../../../widgets/others/congratulation_widget.dart';
import '../../../widgets/others/limit_information_widget.dart';
import '../../../widgets/text_labels/title_heading5_widget.dart';
import 'copy_with_input_make_payment.dart';
import 'input_with_dropdown_make_payment.dart';

class MakePaymentScreen extends StatelessWidget {
  MakePaymentScreen({super.key});

  final controller = Get.put(MakePaymentController());
  final dashboardController = Get.find<DashBoardController>();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.makePayment),
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
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                MakePaymentCopyInputWidget(
                  suffixIcon: Assets.icon.scan,
                  suffixColor: CustomColor.primaryLightColor,
                  onTap: () {
                    Get.toNamed(Routes.makePaymentQRCodeScreen);
                  },
                  controller: controller.copyInputController,
                  hint: Strings.enterEmailPhone,
                  label: Strings.phoneEmail,
                ),
                Obx(() {
                  return TitleHeading5Widget(
                    text: controller.checkUserMessage.value,
                    color: controller.isValidUser.value
                        ? Colors.green
                        : Colors.red,
                  );
                })
              ],
            ),
            verticalSpace(Dimensions.heightSize),
            MakePaymentInputWithDropdown(
              controller: controller.senderAmountController,
              hint: Strings.zero00,
              label: Strings.senderAmount,
              selectWallet: controller.selectSenderWallet,
            ),
            verticalSpace(Dimensions.heightSize),
            MakePaymentInputWithDropdown(
              controller: controller.receiverAmountController,
              hint: Strings.zero00,
              label: Strings.receiverAmount,
              selectWallet: controller.selectReceiverWallet,
            ),
            verticalSpace(Dimensions.heightSize),
            PrimaryInputWidget(
              controller: controller.remarkController,
              hint: Strings.enterRemark,
              isValidator: false,
              label:
                  "${Strings.remark.translation} (${Strings.optional.translation})",
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }

  _limitInformation(BuildContext context) {
    int precision = controller.selectSenderWallet.value!.currency.type == 'FIAT'
        ? LocalStorages.getFiatPrecision()
        : LocalStorages.getCryptoPrecision();

    return LimitInformationWidget(
      showDailyLimit: controller.dailyLimit.value == 0.0 ? false : true,
      showMonthlyLimit: controller.monthlyLimit.value == 0.0 ? false : true,
      transactionLimit:
          '${controller.limitMin.value.toStringAsFixed(precision)} - ${controller.limitMax.value.toStringAsFixed(precision)} ${controller.selectSenderWallet.value!.currency.code}',
      dailyLimit:
          '${controller.dailyLimit.value.toStringAsFixed(precision)} ${controller.selectSenderWallet.value!.currency.code}',
      remainingDailyLimit:
          '${controller.remainingController.remainingDailyLimit.value.toStringAsFixed(precision)} ${controller.selectSenderWallet.value!.currency.code}',
      monthlyLimit:
          '${controller.monthlyLimit.value.toStringAsFixed(precision)} ${controller.selectSenderWallet.value!.currency.code}',
      remainingMonthLimit:
          '${controller.remainingController.remainingMonthLyLimit.value.toStringAsFixed(precision)} ${controller.selectSenderWallet.value!.currency.code}',
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical * 2,
        bottom: Dimensions.marginSizeVertical,
      ),
      child: Obx(
        () => controller.isSendMoneyLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                buttonColor: controller.isValidUser.value &&
                        double.parse(controller
                                .remainingController.senderAmount.value) <=
                            controller.dailyLimit.value &&
                        double.parse(controller
                                .remainingController.senderAmount.value) <=
                            controller.monthlyLimit.value
                    ? CustomColor.primaryLightColor
                    : CustomColor.primaryLightColor.withOpacity(alpha:0.3),
                title: Strings.makePayment,
                onPressed: () {
                  if (controller.isValidUser.value &&
                      double.parse(controller
                              .remainingController.senderAmount.value) <=
                          controller.dailyLimit.value &&
                      double.parse(controller
                              .remainingController.senderAmount.value) <=
                          controller.monthlyLimit.value) {
                    if (dashboardController.kycStatus.value == 1) {
                      controller.makePaymentProcess().then(
                            (value) => StatusScreen.show(
                              context: context,
                              subTitle: controller
                                  .makePaymentModelData.message.success.first,
                              showAppName: false,
                              onPressed: () {
                                Get.offAllNamed(Routes.bottomNavBarScreen);
                              },
                            ),
                          );
                    } else {
                      CustomSnackBar.error(Strings.pleaseSubmitYourInformation);
                      Future.delayed(const Duration(seconds: 2), () {
                        Get.toNamed(Routes.updateKycScreen);
                      });
                    }
                  }
                },
              ),
      ),
    );
  }
}
