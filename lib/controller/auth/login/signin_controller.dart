import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/model/common/common_success_model.dart';

import '../../../backend/local_storage/local_storage.dart';
import '../../../backend/model/auth/login/login_model.dart';
import '../../../backend/services/api_endpoint.dart';
import '../../../backend/services/api_services.dart';
import '../../../backend/utils/request_process.dart';
import '../../../routes/routes.dart';

class SignInController extends GetxController {
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final passwordController = TextEditingController();
  final countryController = TextEditingController();

  // Text Editing Controller for forgot password
  final emailForgotController = TextEditingController();
  final phoneNumberForgotController = TextEditingController();

  RxString selectedPhoneCode = '+1'.obs;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  RxString countryCode = LocalStorages.getCountryCode()!.obs;
  RxString verify = ''.obs;
  RxInt resendAuthToken = 0.obs;
  RxInt twoFaStatus = 0.obs;
  RxInt twoFaVerified = 0.obs;
  RxBool isEmailVerification = true.obs;

  //!loading api
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late LoginModel _loginModel;

  LoginModel get loginModel => _loginModel;

  // Login process function
  Future<LoginModel> loginProcess() async {
    _isLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'login_type': selectedLogInID.value == 0 ? 'Email' : 'Phone',
      'credentials': selectedLogInID.value == 0
          ? emailController.text
          : phoneNumberController.text,
      'mobile_code': selectedPhoneCode.value,
      'password': passwordController.text,
    };

