import '../../../../backend/model/wallets/wallets_model.dart';
import '../../../../backend/utils/custom_loading_api.dart';
import '../../../../controller/categories/virtual_card/stripe_card/stripe_card_controller.dart';
import '../../../../custom_assets/assets.gen.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../../widgets/inputs/custom_input_with_drop_down.dart';
import '../../../../widgets/others/flip_card_widget.dart';
import '../../../../widgets/payment_link/custom_drop_down.dart';

class StripeCreateCardScreen extends StatelessWidget {
  const StripeCreateCardScreen({super.key, required this.controller});
  final StripeCardController controller;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(
        () => controller.isLoading
            ? const CustomLoadingAPI()
            : _bodyWidget(context),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.7),
      children: [
        _imageWidget(context),
        _inputFields(context),
        _limitBalance(context),
        _buttonWidget(context),
      ],
    );
  }

  _imageWidget(BuildContext context) {
    return CrateFlipCardWidget(
      title: Strings.visa,
      availableBalance: Strings.cardHolder,
      cardNumber: 'xxxx xxxx xxxx xxxx',
      expiryDate: 'xx/xx',
      balance: 'xx',
      validAt: 'xx',
      cvv: 'xxx',
      logo: Assets.logo.logo.path,
      isNetworkImage: false,
    );
  }

  _inputFields(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: Dimensions.paddingSize),
          child: CustomInputWithDropDown(
            controller: controller.fundAmountController,
            hint: Strings.zero00,
            label: Strings.amount,
            selectedItem: controller.selectedSupportedCurrency,
            itemList: controller.supportedCurrencyList,
            displayItem: (item) => item.code,
            onDropChanged: (value) {
              controller.selectedSupportedCurrency.value = value;
              controller.updateLimit();
              controller.calculation();
            },
            onFieldChanged: (value) {
              controller.calculation();
            },
          ),
        ),
        verticalSpace(Dimensions.marginBetweenInputBox),
        _fromWallet(context),
      ],
    );
  }

  _limitBalance(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical * 0.3,
        bottom: Dimensions.marginSizeVertical * 2,
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Row(
            children: [
              TitleHeading4Widget(
                text: Strings.limit,
                color: CustomColor.primaryLightColor,
              ),
              TitleHeading4Widget(
                text:
                    ": ${controller.limitMin} ${controller.selectMainWallet.value!.currency.code} - ${controller.limitMax} ${controller.selectMainWallet.value!.currency.code}",
                color: CustomColor.primaryLightColor,
              ),
            ],
          ),
          verticalSpace(Dimensions.heightSize * 0.3),
          _chargeWidget(context)
        ],
      ),
    );
  }

  _chargeWidget(BuildContext context) {
    return Column(
      mainAxisAlignment: mainCenter,
      children: [
        Row(
          children: [
            TitleHeading4Widget(
              text: Strings.totalCharge,
              color: CustomColor.primaryLightColor,
            ),
            Obx(
              () => TitleHeading4Widget(
                text:
                    ": ${controller.totalCharge.value} ${controller.selectedSupportedCurrency.value!.code}",
                fontSize: Dimensions.headingTextSize5,
                color: CustomColor.primaryLightColor,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize * 0.4),
        Row(
          children: [
            TitleHeading4Widget(
              text: Strings.totalPay,
              color: CustomColor.primaryLightColor,
            ),
            Obx(
              () => TitleHeading4Widget(
                text:
                    ": ${controller.totalPay.value} ${controller.selectedSupportedCurrency.value!.code}",
                fontSize: Dimensions.headingTextSize5,
                color: CustomColor.primaryLightColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.paddingSize * 1.4),
      child: Obx(
        () => controller.isBuyCardLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.confirm,
                onPressed: () {
                  // double amount =
                  //     double.parse(controller.fundAmountController.text);
                  // if (controller.limitMin >= amount &&
                  //     controller.limitMax >= amount) {
                    controller.buyCardProcess(context);
                  // } else {
                  //   CustomSnackBar.error(Strings.pleaseFollowTheLimit);
                  // }
                },
                borderColor: CustomColor.primaryLightColor,
                buttonColor: CustomColor.primaryLightColor,
              ),
      ),
    );
  }

  _fromWallet(BuildContext context) {
    return Obx(
      () => CustomDropDown<MainUserWallet>(
        dropDownHeight: Dimensions.inputBoxHeight * 0.9,
        items: controller.walletsList,
        title: Strings.fromWallet,
        hint: controller.selectMainWallet.value!.title,
        onChanged: (value) {
          controller.selectMainWallet.value = value!;
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
