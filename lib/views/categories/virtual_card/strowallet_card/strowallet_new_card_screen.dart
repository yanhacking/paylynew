import 'package:qrpay/routes/routes.dart';

import '../../../../backend/model/wallets/wallets_model.dart';
import '../../../../backend/utils/custom_loading_api.dart';
import '../../../../controller/categories/virtual_card/strowallet_card/strowallelt_info_controller.dart';
import '../../../../custom_assets/assets.gen.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../../widgets/appbar/appbar_widget.dart';
import '../../../../widgets/inputs/input_with_text.dart';
import '../../../../widgets/others/strowallet_flipcard.dart';
import '../../../../widgets/payment_link/custom_drop_down.dart';

class CrateStrowalletScreen extends StatelessWidget {
  CrateStrowalletScreen({super.key});
  final controller = Get.put(VirtualStrowalletCardController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBarWidget(text: controller.appBarTitle.value),
        body: controller.isLoading ||
                controller.isBuyCardLoading ||
                controller.isCreateCardInfoLoading
            ? const CustomLoadingAPI()
            : _bodyWidget(context),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    var data = controller.strowalletCardCreateInfo.data;
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize * 0.7),
      children: [
        if (data.customerExistStatus == false) ...[
          _customerCreate(context),
        ] else if (data.customerExistStatus == true &&
            data.customerKycStatus != 'high kyc') ...[
          _customerUpdate(context),
        ] else ...[
          _imageWidget(context),
          _amountFields(context),
          _fromWallet(context),
          _chargeWidget(context),
          _buttonWidget(context),
        ]
      ],
    );
  }

  _customerCreate(BuildContext context) {
    return Visibility(
      visible: controller.strowalletCardModel.data.user.strowalletCustomer == ""
          ? true
          : false,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: crossStart,
          children: [
            verticalSpace(Dimensions.heightSize * 0.5),
            ...controller.inputFields.map((element) {
              return element;
            }),
            _customerCreateButtonWidget(context)
          ],
        ),
      ),
    );
  }

  _customerCreateButtonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.paddingSize * 1.4,
        bottom: Dimensions.paddingSize * 4.8,
      ),
      child: Obx(
        () => controller.isCustomerCreateLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.submit,
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    controller.customerCreateProcess().then((v) {
                      Get.offAllNamed(Routes.bottomNavBarScreen);
                    });
                  }
                },
                borderColor: CustomColor.primaryLightColor,
                buttonColor: CustomColor.primaryLightColor,
              ),
      ),
    );
  }

  _customerUpdate(BuildContext context) {
    var data = controller.strowalletCardCreateInfo.data;
    return Container(
      padding: EdgeInsets.all(Dimensions.paddingSize * 0.8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius * 2),
        color: CustomColor.kDarkBlue,
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          const TitleHeading3Widget(text: Strings.statusOfTheCustomer),
          verticalSpace(Dimensions.widthSize * 0.5),
          TitleHeading4Widget(
            text: data.customerExist.status.toUpperCase(),
            color: CustomColor.yellowColor,
          ),
          verticalSpace(Dimensions.heightSize * 0.3),
          TitleHeading4Widget(text: data.customerLowKycText),
          verticalSpace(Dimensions.heightSize),
          PrimaryButton(
            title: Strings.updateCustomer,
            onPressed: () {
              Get.toNamed(Routes.updateCustomerKycScreen);
            },
          ),
        ],
      ),
    );
  }

  _imageWidget(BuildContext context) {
    return StrowalletFlipCardWidget(
      title: Strings.visa,
      availableBalance: Strings.cardHolder,
      cardNumber: 'xxxx xxxx xxxx xxxx',
      expiryDate: 'xx/xx',
      balance: 'xx',
      validAt: 'xx',
      cvv: 'xxx',
      logo: Assets.logo.appLauncher.path,
      isNetworkImage: false,
    );
  }

  _amountFields(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.paddingSize),
      child: Column(
        children: [
          PrimaryInputWidget(
            keyboardType: TextInputType.text,
            hint: Strings.enterCardHolderName,
            label: Strings.cardHolderName,
            controller: controller.cardHolderNameController,
          ),
          verticalSpace(Dimensions.marginBetweenInputBox),
          InputWithText(
            controller: controller.fundAmountController,
            hint: Strings.zero00,
            label: Strings.amount,
            suffixText: controller.strowalletCardModel.data.baseCurr,
            onChanged: (value) {
              controller.getStrowalletCardInfo();
            },
          ),
        ],
      ),
    );
  }

  _fromWallet(BuildContext context) {
    return Obx(
      () => Container(
        margin: EdgeInsets.symmetric(vertical: Dimensions.heightSize),
        child: CustomDropDown<MainUserWallet>(
          dropDownHeight: Dimensions.inputBoxHeight * 0.9,
          items: controller.walletsList,
          title: Strings.fromWallet,
          hint: controller.selectMainWallet.value!.title,
          onChanged: (value) {
            controller.selectMainWallet.value = value!;
            controller.fromCurrency.value =
                value.currency.code.toString();

            print(controller.fromCurrency.value); 
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

  

  _chargeWidget(BuildContext context) {
    var userData = controller.strowalletCardModel.data;
    return Column(
      mainAxisAlignment: mainCenter,
      children: [
        Row(
          mainAxisAlignment: mainSpaceBet,
          children: [
            const TitleHeading4Widget(text: Strings.totalCharge),
            Obx(
              () => TitleHeading4Widget(
                text: "${controller.totalCharge.value} ${userData.baseCurr}",
                fontSize: Dimensions.headingTextSize5,
              ),
            ),
          ],
        ),
        verticalSpace(Dimensions.heightSize * 0.4),
        Row(
          mainAxisAlignment: mainSpaceBet,
          children: [
            const TitleHeading4Widget(text: Strings.totalPay),
            Obx(
              () => TitleHeading4Widget(
                text: "${controller.totalPay.value} ${userData.baseCurr}",
                fontSize: Dimensions.headingTextSize5,
              ),
            ),
          ],
        ),
      ],
    );
  }


  _buttonWidget(BuildContext context) {
    // var data = controller.strowalletCardModel.data.cardCharge;
    return Container(
      margin: EdgeInsets.only(
          top: Dimensions.paddingSize * 1.4,
          bottom: Dimensions.paddingSize * 4.8),
      child: Obx(
        () => controller.isBuyCardLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.confirm,
                onPressed: () {
                  // double amount =
                  //     double.parse(controller.fundAmountController.text);
                  // if (data.minLimit <= amount && data.maxLimit >= amount) {
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
}
