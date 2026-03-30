import 'package:qrpay/utils/basic_screen_imports.dart';

import '../../../backend/model/common/common_success_model.dart';
import '../../../backend/model/money_exchange/money_exchange_info_model.dart';
import '../../../backend/model/wallets/wallets_model.dart';
import '../../../backend/services/money_exchange_api_services.dart';
import '../../app_settings/app_settings_controller.dart';
import '../../wallets/wallets_controller.dart';
import '../remaing_balance_controller/remaing_balance_controller.dart';

class MoneyExchangeController extends GetxController
    with MoneyExchangeApiServices {
  final walletsController = Get.find<WalletsController>();
  final remainingController = Get.put(RemaingBalanceController());
  final exchangeFromAmountController = TextEditingController();
  final exchangeToAmountController = TextEditingController();

  RxInt cryptoPrecision = Get.find<AppSettingsController>()
      .appSettingsModel
      .data
      .appSettings
      .agent
      .basicSettings
      .cryptoPrecision
      .obs;
  RxInt fiatPrecision = Get.find<AppSettingsController>()
      .appSettingsModel
      .data
      .appSettings
      .agent
      .basicSettings
      .fiatPrecision
      .obs;

  @override
  void onInit() {
    getMoneyExchangeInfoData();
    exchangeFromAmountController.text = "0";
    super.onInit();
  }

  RxDouble fee = 0.0.obs;
  RxDouble limitMin = 0.0.obs;
  RxDouble limitMax = 0.0.obs;
  RxDouble dailyLimit = 0.0.obs;
  RxDouble monthlyLimit = 0.0.obs;
  RxDouble percentCharge = 0.0.obs;
  RxDouble fixedCharge = 0.0.obs;
  RxDouble rate = 0.0.obs;
  RxDouble totalFee = 1.0.obs;
  RxDouble fromCurrencyRate = 0.0.obs;
  // RxBool isCrypto = false.obs;

  RxDouble exchangeRate = 0.0.obs;

  String enteredAmount = "";
  String transferFeeAmount = "";
  String totalCharge = "";
  String youWillGet = "";
  String payableAmount = "";
  RxString checkUserMessage = "".obs;
  RxBool isValidUser = false.obs;

  Rxn<MainUserWallet> selectFromWallet = Rxn<MainUserWallet>();
  Rxn<MainUserWallet> selectToWallet = Rxn<MainUserWallet>();
  List<MainUserWallet> walletsList = [];

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  final _isMoneyExchangeLoading = false.obs;
  bool get isMoneyExchangeLoading => _isMoneyExchangeLoading.value;

  /// Request money info process API
  late MoneyExchangeInfoModel _moneyExchangeInfoModel;
  MoneyExchangeInfoModel get moneyExchangeInfoModel => _moneyExchangeInfoModel;

  Future<MoneyExchangeInfoModel> getMoneyExchangeInfoData() async {
    _isLoading.value = true;
    update();

    await getMoneyExchangeInfoProcessApi().then((value) {
      _moneyExchangeInfoModel = value!;
      // Get wallet informations
      selectFromWallet.value =
          walletsController.walletsInfoModel.data.userWallets.first;

      // Automatically select a different wallet for selectToWallet
      selectToWallet.value = walletsController.walletsInfoModel.data.userWallets
          .firstWhere((wallet) => wallet != selectFromWallet.value);

      for (var element in walletsController.walletsInfoModel.data.userWallets) {
        walletsList.add(
          MainUserWallet(
            balance: element.balance,
            currency: element.currency,
            status: element.status,
          ),
        );
      }

      limitMin.value = _moneyExchangeInfoModel.data.charges.minLimit!;
      limitMax.value = _moneyExchangeInfoModel.data.charges.maxLimit!;
      dailyLimit.value = _moneyExchangeInfoModel.data.charges.dailyLimit!;
      monthlyLimit.value = _moneyExchangeInfoModel.data.charges.monthlyLimit!;
      updateExchangeRateWithToAmount();

      //start remaing get
      remainingController.transactionType.value =
          _moneyExchangeInfoModel.data.getRemainingFields.transactionType;
      remainingController.attribute.value =
          _moneyExchangeInfoModel.data.getRemainingFields.attribute;
      remainingController.cardId.value =
          _moneyExchangeInfoModel.data.charges.id!;
      remainingController.senderAmount.value =
          exchangeFromAmountController.text;
      remainingController.senderCurrency.value =
          selectFromWallet.value!.currency.code;
      remainingController.getRemainingBalanceProcess();
      percentCharge.value = _moneyExchangeInfoModel.data.charges.percentCharge!;
      rate.value = _moneyExchangeInfoModel.data.baseCurrRate!;
      fixedCharge.value = _moneyExchangeInfoModel.data.charges.fixedCharge!;

      fromCurrencyRate.value = walletsController
          .walletsInfoModel.data.userWallets.first.currency.rate;

      update();
    }).catchError((onError) {
      // log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _moneyExchangeInfoModel;
  }

  late CommonSuccessModel _sendMoneyModel;
  CommonSuccessModel get sendMoneyModel => _sendMoneyModel;

  // ------------------------------API Function---------------------------------
  Future<CommonSuccessModel> moneyExchangeProcess(context) async {
    _isMoneyExchangeLoading.value = true;

    Map<String, dynamic> inputBody = {
      'exchange_from_amount': exchangeFromAmountController.text,
      'exchange_from_currency': selectFromWallet.value!.currency.code,
      'exchange_to_amount': exchangeToAmountController.text,
      'exchange_to_currency': selectToWallet.value!.currency.code,
    };
    update();

    await moneyExchangeSubmitProcess(body: inputBody).then((value) {
      _sendMoneyModel = value!;
      update();
    }).catchError((onError) {
      isValidUser.value = false;
      log.e(onError);
    });

    _isMoneyExchangeLoading.value = false;
    update();
    return _sendMoneyModel;
  }

  void updateExchangeRateWithToAmount() {
    int cryptoPrecision = Get.find<AppSettingsController>()
        .appSettingsModel
        .data
        .appSettings
        .agent
        .basicSettings
        .cryptoPrecision;

    int fiatPrecision = Get.find<AppSettingsController>()
        .appSettingsModel
        .data
        .appSettings
        .agent
        .basicSettings
        .fiatPrecision;

    exchangeRate.value = double.parse(selectToWallet.value!.currency.rate) /
        double.parse(selectFromWallet.value!.currency.rate);

    double exchangeFromAmount = double.parse(
        exchangeFromAmountController.text.isEmpty
            ? "0.0"
            : exchangeFromAmountController.text);
    String amount = (exchangeFromAmount * exchangeRate.value).toStringAsFixed(
        selectToWallet.value!.currency.type == "CRYPTO"
            ? cryptoPrecision
            : fiatPrecision);

    exchangeToAmountController.text = amount;

    getFee();
  }

  RxDouble getFee() {
    // double value = fixedCharge.value / exchangeRate.value; wrong function
    double value =
        fixedCharge.value * double.parse(selectFromWallet.value!.currency.rate);
    _updateLimit();
    value = value +
        (double.parse(exchangeFromAmountController.text.isEmpty
                ? '0.0'
                : exchangeFromAmountController.text) *
            (percentCharge.value / 100));

    if (exchangeFromAmountController.text.isEmpty) {
      totalFee.value = 0.0;
    } else {
      totalFee.value = value;
    }
    debugPrint(totalFee.value.toStringAsPrecision(2));
    return totalFee;
  }

  void _updateLimit() {
    var limit = _moneyExchangeInfoModel.data.charges;
    limitMin.value =
        limit.minLimit! * double.parse(selectFromWallet.value!.currency.rate);
    limitMax.value =
        limit.maxLimit! * double.parse(selectFromWallet.value!.currency.rate);

    dailyLimit.value =
        limit.dailyLimit! * double.parse(selectFromWallet.value!.currency.rate);
    monthlyLimit.value = limit.monthlyLimit! *
        double.parse(selectFromWallet.value!.currency.rate);
  }

  void updateExchangeRateWithFromAmount() {
    int precision = selectFromWallet.value!.currency.type == "CRYPTO"
        ? cryptoPrecision.value
        : fiatPrecision.value;
    double exchangeRate = double.parse(selectFromWallet.value!.currency.rate) /
        double.parse(selectToWallet.value!.currency.rate);
    double exchangeToAmount = double.parse(
        exchangeToAmountController.text.isEmpty
            ? "0.0"
            : exchangeToAmountController.text);
    String amount =
        (exchangeToAmount * exchangeRate).toStringAsFixed(precision);
    exchangeFromAmountController.text = amount;
    getFee();
    print("SDAFffffffffffffffff333333333333333333333333333333333");
  }
}
