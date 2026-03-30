import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';

import '../../../backend/utils/custom_loading_api.dart';
import '../../../backend/utils/custom_snackbar.dart';
import '../../../controller/categories/withdraw_controller/withdraw_controller.dart';
import '../../../controller/navbar/dashboard_controller.dart';
import '../../../language/english.dart';
import '../../../routes/routes.dart';
import '../../../widgets/others/customInput_widget.dart/withdraw_keyboard_widget.dart';

class WithdrawScreen extends StatelessWidget {
  WithdrawScreen({super.key});

  final controller = Get.put(WithdrawController());
  final dashboardController = Get.find<DashBoardController>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: const AppBarWidget(text: Strings.withdraw),
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
      physics: const BouncingScrollPhysics(),
      children: [
        WithdrawKeyboardWidget(
          isLoading: controller.isInsertLoading.obs,
          buttonText: Strings.withdraw,
          onTap: () {
            if (dashboardController.kycStatus.value == 1) {
              debugPrint(controller.selectedCurrencyAlias.value);
              if (controller.amountTextController.text.isNotEmpty) {
                if (controller.selectedCurrencyType.value
                    .contains("AUTOMATIC")) {
                  if (controller.selectedCurrencyAlias.value
                      .contains('flutterwave')) {
                    controller.automaticPaymentFlutterwaveInsertProcess();
                  }
                } else {
                  controller.manualPaymentGetGatewaysProcess();
                }
              }
            } else {
              CustomSnackBar.error(Strings.pleaseSubmitYourInformation);
              Future.delayed(const Duration(seconds: 2), () {
                Get.toNamed(Routes.updateKycScreen);
              });
            }
          },
        ),
      ],
    );
  }
}
