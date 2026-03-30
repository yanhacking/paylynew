import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/backend/model/categories/agent-moneyout/agent_money_info_model.dart';

import '../../../backend/local_storage/local_storage.dart';
import '../../../backend/model/categories/agent-moneyout/check_user_with_qr_code.dart';
import '../../../backend/model/common/common_success_model.dart';
import '../../../backend/model/wallets/wallets_model.dart';
import '../../../backend/services/api_services.dart';
import '../../../language/english.dart';
import '../../wallets/wallets_controller.dart';
import '../remaing_balance_controller/remaing_balance_controller.dart';

class AgentMoneyOutController extends GetxController {
  final copyInputController = TextEditingController();
  final senderAmountController = TextEditingController();
  final receiverAmountController = TextEditingController();
  final walletsController = Get.put(WalletsController());
  final remarkController = TextEditingController();
   

  //get remaining
  final remainingController = Get.put(RemaingBalanceController());


  RxDouble fee = 0.0.obs;
  RxDouble min = 0.0.obs;
  RxDouble max = 0.0.obs;
  RxDouble limitMin = 0.0.obs;
  RxDouble limitMax = 0.0.obs;

  RxDouble dailyLimit = 0.0.obs;
  RxDouble monthlyLimit = 0.0.obs;
  RxDouble percentCharge = 0.0.obs;
  RxDouble fixedCharge = 0.0.obs;
  RxDouble rate = 0.0.obs;
  RxDouble totalFee = 0.0.obs;

  String enteredAmount = "";
  String transferFeeAmount = "";
  String totalCharge = "";
  String youWillGet = "";
  String payableAmount = "";
  RxString checkUserMessage = "".obs;
  RxBool isValidUser = false.obs;

  RxDouble receiverExchangeRate = 0.0.obs;
  RxDouble senderExchangeRate = 0.0.obs;

  Rxn<MainUserWallet> selectReceiverWallet = Rxn<MainUserWallet>();
  Rxn<MainUserWallet> selectSenderWallet = Rxn<MainUserWallet>();
  List<MainUserWallet> walletsList = [];

  @override
  void onInit() {
    getAgentMoneyInfoData();
    senderAmountController.text = "0";
    super.onInit();
  }

  // ---------------------------------------------------------------------------
  //                              Get agent money out Info Data
  // ---------------------------------------------------------------------------

  // -------------------------------Api Loading Indicator-----------------------
  //
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  late AgentMoneyOutInfoModel _agentMoneyOutInfoModel;
  AgentMoneyOutInfoModel get agentMoneyOutInfoModel => _agentMoneyOutInfoModel;

