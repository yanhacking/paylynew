import 'package:carousel_slider/carousel_slider.dart';
import 'package:intl/intl.dart';
import 'package:qrpay/backend/model/categories/virtual_card/virtual_card_flutter_wave/card_info_model.dart';
import 'package:qrpay/backend/model/common/common_success_model.dart';

import '../../../../backend/local_storage/local_storage.dart';
import '../../../../backend/model/categories/virtual_card/virtual_card_flutter_wave/card_details_model.dart';
import '../../../../backend/model/categories/virtual_card/virtual_card_flutter_wave/card_transaction_model.dart';
import '../../../../backend/model/wallets/wallets_model.dart';
import '../../../../backend/services/api_services.dart';
import '../../../../backend/utils/logger.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../navbar/dashboard_controller.dart';
import '../../../wallets/wallets_controller.dart';

final log = logger(VirtualCardController);

class VirtualCardController extends GetxController {
  RxString baseCurrency = "".obs;
  RxString flutterWaveCardId = "".obs;
  List<String> baseCurrencyList = [];
  final dashboardController = Get.find<DashBoardController>();
  final walletsController = Get.find<WalletsController>();
  final fundAmountController = TextEditingController();
  RxDouble fee = 0.0.obs;
  RxDouble limitMin = 0.0.obs;
  RxDouble limitMax = 0.0.obs;
  RxDouble percentCharge = 0.0.obs;
  RxDouble fixedCharge = 0.0.obs;
  RxDouble rate = 0.0.obs;
  RxDouble totalFee = 0.0.obs;

  RxDouble totalCharge = 0.00.obs;
  RxDouble totalPay = 0.00.obs;

  List<SupportedCurrency> supportedCurrencyList = [];
  Rxn<SupportedCurrency> selectedSupportedCurrency = Rxn<SupportedCurrency>();
  Rxn<MainUserWallet> selectMainWallet = Rxn<MainUserWallet>();
  List<MainUserWallet> walletsList = [];

  //-- for slider
  final CarouselSliderController carouselController =
      CarouselSliderController();
  RxInt current = 0.obs;

  @override
  void onInit() {
    if (LocalStorages.getCardType() == 'flutterwave') {
      getCardInfoData();
      ();
    }

    super.onInit();
  }

  String getDay(String value) {
    DateTime startDate = DateTime.parse(value);
    var date = DateFormat('dd').format(startDate);
    return date.toString();
  }

  String getMonth(String value) {
    DateTime startDate = DateTime.parse(value);
    var date = DateFormat('MMMM').format(startDate);
    return date.toString();
  }

  // ---------------------------------------------------------------------------
  //                              Get Card Info Data
  // ---------------------------------------------------------------------------

  // -------------------------------Api Loading Indicator-----------------------
  //
  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // -------------------------------Define API Model-----------------------------
  //
  late CardInfoModel _cardInfoModel;

  CardInfoModel get cardInfoModel => _cardInfoModel;

