import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/routes/routes.dart';
import 'kyc_form_controller.dart';
 
 
class OtpSmsController extends GetxController {
  final basicDataController = Get.put(BasicDataController());
  final smsOtpInputController = TextEditingController();

  bool hasError = false;
  RxString currentText = "".obs; 
   

  
   
   
     
  changeCurrentText(value) {
    currentText.value = value;
  }

  @override
  void dispose() {
    timer?.cancel();
    smsOtpInputController.dispose();
    super.dispose();
  }

  @override
  void onInit() {
    timerInit();
    super.onInit();
  }

  final _isVerifyCode = false.obs;

  bool get isVerifyCode => _isVerifyCode.value;

  timerInit() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining.value != 0) {
        secondsRemaining.value--;
      } else {
        enableResend.value = true;
      }
    });
  }

  RxInt secondsRemaining = 59.obs;
  RxInt minuteRemaining = 00.obs;
  RxBool enableResend = false.obs;
  Timer? timer;

  resendCode() {
    secondsRemaining.value = 59;
    enableResend.value = false;
  }

  void onPressedSigninOtpSubmit() {
    Get.toNamed(Routes.kycFromScreen);
  }
}