  Future<AgentMoneyOutInfoModel> getAgentMoneyInfoData() async {
    _isLoading.value = true;
    update();

    await ApiServices.agentMoneyOutInfoApi().then((value) {
      _agentMoneyOutInfoModel = value!;
      // Get wallet information
      selectReceiverWallet.value =
          walletsController.walletsInfoModel.data.userWallets.first;
      selectSenderWallet.value =
          walletsController.walletsInfoModel.data.userWallets.first;
      receiverExchangeRate.value = walletsController.exchangeRate.value;
      senderExchangeRate.value = walletsController.exchangeRate.value;

      for (var element in walletsController.walletsInfoModel.data.userWallets) {
        walletsList.add(
          MainUserWallet(
            balance: element.balance,
            currency: element.currency,
            status: element.status,
          ),
        );
      }

      limitMin.value = _agentMoneyOutInfoModel.data.moneyOutCharge.minLimit;
      limitMax.value = _agentMoneyOutInfoModel.data.moneyOutCharge.maxLimit;
      dailyLimit.value = _agentMoneyOutInfoModel.data.moneyOutCharge.dailyLimit;
      monthlyLimit.value =
          _agentMoneyOutInfoModel.data.moneyOutCharge.monthlyLimit;

      min.value = _agentMoneyOutInfoModel.data.moneyOutCharge.minLimit;
      max.value = _agentMoneyOutInfoModel.data.moneyOutCharge.maxLimit;

      percentCharge.value =
          _agentMoneyOutInfoModel.data.moneyOutCharge.percentCharge;
      fixedCharge.value =
          _agentMoneyOutInfoModel.data.moneyOutCharge.fixedCharge;
      rate.value = _agentMoneyOutInfoModel.data.baseCurrRate;

      //start remaing get
      remainingController.transactionType.value =
          _agentMoneyOutInfoModel.data.getRemainingFields.transactionType;
      remainingController.attribute.value =
          _agentMoneyOutInfoModel.data.getRemainingFields.attribute;
      remainingController.cardId.value =
          _agentMoneyOutInfoModel.data.moneyOutCharge.id;
      remainingController.senderAmount.value = senderAmountController.text;
      remainingController.senderCurrency.value =
          selectSenderWallet.value!.currency.code;

      remainingController.getRemainingBalanceProcess();

      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _agentMoneyOutInfoModel;
  }

  final _isCheckAgentLoading = false.obs;

  bool get isCheckUserLoading => _isCheckAgentLoading.value;

  late CommonSuccessModel _checkAgentExistModel;

  CommonSuccessModel get checkUserExistModel => _checkAgentExistModel;
  Future<CommonSuccessModel> getCheckUserExistDate() async {
    _isCheckAgentLoading.value = true;

    Map<String, dynamic> inputBody = {'credentials': copyInputController.text};
    update();

    await ApiServices.checkAgentExistApi(body: inputBody).then((value) {
      _checkAgentExistModel = value!;
      checkUserMessage.value = _checkAgentExistModel.message.success.first;
      isValidUser.value = true;
      update();
    }).catchError((onError) {
      checkUserMessage.value = Strings.notValidUser;
      isValidUser.value = false;
      log.e(onError);
    });

    _isCheckAgentLoading.value = false;
    update();
    return _checkAgentExistModel;
  }

  // ---------------------------------------------------------------------------
  //                             Check agent With Qr Code

  late CheckAgentWithQrCodeModel _checkAgentWithQrCodeModel;

  CheckAgentWithQrCodeModel get checkUserWithQrCodeModel =>
      _checkAgentWithQrCodeModel;
  Future<CheckAgentWithQrCodeModel> getCheckUserWithQrCodeData(
      String qrcode) async {
    _isCheckAgentLoading.value = true;

    Map<String, dynamic> inputBody = {'qr_code': qrcode};
    update();

    await ApiServices.checkAgentWithQrCodeApi(body: inputBody).then((value) {
      _checkAgentWithQrCodeModel = value!;
      copyInputController.clear();
      copyInputController.text = _checkAgentWithQrCodeModel.data.agentEmail;
      isValidUser.value = true;
      update();
    }).catchError((onError) {
      isValidUser.value = false;
      log.e(onError);
    });

    _isCheckAgentLoading.value = false;
    update();
    return _checkAgentWithQrCodeModel;
  }

  // ---------------------------------------------------------------------------
  //                             Check agent Exist

  final _isSendMoneyLoading = false.obs;

  bool get isSendMoneyLoading => _isSendMoneyLoading.value;
  late CommonSuccessModel _agentMoneyModel;
  CommonSuccessModel get agentMoneyModel => _agentMoneyModel;
  // ------------------------------API Function---------------------------------
  //
  Future<CommonSuccessModel> moneyOutProcess(context) async {
    _isSendMoneyLoading.value = true;

    Map<String, dynamic> inputBody = {
      'credentials': copyInputController.text,
      'sender_amount': senderAmountController.text,
      'receiver_amount': receiverAmountController.text,
      'sender_wallet': selectSenderWallet.value!.currency.code,
      'receiver_wallet': selectReceiverWallet.value!.currency.code,
      'remark': remarkController.text,
    };
    update();

    await ApiServices.agentMoneyOutConfirmApi(body: inputBody).then((value) {
      _agentMoneyModel = value!;
      update();
    }).catchError((onError) {
      isValidUser.value = false;
      log.e(onError);
    });

    _isSendMoneyLoading.value = false;
    update();
    return _agentMoneyModel;
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
    var limit = _agentMoneyOutInfoModel.data.moneyOutCharge;
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