  // ------------------------------API Function---------------------------------
  //
  Future<CardInfoModel> getCardInfoData() async {
    _isLoading.value = true;
    update();

    await ApiServices.cardInfoApi().then((value) {
      _cardInfoModel = value!;
      baseCurrency.value = _cardInfoModel.data.baseCurr;
      baseCurrencyList.add(_cardInfoModel.data.baseCurr);

      limitMin.value = _cardInfoModel.data.cardCharge.minLimit;
      limitMax.value = _cardInfoModel.data.cardCharge.maxLimit;
      percentCharge.value = _cardInfoModel.data.cardCharge.percentCharge;
      fixedCharge.value = _cardInfoModel.data.cardCharge.fixedCharge;
      rate.value = 1.0;
      selectedSupportedCurrency.value =
          _cardInfoModel.data.supportedCurrency.first;
      for (var v in _cardInfoModel.data.supportedCurrency) {
        supportedCurrencyList.add(
          SupportedCurrency(
            id: v.id,
            country: v.country,
            name: v.name,
            code: v.code,
            type: v.type,
            rate: v.rate,
            supportedCurrencyDefault: v.supportedCurrencyDefault,
            status: v.status,
            createdAt: v.createdAt,
            currencyImage: v.currencyImage,
          ),
        );
      }
      selectMainWallet.value =
          walletsController.walletsInfoModel.data.userWallets.first;
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
    return _cardInfoModel;
  }

  // ---------------------------------------------------------------------------
  //                              Get Card Details Data
  // ---------------------------------------------------------------------------

  // -------------------------------Api Loading Indicator-----------------------
  //
  final _isDetailsLoading = false.obs;

  bool get isDetailsLoading => _isDetailsLoading.value;

  // -------------------------------Define API Model-----------------------------
  //
  late CardDetailsModel _cardDetailsModel;

  CardDetailsModel get cardDetailsModel => _cardDetailsModel;

  // ------------------------------API Function---------------------------------
  //
  Future<CardDetailsModel> getCardDetailsData(String id) async {
    _isDetailsLoading.value = true;
    update();

    await ApiServices.cardDetailsApi(id: id).then((value) {
      _cardDetailsModel = value!;

      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isDetailsLoading.value = false;
    update();
    return _cardDetailsModel;
  }

  // ---------------------------------------------------------------------------
  //                              Card Block Process
  // ---------------------------------------------------------------------------

  // -------------------------------Define API Model-----------------------------
  //
  late CommonSuccessModel _cardBlockModel;

  CommonSuccessModel get cardBlockModel => _cardBlockModel;

  // ------------------------------API Function---------------------------------
  //
  Future<CommonSuccessModel> cardBlockProcess(String cardId) async {
    _isLoading.value = true;
    Map<String, dynamic> inputBody = {'card_id': cardId};

    update();

    await ApiServices.cardBlockApi(body: inputBody).then((value) {
      _cardBlockModel = value!;
      getCardDetailsData(cardId);
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _cardBlockModel;
  }

  // ---------------------------------------------------------------------------
  //                              Card Unblock Process
  // ---------------------------------------------------------------------------

  // -------------------------------Define API Model-----------------------------
  //

  late CommonSuccessModel _cardUnBlockModel;

  CommonSuccessModel get cardUnBlockModel => _cardUnBlockModel;

  // ------------------------------API Function---------------------------------
  //
  Future<CommonSuccessModel> cardUnBlockProcess(String cardId) async {
    _isLoading.value = true;
    Map<String, dynamic> inputBody = {'card_id': cardId};

    update();

    await ApiServices.cardUnBlockApi(body: inputBody).then((value) {
      _cardUnBlockModel = value!;
      getCardDetailsData(cardId);
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _cardUnBlockModel;
  }

  // ---------------------------------------------------------------------------
  //                              Get Card Transaction Data
  // ---------------------------------------------------------------------------

  // -------------------------------Define API Model-----------------------------
  //
  late CardTransactionModel _cardTransactionModel;

  CardTransactionModel get cardTransactionModel => _cardTransactionModel;

  // ------------------------------API Function---------------------------------
  //
  Future<CardTransactionModel> getCardTransactionData(String id) async {
    _isLoading.value = true;
    update();
    Get.toNamed(Routes.transactionHistoryScreen);
    await ApiServices.cardTransactionApi(id: id).then((value) {
      _cardTransactionModel = value!;
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _cardTransactionModel;
  }

  void buyCard() {}

  // -------------------------------Api Loading Indicator-----------------------

  late CommonSuccessModel _cardCreateData;

  CommonSuccessModel get cardCreateData => _cardCreateData;

  Future<CommonSuccessModel> cardCreateProcess(String cardAmount) async {
    _isLoading.value = true;
    Map<String, dynamic> inputBody = {
      'card_amount': cardAmount,
    };

    update();

    await ApiServices.createCardApi(body: inputBody).then((value) {
      _cardCreateData = value!;

      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _cardCreateData;
  }

  // flutterwave make card default options
  final _isMakeDefaultLoading = false.obs;

  bool get isMakeDefaultLoading => _isMakeDefaultLoading.value;

  late CommonSuccessModel _cardDefaultModel;

  CommonSuccessModel get cardDefaultModel => _cardDefaultModel;

  // ------------------------------API Function---------------------------------
  //
  Future<CommonSuccessModel> makeCardDefaultProcess(String cardId) async {
    _isMakeDefaultLoading.value = true;
    Map<String, dynamic> inputBody = {'card_id': cardId};

    update();

    await ApiServices.flutterWaveCardMakeOrRemoveDefaultApi(body: inputBody)
        .then((value) {
      _cardDefaultModel = value!;
      getCardInfoData();
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isMakeDefaultLoading.value = false;
    update();
    return _cardDefaultModel;
  }

  void calculation() {
    CardCharge data = _cardInfoModel.data.cardCharge;
    double amount = 0.0;

    if (fundAmountController.text.isNotEmpty) {
      try {
        amount = double.parse(fundAmountController.text);
      } catch (e) {
        // print('Error parsing double: $e');
      }
    }

    percentCharge.value = ((amount / 100) * data.percentCharge);
    totalCharge.value = (double.parse(data.fixedCharge.toString()) *
            selectMainWallet.value!.currency.rate) +
        percentCharge.value;

    totalPay.value = amount + totalCharge.value;
  }

  updateLimit() {
    var limit = _cardInfoModel.data.cardCharge;
    limitMax.value = limit.maxLimit * selectedSupportedCurrency.value!.rate;
    limitMin.value = limit.minLimit * selectedSupportedCurrency.value!.rate;
  }
}
