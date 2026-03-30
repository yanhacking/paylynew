import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/model/auth/registation/check_register_user_model.dart';
import 'package:qrpay/routes/routes.dart';

import '../../../backend/local_storage/local_storage.dart';
import '../../../backend/model/common/common_success_model.dart';
import '../../../backend/services/api_services.dart';
import '../../../backend/utils/logger.dart';

final log = logger(RegistrationController);

class RegistrationController extends GetxController {
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final phoneController = TextEditingController();
  @override
  void onInit() {
    emailController.text = "user@appdevs.net";
    super.onInit();
  }

  @override
  void dispose() {
    phoneNumberController.dispose();

    super.dispose();
  }

  RxString selectedPhoneCode = '+1'.obs;
  RxString countryName = 'United States'.obs;
  RxString countryCode = "+1".obs;

  RxString verify = ''.obs;
  RxInt resendAuthToken = 0.obs;

  void onTapContinue() {
    Get.toNamed(Routes.emailOtpScreen);
  }

  void onPressedSignIn() {
    Get.toNamed(Routes.signInScreen);
  }

  File? fronImage;
  File? backImage;

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late CheckRegisterUserModel _checkRegisterUserModel;

  CheckRegisterUserModel get checkRegisterUserModel => _checkRegisterUserModel;

  Future<CheckRegisterUserModel> checkExistUserProcess() async {
    _isLoading.value = true;
    update();
    Map<String, dynamic> inputBody = {
      'register_type': selectedRegID.value == 0 ? 'Email' : 'Phone',
      'credentials': selectedRegID.value == 0
          ? "Sdfsld@gamil.com"
          : phoneNumberController.text,
      'mobile_code': selectedPhoneCode.value,
    };

    await ApiServices.checkRegisterApi(body: inputBody).then((value) {
      _checkRegisterUserModel = value!;
      if (selectedRegID.value == 0) {
        if (LocalStorages.isEmailVerification()) {
          Get.toNamed(Routes.emailOtpScreen);
          sendOTPEmailProcess();
        } else {
          Get.toNamed(Routes.kycFromScreen);
        }
      } else {
        if (LocalStorages.isSmsVerification()) {
          Get.toNamed(Routes.smsOtpScreen);
          sendOTPEmailProcess();
        } else {
          Get.toNamed(Routes.kycFromScreen);
        }
      }
      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _checkRegisterUserModel;
  }

  final isVerifyCode = false.obs;

  final _isSendOTPLoading = false.obs;

  bool get isSendOTPLoading => _isSendOTPLoading.value;

  late CommonSuccessModel _sendOTPEmailModel;

  CommonSuccessModel get sendOTPEmailModel => _sendOTPEmailModel;

  Future<CommonSuccessModel> sendOTPEmailProcess() async {
    _isSendOTPLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'register_type': selectedRegID.value == 0 ? 'Email' : 'Phone',
      'credentials': selectedRegID.value == 0
          ? emailController.text
          : phoneNumberController.text,
      'mobile_code': selectedPhoneCode.value,
      'agree': '1',
    };

    await ApiServices.sendRegisterOTPEmailApi(body: inputBody).then((value) {
      _sendOTPEmailModel = value!;

      _isSendOTPLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isSendOTPLoading.value = false;
    update();
    return _sendOTPEmailModel;
  }

  final _isLoading2 = false.obs;

  bool get isLoading2 => _isLoading2.value;

  late CommonSuccessModel _verifyEmailModel;

  CommonSuccessModel get verifyEmailModel => _verifyEmailModel;

  // Verify email process function
  Future<CommonSuccessModel> verifyEmailProcess(
      {required String otpCode}) async {
    _isLoading2.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'email': emailController.text,
      'code': otpCode,
    };

    await ApiServices.verifyRegisterEmailApi(body: inputBody).then((value) {
      _verifyEmailModel = value!;
      _isLoading2.value = false;

      update();
      Get.toNamed(Routes.kycFromScreen);
    }).catchError((onError) {
      _isLoading2.value = false;
      log.e(onError);
    });

    _isLoading2.value = false;
    update();
    return _verifyEmailModel;
  }

  // For Sms section
  late CommonSuccessModel _verifyPhoneModel;

  CommonSuccessModel get verifyPhoneModel => _verifyPhoneModel;

  Future<CommonSuccessModel> verifyPhoneOtpProcess(
      {required String otpCode}) async {
    _isLoading2.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'mobile': phoneNumberController.text,
      'code': otpCode,
      'mobile_code': selectedPhoneCode.value,
    };

    await ApiServices.verifyRegisterPhoneApi(body: inputBody).then((value) {
      _verifyPhoneModel = value!;
      _isLoading2.value = false;

      update();
      Get.toNamed(Routes.kycFromScreen);
    }).catchError((onError) {
      _isLoading2.value = false;
      log.e(onError);
    });

    _isLoading2.value = false;
    update();
    return _verifyPhoneModel;
  }

  List<String> logInTypeList = ['Phone', 'Email'];
  RxString selectedLogInType = 'Select Register Type'.obs;
  RxInt selectedRegID = (-1).obs;
}
