import 'package:google_fonts/google_fonts.dart';
import 'package:qrpay/widgets/others/glass_widget.dart';

import '../../../backend/local_storage/local_storage.dart';
import '../../../backend/utils/custom_loading_api.dart';
import '../../../controller/auth/login/signin_controller.dart';
import '../../../controller/auth/registration/kyc_form_controller.dart';
import '../../../controller/fingerprint/fingerprint_controller.dart';
import '../../../language/language_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/basic_screen_imports.dart';
import '../../../utils/responsive_layout.dart';
import '../../../widgets/buttons/custom_text_button.dart';
import '../../../widgets/inputs/country_picker_input_widget.dart';
import '../../../widgets/inputs/password_input_widget.dart';
import '../../../widgets/inputs/phone_number_with_contry_code_input.dart';
import '../../../widgets/logo/basic_logo_widget.dart';
import '../../../widgets/others/auth_dropdown.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final controller = Get.put(SignInController());
  final phoneNumberFormKey = GlobalKey<FormState>();
  final signInFormKey = GlobalKey<FormState>();
  final forgotPasswordFormKey = GlobalKey<FormState>();
  final fingerprintController = Get.put(FingerprintController());
  final languageController = Get.put(LanguageController());
  final basicDataController = Get.put(BasicDataController());

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Obx(
          () => basicDataController.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSize * 0.05,
      ),
      physics: const BouncingScrollPhysics(),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          _logoWidget(
            context,
            logoHeight: height * 0.27,
          ),
          _bottomContainerWidget(
            context,
            child: Column(
              mainAxisSize: mainMin,
              children: [
                _titleAndSubtitleWidget(context),
                _inputAndForgotWidget(context),
                _buttonWidget(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _logoWidget(BuildContext context, {required double logoHeight}) {
    return Container(
      margin: EdgeInsets.only(top: Dimensions.marginSizeVertical * 1.2),
      height: logoHeight,
      padding: EdgeInsets.only(
        top: Dimensions.marginSizeVertical * 3,
        bottom: Dimensions.marginSizeVertical * 1.5,
      ),
      child: BasicLogoWidget(),
    );
  }

  _bottomContainerWidget(BuildContext context, {required Widget child}) {
    Radius borderRadius = const Radius.circular(20);
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: Dimensions.marginSizeHorizontal * 0.5,
      ),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? CustomColor.primaryBGDarkColor
            : CustomColor.primaryBGLightColor,
        borderRadius: BorderRadius.only(
          topLeft: borderRadius,
          topRight: borderRadius,
        ),
        boxShadow: [
          BoxShadow(
            color: CustomColor.primaryLightColor.withOpacity(alpha:0.015),
            spreadRadius: 7,
            blurRadius: 5,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      padding: EdgeInsets.all(Dimensions.paddingSize),
      child: child,
    );
  }

  _titleAndSubtitleWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: Dimensions.marginSizeVertical * 0.5,
      ),
      child: Column(
        crossAxisAlignment: crossStart,
        children: [
          TitleHeading2Widget(
            text: Strings.signInInformation.tr,
          ),
          verticalSpace(Dimensions.heightSize * 0.5),
          TitleHeading4Widget(
            text: Strings.signInInformationSubtitle.tr,
          ),
        ],
      ),
    );
  }

  _inputAndForgotWidget(BuildContext context) {
    return Obx(
      () => Form(
        key: signInFormKey,
        child: Column(
          crossAxisAlignment: crossStart,
          children: [
            const TitleHeading4Widget(
              text: Strings.loginType,
              fontWeight: FontWeight.w600,
            ),
            verticalSpace(7),
             AuthDropdown<String>(
              labelColor: CustomColor.blackColor,
              itemsList: controller.logInTypeList,
              selectMethod: controller.selectedLogInType,
              onChanged: (v) {
                controller.selectedLogInID.value = v == 'Email' ? 0 : 1;
              },
            ), 

            // InputDropDown(
            //   itemsList: controller.logInTypeList,
            //   selectMethod: controller.selectedLogInType,
            //   onChanged: (v) {
            //     controller.selectedLogInType.value = v!;
            //     controller.selectedLogInID.value = v == 'Email' ? 0 : 1;
            //   },
            // ),
             
             verticalSpace(Dimensions.heightSize),
            _emailInputWidget(),
            _phoneInputWidget(),
            verticalSpace(Dimensions.heightSize * 0.7),
            if (controller.selectedLogInID.value != -1)
              PasswordInputWidget(
                controller: controller.passwordController,
                hint: Strings.password.tr,
                label: Strings.password.tr,
              ),
            verticalSpace(Dimensions.heightSize * 0.3),
            InkWell(
              onTap: () => _openDialogue(context),
              child: TitleHeading4Widget(
                fontWeight: FontWeight.w600,
                fontSize: Dimensions.headingTextSize5,
                color: Get.isDarkMode
                    ? CustomColor.primaryDarkTextColor
                    : CustomColor.primaryTextColor,
                text: Strings.forgotPassword.tr,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical,
        bottom: Dimensions.marginSizeVertical,
      ),
      child: Column(
        mainAxisAlignment: mainCenter,
        children: [
          Obx(
            () => controller.isLoading
                ? const CustomLoadingAPI()
                : PrimaryButton(
                    title: Strings.signIn.tr,
                    onPressed: () {
                      if (signInFormKey.currentState!.validate()) {
                        controller.loginProcess();
                      }
                    },
                    buttonTextColor: CustomColor.whiteColor,
                  ),
          ),
          verticalSpace(Dimensions.heightSize),
          Visibility(
            visible:
                fingerprintController.supportState == SupportState.supported &&
                    LocalStorages.isLoggedIn(),
            child: PrimaryButton(
              title: Strings.signInWithTouchId.tr,
              onPressed: () async {
                bool isAuthenticated =
                    await Authentication.authenticateWithBiometrics();

                if (isAuthenticated) {
                  Get.offAndToNamed(Routes.bottomNavBarScreen);
                } else {
                  debugPrint('isAuthenticated : false');
                }
              },
              buttonTextColor: CustomColor.whiteColor,
            ),
          ),
          verticalSpace(Dimensions.heightSize * 2.5),
          Obx(
            () => RichText(
              text: TextSpan(
                text: languageController.getTranslation(Strings.haveAccount),
                style: GoogleFonts.inter(
                  fontSize: Dimensions.headingTextSize5,
                  color: Get.isDarkMode
                      ? CustomColor.primaryDarkTextColor.withOpacity(alpha:0.8)
                      : CustomColor.primaryTextColor.withOpacity(alpha:0.8),
                  fontWeight: FontWeight.w500,
                ),
                children: [
                  WidgetSpan(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.widthSize * 0.3,
                      ),
                      child: CustomTextButton(
                        onPressed: () {
                          controller.onPressedSignUP();
                        },
                        text: languageController
                            .getTranslation(Strings.richSignUp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _openDialogue(
    BuildContext context,
  ) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.transparent,
        alignment: Alignment.center,
        insetPadding: EdgeInsets.all(Dimensions.paddingSize * 0.3),
        contentPadding: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Builder(
          builder: (context) {
            var width = MediaQuery.of(context).size.width;
            return Stack(
              children: [
                Container(
                  width: width * 0.84,
                  margin: EdgeInsets.all(Dimensions.paddingSize * 0.5),
                  padding: EdgeInsets.all(Dimensions.paddingSize * 0.9),
                  decoration: BoxDecoration(
                    color: Get.isDarkMode
                        ? CustomColor.primaryBGDarkColor
                        : CustomColor.whiteColor,
                    borderRadius:
                        BorderRadius.circular(Dimensions.radius * 1.4),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: crossStart,
                    children: [
                      SizedBox(height: Dimensions.heightSize * 2),
                      TitleHeading2Widget(text: Strings.forgotPassword.tr),
                      verticalSpace(Dimensions.heightSize * 0.5),
                      TitleHeading4Widget(
                          text: Strings.pleaseEnterYourRegister.tr),
                      SizedBox(height: Dimensions.heightSize * 1),
                       AuthDropdown<String>(
              labelColor: CustomColor.blackColor,
              itemsList: controller.logInTypeList,
              selectMethod: controller.selectedLogInType,
              onChanged: (v) {
                controller.selectedLogInID.value = v == 'Email' ? 0 : 1;
              },
            ), 
                      Obx(
                        () => Form(
                          key: forgotPasswordFormKey,
                          child: Column(
                            crossAxisAlignment: crossStart,
                            children: [
                              verticalSpace(Dimensions.heightSize * 0.5),
                              if (controller.selectedLogInType.value ==
                                  'Email') ...[
                                PrimaryInputWidget(
                                  controller: controller.emailForgotController,
                                  hint: Strings.enterEmailAddress.tr,
                                  label: Strings.emailAddress.tr,
                                ),
                              ] else ...[
                                const TitleHeading4Widget(
                                  text: Strings.selectCountry,
                                  fontWeight: FontWeight.w600,
                                ),
                                verticalSpace(Dimensions.heightSize * 0.7),
                                ProfileCountryCodePickerWidget(
                                  initialSelection: 'US',
                                  onChanged: (value) {
                                    controller.selectedPhoneCode.value =
                                        value.toString();
                                  },
                                  controller: controller.countryController,
                                ),
                                PhoneNumberInputWidget(
                                  readOnly: false,
                                  countryCode: controller.selectedPhoneCode,
                                  controller:
                                      controller.phoneNumberForgotController,
                                  hint: Strings.enterPhone,
                                  label: Strings.phoneNumber,
                                ),
                              ],
                              verticalSpace(Dimensions.heightSize * 0.5),
                            ],
                          ),
                        ),
                      ),
                      verticalSpace(Dimensions.heightSize * 0.5),
                      Obx(
                        () => controller.isSendForgotOTPLoading
                            ? const CustomLoadingAPI()
                            : PrimaryButton(
                                title: Strings.forgotPassword.tr,
                                onPressed: () {
                                  if (forgotPasswordFormKey.currentState!
                                      .validate()) {
                                    controller.goToForgotEmailVerification();
                                  }
                                },
                                borderColor: CustomColor.primaryLightColor,
                              ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                      onTap: () {
                        Get.back();
                      },
                      child: CircleAvatar(
                        backgroundColor: CustomColor.primaryLightColor,
                        child: const Icon(
                          Icons.close,
                          color: CustomColor.whiteColor,
                        ),
                      )),
                ),
              ],
            );
          },
        ),
      ).customGlassWidget(
        blurY: 1,
        blurX: 1,
      ),
    );
  }

  _emailInputWidget() {
    return controller.selectedLogInID.value == 0
        ? PrimaryInputWidget(
            controller: controller.emailController,
            hint: Strings.enterEmailAddress.tr,
            label: Strings.emailAddress.tr,
          )
        : Container();
  }

  _phoneInputWidget() {
    return controller.selectedLogInID.value == 1
        ? Column(
            crossAxisAlignment: crossStart,
            children: [
              const TitleHeading4Widget(
                text: Strings.selectCountry,
                fontWeight: FontWeight.w600,
              ),
              verticalSpace(Dimensions.heightSize * 0.7),
              ProfileCountryCodePickerWidget(
                initialSelection: 'US',
                onChanged: (value) {
                  controller.selectedPhoneCode.value = value.toString();
                },
                controller: controller.countryController,
              ),
              PhoneNumberInputWidget(
                readOnly: false,
                countryCode: controller.selectedPhoneCode,
                controller: controller.phoneNumberController,
                hint: Strings.enterPhone,
                label: Strings.phoneNumber,
              ),
            ],
          )
        : Container();
  }
}
