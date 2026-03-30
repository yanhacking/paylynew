import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/routes/routes.dart';

import '../../../backend/local_storage/local_storage.dart';
import '../../../backend/model/categories/make_payment/check_merchant_scan_model.dart';
import '../../../backend/model/categories/make_payment/make_payment_info_model.dart';
import '../../../backend/model/common/common_success_model.dart';
import '../../../backend/model/wallets/wallets_model.dart';
import '../../../backend/services/api_services.dart';
import '../../../language/english.dart';
import '../../wallets/wallets_controller.dart';
import '../remaing_balance_controller/remaing_balance_controller.dart';

class MakePaymentController extends GetxController {
  final copyInputController = TextEditingController();
  final remarkController = TextEditingController();
  final senderAmountController = TextEditingController();
  final receiverAmountController = TextEditingController();

  //get others controller
  final walletsController = Get.find<WalletsController>();
  final remainingController = Get.put(RemaingBalanceController());

  RxDouble fee = 0.0.obs;
  RxDouble limitMin = 0.0.obs;
  RxDouble limitMax = 0.0.obs;
  RxDouble dailyLimit = 0.0.obs;
  RxDouble monthlyLimit = 0.0.obs;
  RxDouble min = 0.0.obs;
  RxDouble max = 0.0.obs;
  RxDouble percentCharge = 0.0.obs;
  RxDouble fixedCharge = 0.0.obs;
  RxDouble rate = 0.0.obs;
  RxDouble baseCurrRate = 0.0.obs;
  RxDouble totalFee = 0.0.obs;

  String enteredAmount = "";
  String transferFeeAmount = "";
  String totalCharge = "";
  String youWillGet = "";
  String payableAmount = "";
  RxString checkUserMessage = "".obs;
  RxBool isValidUser = false.obs;
  Rxn<MainUserWallet> selectReceiverWallet = Rxn<MainUserWallet>();
  Rxn<MainUserWallet> selectSenderWallet = Rxn<MainUserWallet>();
  RxDouble receiverExchangeRate = 0.0.obs;
  RxDouble senderExchangeRate = 0.0.obs;
  List<MainUserWallet> walletsList = [];
  void gotoPreview() {
    Get.toNamed(Routes.makePaymentPreviewScreen);
  }

  @override
  void onInit() {
    getMakePaymentInfoData();
    senderAmountController.text = "0";
    super.onInit();
  }

  // ---------------------------------------------------------------------------
  //                              Get Send Money Info Data
  // ---------------------------------------------------------------------------

  // -------------------------------Api Loading Indicator-----------------------
  //
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // -------------------------------Define API Model-----------------------------
  //
  late MakePaymentInfoModel _makePaymentInfoModel;

  MakePaymentInfoModel get makePaymentInfoModel => _makePaymentInfoModel;