    await ApiServices.loginApi(body: inputBody).then((value) {
      _loginModel = value!;

      twoFaStatus.value = _loginModel.data.user.twoFactorStatus;
      twoFaVerified.value = _loginModel.data.user.twoFactorVerified;

      if (_loginModel.data.user.emailVerified == 0) {
        isEmailVerification.value = false;
        LocalStorages.saveToken(token: loginModel.data.token.toString());
        _goToEmailVerification();
      } else if (_loginModel.data.user.smsVerified == 0) {
        LocalStorages.saveToken(token: loginModel.data.token.toString());
        _goToPhoneVerification();
      } else {
        _goToSavedUser(_loginModel);
        if (twoFaStatus.value == 1 && twoFaVerified.value == 0) {
          Get.toNamed(Routes.otp2FaScreen);
        } else {
          LocalStorages.isLoginSuccess(isLoggedIn: true);
          LocalStorages.isLoggedIn();
          update();
          Get.offAllNamed(Routes.bottomNavBarScreen);
        }
      }

      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _loginModel;
  }

  //! Send OTP Email Process
  final _isSendOTPLoading = false.obs;

  bool get isSendOTPLoading => _isSendOTPLoading.value;
  late CommonSuccessModel _sendOTPEmailModel;

  CommonSuccessModel get sendOTPEmailModel => _sendOTPEmailModel;
  Future<CommonSuccessModel> sendOTPEmailProcess() async {
    _isSendOTPLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {};

    await ApiServices.sendOTPEmailApi(body: inputBody).then((value) {
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

  // Forget Password Email Process
  final _isLoading2 = false.obs;
  bool get isLoading2 => _isLoading2.value;
  late CommonSuccessModel _verifyEmailModel;
  CommonSuccessModel get verifyEmailModel => _verifyEmailModel;

  Future<CommonSuccessModel> verifyEmailProcess(
      {required String otpCode}) async {
    _isLoading2.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'code': otpCode,
    };

    await ApiServices.verifyEmailApi(body: inputBody).then((value) {
      _verifyEmailModel = value!;

      _isLoading2.value = false;
      update();

      /// this is for 2fa check
      if (twoFaStatus.value == 1 && twoFaVerified.value == 0) {
        Get.toNamed(Routes.otp2FaScreen);
      } else {
        LocalStorages.isLoginSuccess(isLoggedIn: true);
        LocalStorages.isLoggedIn();
        update();
        Get.offAllNamed(Routes.bottomNavBarScreen);
      }
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading2.value = false;
    update();
    return _verifyEmailModel;
  }

  RxBool isVerifyCode = false.obs;
  RxBool isSMSVerification = true.obs;

  void _goToSavedUser(LoginModel loginModel) {
    LocalStorages.saveToken(token: loginModel.data.token.toString());
    LocalStorages.saveId(id: loginModel.data.user.id.toString());
  }

  void _goToEmailVerification() {
    sendOTPEmailProcess();
    Get.toNamed(Routes.emailVerificationScreen);
  }

  void _goToPhoneVerification() {
    smsOtpProcess();
    Get.toNamed(Routes.phoneVerificationScreen);
  }

  goToForgotEmailVerification() {
    sendForgotOTPEmailProcess();
  }

  void onPressedSignUP() {
    Get.toNamed(Routes.registrationScreen);
  }

  List<String> logInTypeList = ['Phone', 'Email'];
  RxString selectedLogInType = 'Select Login Type'.obs;
  RxInt selectedLogInID = (-1).obs;

  // sms send otp
  final _isSmsOtpLoading = false.obs;
  bool get isSmsOtpLoading => _isSmsOtpLoading.value;

  late CommonSuccessModel _commonSuccessModel;
  CommonSuccessModel get commonSuccessModel => _commonSuccessModel;
  Future<CommonSuccessModel?> smsOtpProcess() async {
    Map<String, dynamic> inputBody = {};

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.sendOTPSmsURL,
      isLoading: _isSmsOtpLoading,
      method: HttpMethod.POST,
      body: inputBody,
      onSuccess: (value) {
        _commonSuccessModel = value!;
      },
    );
  }

  final _isVerifyPhoneOtpLoading = false.obs;
  bool get isVerifyPhoneOtpLoading => _isVerifyPhoneOtpLoading.value;

  Future<CommonSuccessModel?> verifyPhoneOtpProcess(String code) async {
    Map<String, dynamic> inputBody = {
      'code': code,
    };

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.verifyPhoneOTPURL,
      isLoading: _isVerifyPhoneOtpLoading,
      method: HttpMethod.POST,
      body: inputBody,
      onSuccess: (value) {
        LocalStorages.isLoginSuccess(isLoggedIn: true);
        LocalStorages.isLoggedIn();
        update();
        Get.offAllNamed(Routes.waitForApprovalScreen);
        _commonSuccessModel = value!;
      },
    );
  }

  // For got password
  final _isSendForgotOTPLoading = false.obs;
  bool get isSendForgotOTPLoading => _isSendForgotOTPLoading.value;
  late CommonSuccessModel _sendForgotOTPEmailModel;
  CommonSuccessModel get sendForgotOTPEmailModel => _sendForgotOTPEmailModel;

  Future<CommonSuccessModel> sendForgotOTPEmailProcess() async {
    _isSendForgotOTPLoading.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'type': selectedLogInID.value == 0 ? 'Email' : 'Phone',
      'credentials': selectedLogInID.value == 0
          ? emailForgotController.text
          : phoneNumberForgotController.text,
      'mobile_code': selectedPhoneCode.value,
    };

    await ApiServices.sendForgotOTPEmailApi(body: inputBody).then((value) {
      _sendForgotOTPEmailModel = value!;

      if (selectedLogInID.value == 0) {
        Get.toNamed(Routes.resetOtpScreen);
      } else {
        Get.toNamed(Routes.resetPasswordPhoneScreen);
      }
      _isSendForgotOTPLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isSendForgotOTPLoading.value = false;
    update();
    return _sendForgotOTPEmailModel;
  }

  // Forget Password Email Process
  late CommonSuccessModel _verifyForgotEmailModel;
  CommonSuccessModel get verifyForgotEmailModel => _verifyForgotEmailModel;

  Future<CommonSuccessModel> verifyForgotEmailProcess(
      {required String otpCode}) async {
    _isLoading2.value = true;
    update();

    Map<String, dynamic> inputBody = {
      'code': otpCode,
      'email': emailForgotController.text,
    };

    await ApiServices.verifyForgotEmailApi(body: inputBody).then((value) {
      _verifyForgotEmailModel = value!;
      Get.offAllNamed(Routes.resetPasswordScreen, arguments: {
        'otp': otpCode,
        'email': emailForgotController.text,
      });
      _isLoading2.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading2.value = false;
    update();
    return _verifyForgotEmailModel;
  }

  // Forgot password phone
  final _isForgotPhoneOtpLoading = false.obs;
  bool get isForgotPhoneOtpLoading => _isForgotPhoneOtpLoading.value;

  Future<CommonSuccessModel?> resendForgotPhoneOtpProcess() async {
    Map<String, dynamic> inputBody = {
      'mobile_code': selectedPhoneCode.value,
      'mobile': phoneNumberController.text,
    };

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.resendForgotPhoneOTPURL,
      isLoading: _isForgotPhoneOtpLoading,
      method: HttpMethod.POST,
      body: inputBody,
      onSuccess: (value) {
        _commonSuccessModel = value!;
        Get.toNamed(Routes.resetPhoneOtpScreen);
      },
    );
  }

  // Forgot password phone otp verify
  final _isForgotPhoneOtpVerifyLoading = false.obs;
  bool get isForgotPhoneOtpVerifyLoading =>
      _isForgotPhoneOtpVerifyLoading.value;
  Future<CommonSuccessModel?> resendForgotPhoneOtpVerifyProcess(
      {required String otpCode}) async {
    Map<String, dynamic> inputBody = {
      'mobile_code': selectedPhoneCode.value,
      'mobile': phoneNumberController.text,
      'code': otpCode,
    };

    return RequestProcess().request<CommonSuccessModel>(
      fromJson: CommonSuccessModel.fromJson,
      apiEndpoint: ApiEndpoint.verifyForgotPhoneOTPURL,
      isLoading: _isForgotPhoneOtpVerifyLoading,
      method: HttpMethod.POST,
      body: inputBody,
      onSuccess: (value) {
        _commonSuccessModel = value!;
        Get.offAllNamed(Routes.resetPasswordPhoneScreen, arguments: {
          'otp': otpCode,
          'mobile': phoneNumberForgotController.text,
          'mobile_code': selectedPhoneCode.value,
        });
      },
    );
  }
}
