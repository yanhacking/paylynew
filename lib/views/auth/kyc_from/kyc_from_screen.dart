// ignore_for_file: unnecessary_to_list_in_spreads

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/utils/custom_loading_api.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/widgets/appbar/back_button.dart';
import 'package:qrpay/widgets/buttons/primary_button.dart';
import 'package:qrpay/widgets/inputs/password_input_widget.dart';
import 'package:qrpay/widgets/inputs/phone_number_with_contry_code_input.dart';
import 'package:qrpay/widgets/inputs/primary_input_filed.dart';

import '../../../backend/local_storage/local_storage.dart';
import '../../../controller/auth/registration/kyc_form_controller.dart';
import '../../../controller/auth/registration/otp_email_controoler.dart';
import '../../../controller/auth/registration/registration_controller.dart';
import '../../../language/english.dart';
import '../../../routes/routes.dart';
import '../../../utils/custom_color.dart';
import '../../../utils/size.dart';
import '../../../widgets/inputs/profile_country_picker.dart';
import '../../../widgets/text_labels/title_heading2_widget.dart';
import '../../../widgets/text_labels/title_heading4_widget.dart';

class KycFromScreen extends StatelessWidget {
  KycFromScreen({super.key});

  final emailController = Get.put(EmailOtpController());

  final registrationController = Get.put(RegistrationController());
  final kycController = Get.put(BasicDataController());
  final _forkKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          leading: BackButtonWidget(
            onTap: () {
              Get.offAllNamed(Routes.registrationScreen);
            },
          ),
        ),
        body: Obx(
          () => kycController.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize),
      physics: const BouncingScrollPhysics(),
      children: [
        _titleAndSubtitleWidget(context),
        _inputWidget(context),
        _buttonWidget(context),
      ],
    );
  }

  _titleAndSubtitleWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical,
        bottom: Dimensions.marginSizeVertical * 1.4,
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          TitleHeading2Widget(text: Strings.kYCForm),
          verticalSpace(Dimensions.heightSize * 0.7),
          const TitleHeading4Widget(text: Strings.kYCFormDetails),
        ],
      ),
    );
  }

  _inputWidget(BuildContext context) {
    return Form(
      key: _forkKey,
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          Row(
            children: [
              Expanded(
                child: PrimaryInputWidget(
                  hint: Strings.enterFirstName.tr,
                  label: Strings.firstName.tr,
                  controller: kycController.firstNameController,
                ),
              ),
              horizontalSpace(Dimensions.widthSize),
              Expanded(
                child: PrimaryInputWidget(
                  hint: Strings.enterLastName.tr,
                  label: Strings.lastName.tr,
                  controller: kycController.lastNameController,
                ),
              ),
            ],
          ),
          verticalSpace(Dimensions.heightSize),
          PrimaryInputWidget(
            readOnly: registrationController.selectedRegID.value == 0,
            controller: registrationController.emailController,
            hint: Strings.enterEmailAddress.tr,
            label: Strings.emailAddress.tr,
            keyboardType: TextInputType.emailAddress,
            isValidator: LocalStorages.isEmailVerification(),
          ),
          verticalSpace(Dimensions.heightSize),
          IgnorePointer(
            ignoring: registrationController.selectedRegID.value == 1,
            child: Column(
              crossAxisAlignment: crossStart,
              children: [
                TitleHeading4Widget(
                  text: Strings.country.tr,
                  fontWeight: FontWeight.w600,
                ),
                verticalSpace(Dimensions.heightSize * 0.7),
                ProfileCountryCodePickerWidget(
                  initialSelection: registrationController.countryName.value,
                  onChanged: (value) {
                    registrationController.selectedPhoneCode.value =
                        value.dialCode!;
                    registrationController.countryCode.value = value.dialCode!;
                    registrationController.countryName.value = value.name!;
                  },
                ),
              ],
            ),
          ),
          verticalSpace(Dimensions.heightSize * 0.6),
          PhoneNumberInputWidget(
            countryCode: registrationController.countryCode,
            controller: registrationController.phoneNumberController,
            hint: Strings.xxx.tr,
            label: Strings.phoneNumber.tr,
            keyBoardType: TextInputType.number,
            readOnly: registrationController.selectedRegID.value == 1,
            isValidator: LocalStorages.isSmsVerification(),
          ),
          verticalSpace(Dimensions.heightSize * 0.6),
          Row(
            children: [
              Expanded(
                child: PrimaryInputWidget(
                  hint: Strings.enterCity.tr,
                  label: Strings.city.tr,
                  controller: kycController.cityController,
                ),
              ),
              horizontalSpace(Dimensions.widthSize),
              Expanded(
                child: PrimaryInputWidget(
                  keyboardType: TextInputType.text,
                  hint: Strings.enterZipCode.tr,
                  label: Strings.zipCode.tr,
                  controller: kycController.zipCodeController,
                ),
              ),
            ],
          ),
          // verticalSpace(Dimensions.heightSize * 0.6),
          // if (kycController.referralSystem.value)
          //   PrimaryInputWidget(
          //     keyboardType: TextInputType.text,
          //     hint: Strings.enterReferralId,
          //     optionalLabel: Strings.optional,
          //     label: Strings.referralId,
          //     controller: kycController.referralIdController,
          //     isValidator: false,
          //   ),
          Visibility(
            visible: kycController.inputFileFields.isNotEmpty,
            child: Container(
              margin: EdgeInsets.only(
                top: Dimensions.marginSizeVertical * 0.5,
              ),
              height: kycController.inputFileFields.length == 2
                  ? MediaQuery.of(context).size.height * 0.20
                  : MediaQuery.of(context).size.height * 0.25,
              child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: kycController.inputFileFields.length,
                  itemBuilder: (BuildContext context, int index) {
                    return kycController.inputFileFields[index];
                  }),
            ),
          ),
          Obx(() {
            return Column(
              children: [
                ...kycController.inputFields.map((element) {
                  return element;
                }).toList(),
                verticalSpace(Dimensions.heightSize * 0.5),
              ],
            );
          }),
          horizontalSpace(Dimensions.widthSize),
          PasswordInputWidget(
            controller: kycController.passwordController,
            hint: Strings.enterPassword.tr,
            label: Strings.newPassword.tr,
          ),
          verticalSpace(Dimensions.heightSize),
          PasswordInputWidget(
            controller: kycController.confirmPasswordController,
            hint: Strings.enterConfirmPassword.tr,
            label: Strings.confirmPassword.tr,
          ),
          FittedBox(
            child: Row(
              children: [
                Obx(
                  () => SizedBox(
                    width: 20,
                    child: Checkbox(
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(Dimensions.radius * 0.3),
                      ),
                      fillColor: WidgetStateProperty.all(
                        CustomColor.primaryLightColor,
                      ),
                      value: kycController.termsAndCondition.value,
                      onChanged: kycController.termsAndCondition.call,
                      side: WidgetStateBorderSide.resolveWith(
                        (states) => BorderSide(
                          width: 1.4,
                          color: CustomColor.primaryLightColor.withOpacity(alpha:0.2),
                        ),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: TitleHeading4Widget(
                    color: CustomColor.primaryLightColor,
                    fontSize: Dimensions.headingTextSize5,
                    fontWeight: FontWeight.w500,
                    text: Strings.agreed.tr,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical * 1.4),
      child: Obx(
        () => kycController.isLoading
            ? const CustomLoadingAPI()
            : PrimaryButton(
                title: Strings.continuee.tr,
                onPressed: () {
                  if (_forkKey.currentState!.validate()) {
                    kycController.registrationProcess();
                  }
                },
              ),
      ),
    );
  }
}