  // ------------------------------API Function---------------------------------
  //
  Future<MakePaymentInfoModel> getMakePaymentInfoData() async {
    _isLoading.value = true;
    update();
    await ApiServices.makePaymentInfoApi().then((value) {
      _makePaymentInfoModel = value!;

      baseCurrRate.value = _makePaymentInfoModel.data.baseCurrRate;

      limitMin.value = _makePaymentInfoModel.data.makePaymentcharge.minLimit;
      limitMax.value = _makePaymentInfoModel.data.makePaymentcharge.maxLimit;
      dailyLimit.value =
          _makePaymentInfoModel.data.makePaymentcharge.dailyLimit;

      monthlyLimit.value =
          _makePaymentInfoModel.data.makePaymentcharge.monthlyLimit;
      min.value = _makePaymentInfoModel.data.makePaymentcharge.minLimit;
      max.value = _makePaymentInfoModel.data.makePaymentcharge.maxLimit;

      percentCharge.value =
          _makePaymentInfoModel.data.makePaymentcharge.percentCharge;
      fixedCharge.value =
          _makePaymentInfoModel.data.makePaymentcharge.fixedCharge;

      // Get wallets info
      receiverExchangeRate.value = walletsController.exchangeRate.value;
      senderExchangeRate.value = walletsController.exchangeRate.value;

      // Get payment
      selectReceiverWallet.value =
          walletsController.walletsInfoModel.data.userWallets.first;
      selectSenderWallet.value =
          walletsController.walletsInfoModel.data.userWallets.first;

      //start remaing get
      remainingController.transactionType.value =
          _makePaymentInfoModel.data.getRemainingFields.transactionType;
      remainingController.attribute.value =
          _makePaymentInfoModel.data.getRemainingFields.attribute;
      remainingController.cardId.value =
          _makePaymentInfoModel.data.makePaymentcharge.id;
      remainingController.senderAmount.value = senderAmountController.text;
      remainingController.senderCurrency.value =
          selectSenderWallet.value!.currency.code;
      remainingController.getRemainingBalanceProcess();

      for (var element in walletsController.walletsInfoModel.data.userWallets) {
        walletsList.add(
          MainUserWallet(
            balance: element.balance,
            currency: element.currency,
            status: element.status,
          ),
        );
      }

      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _makePaymentInfoModel;
  }

  // ---------------------------------------------------------------------------
  //                             Check User Exist
  // ---------------------------------------------------------------------------

  // -------------------------------Api Loading Indicator-----------------------
  //
  final _isCheckUserLoading = false.obs;

  bool get isCheckUserLoading => _isCheckUserLoading.value;

  // -------------------------------Define API Model-----------------------------
  //
  late CommonSuccessModel _checkUserExistModel;

  CommonSuccessModel get checkUserExistModel => _checkUserExistModel;

  // ------------------------------API Function---------------------------------
  //
  Future<CommonSuccessModel> getMerchantUserExistDate() async {
    _isCheckUserLoading.value = true;

    Map<String, dynamic> inputBody = {'credentials': copyInputController.text};
    update();

    await ApiServices.checkMerchantExistApi(body: inputBody).then((value) {
      _checkUserExistModel = value!;
      checkUserMessage.value = _checkUserExistModel.message.success.first;
      isValidUser.value = true;
      update();
    }).catchError((onError) {
      checkUserMessage.value = Strings.notValidUser;
      isValidUser.value = false;
      log.e(onError);
    });

    _isCheckUserLoading.value = false;
    update();
    return _checkUserExistModel;
  }

  // ---------------------------------------------------------------------------
  //                             Check User With Qr Code
  // ---------------------------------------------------------------------------

  // -------------------------------Define API Model-----------------------------
  //
  late CheckMercantWithQrCodeModel _checkMerchantWithQrCodeModel;

  CheckMercantWithQrCodeModel get checkMerchantWithQrCodeModel =>
      _checkMerchantWithQrCodeModel;

  // ------------------------------API Function---------------------------------
  //
  Future<CheckMercantWithQrCodeModel> getCheckMerchantWithQrCodeData(
      String qrcode) async {
    _isCheckUserLoading.value = true;

    Map<String, dynamic> inputBody = {'qr_code': qrcode};
    update();

    await ApiServices.checkMerchantWithQrCodeApi(body: inputBody).then((value) {
      _checkMerchantWithQrCodeModel = value!;
      copyInputController.clear();
      copyInputController.text =
          _checkMerchantWithQrCodeModel.data.merchantMobile;
      isValidUser.value = true;
      update();
    }).catchError((onError) {
      isValidUser.value = false;
      log.e(onError);
    });

    _isCheckUserLoading.value = false;
    update();
    return _checkMerchantWithQrCodeModel;
  }

  // ---------------------------------------------------------------------------
  //                             Check User Exist
  // ---------------------------------------------------------------------------
  // -------------------------------Api Loading Indicator-----------------------
  //
  final _isSendMoneyLoading = false.obs;

  bool get isSendMoneyLoading => _isSendMoneyLoading.value;

  // -------------------------------Define API Model-----------------------------
  //
  late CommonSuccessModel _makePaymentModelData;

  CommonSuccessModel get makePaymentModelData => _makePaymentModelData;

  // ------------------------------API Function---------------------------------
  //
  Future<CommonSuccessModel> makePaymentProcess() async {
    _isSendMoneyLoading.value = true;

    Map<String, dynamic> inputBody = {
      'credentials': copyInputController.text,
      'sender_amount': senderAmountController.text,
      'sender_wallet': selectSenderWallet.value!.currency.code,
      'receiver_amount': senderAmountController.text,
      'receiver_wallet': selectReceiverWallet.value!.currency.code,
      'remark': remarkController.text,
    };
    update();

    await ApiServices.makePaymentApi(body: inputBody).then((value) {
      _makePaymentModelData = value!;
      update();
    }).catchError((onError) {
      isValidUser.value = false;
      log.e(onError);
    });

    _isSendMoneyLoading.value = false;
    update();
    return _makePaymentModelData;
  }

  RxDouble getFee({required double rate}) {
    double value = fixedCharge.value * rate;
    value = value +
        (double.parse(senderAmountController.text.isEmpty
                ? '0.0'
                : senderAmountController.text) *
            (percentCharge.value / 100));

    if (senderAmountController.text.isEmpty) {
      totalFee.value = 0.0;
    } else {
      totalFee.value = value;
    }

    debugPrint(totalFee.value.toStringAsPrecision(2));
    return totalFee;
  }

  updateExchangeRate() {
    receiverExchangeRate.value =
        double.parse(selectReceiverWallet.value!.currency.rate) /
            double.parse(selectSenderWallet.value!.currency.rate);

    senderExchangeRate.value =
        double.parse(selectSenderWallet.value!.currency.rate) /
            double.parse(selectReceiverWallet.value!.currency.rate);

    getFee(rate: double.parse(selectSenderWallet.value!.currency.rate));
  }

  void getSenderAmount() {
    double receiverAmount =
        double.tryParse(receiverAmountController.text) ?? 0.0;

    int precision = selectSenderWallet.value!.currency.type == 'FIAT'
        ? LocalStorages.getFiatPrecision()
        : LocalStorages.getCryptoPrecision();

    senderAmountController.text =
        (receiverAmount * senderExchangeRate.value).toStringAsFixed(precision);
    getFee(rate: double.parse(selectSenderWallet.value!.currency.rate));
    updateLimit();
  }

  void getReceiverAmount() {
    double senderAmount = double.tryParse(senderAmountController.text) ?? 0.0;
    int precision = selectReceiverWallet.value!.currency.type == 'FIAT'
        ? LocalStorages.getFiatPrecision()
        : LocalStorages.getCryptoPrecision();
    receiverAmountController.text =
        (senderAmount * receiverExchangeRate.value).toStringAsFixed(precision);
    getFee(rate: double.parse(selectSenderWallet.value!.currency.rate));
    updateLimit();
  }

  updateLimit() {
    var limit = _makePaymentInfoModel.data.makePaymentcharge;
    limitMin.value =
        min.value * double.parse(selectSenderWallet.value!.currency.rate);

    limitMax.value =
        max.value * double.parse(selectSenderWallet.value!.currency.rate);

    dailyLimit.value = limit.dailyLimit! *
        double.parse(selectSenderWallet.value!.currency.rate);
    monthlyLimit.value = limit.monthlyLimit! *
        double.parse(selectSenderWallet.value!.currency.rate);
    remainingController.remainingMonthLyLimit.value = limit.monthlyLimit! *
        double.parse(selectSenderWallet.value!.currency.rate);
    remainingController.remainingDailyLimit.value = limit.dailyLimit! *
        double.parse(selectSenderWallet.value!.currency.rate);

    remainingController.senderAmount.value = senderAmountController.text;
  }
}
