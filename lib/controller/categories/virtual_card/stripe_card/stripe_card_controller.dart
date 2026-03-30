import '../../../../backend/local_storage/local_storage.dart';
import '../../../../backend/model/categories/virtual_card/stripe_models/stripe_card_info_model.dart';
import '../../../../backend/model/common/common_success_model.dart';
import '../../../../backend/model/wallets/wallets_model.dart';
import '../../../../backend/services/api_services.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../../widgets/others/congratulation_widget.dart';
import '../../../navbar/dashboard_controller.dart';
import '../../../wallets/wallets_controller.dart';

class StripeCardController extends GetxController {
  final dashboardController = Get.find<DashBoardController>();
  final walletsController = Get.find<WalletsController>();
  final fundAmountController = TextEditingController();
  RxString cardId = "".obs;
  RxInt activeIndicatorIndex = 0.obs;
  RxDouble limitMin = 0.00.obs;
  RxDouble limitMax = 0.00.obs;
  RxDouble totalCharge = 0.00.obs;
  RxDouble totalPay = 0.00.obs;
  RxDouble percentCharge = 0.00.obs;

  List<SupportedCurrency> supportedCurrencyList = [];
  Rxn<SupportedCurrency> selectedSupportedCurrency = Rxn<SupportedCurrency>();
  Rxn<MainUserWallet> selectMainWallet = Rxn<MainUserWallet>();
  List<MainUserWallet> walletsList = [];

  @override
  void onInit() {
    if (LocalStorages.getCardType() == 'stripe') {
      getStripeCardData();
    }

    super.onInit();
  }

  changeIndicator(int value) {
    activeIndicatorIndex.value = value;
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late StripeCardInfoModel _stripeCardModel;
  StripeCardInfoModel get stripeCardModel => _stripeCardModel;

  Future<StripeCardInfoModel> getStripeCardData() async {
    _isLoading.value = true;
    update();

    await ApiServices.stripeCardInfoApi().then((value) {
      _stripeCardModel = value!;
      if (_stripeCardModel.data.myCard.isNotEmpty) {
        cardId.value = _stripeCardModel.data.myCard.first.cardId;
      }
      selectedSupportedCurrency.value =
          _stripeCardModel.data.supportedCurrency.first;

      for (var v in _stripeCardModel.data.supportedCurrency) {
        supportedCurrencyList.add(
          SupportedCurrency(
            id: v.id,
            country: v.country,
            name: v.name,
            code: v.code,
            type: v.type,
            rate: v.rate,
            status: v.status,
            createdAt: v.createdAt,
            currencyImage: v.currencyImage,
          ),
        );
      }
      limitMin.value = _stripeCardModel.data.cardCharge.minLimit;
      limitMax.value = _stripeCardModel.data.cardCharge.maxLimit;
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
      calculation();

      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _stripeCardModel;
  }

  Future<StripeCardInfoModel> getStripeCardInfo() async {
    update();
    await ApiServices.stripeCardInfoApi().then((value) {
      _stripeCardModel = value!;
      if (_stripeCardModel.data.myCard.isNotEmpty) {
        cardId.value = _stripeCardModel.data.myCard.first.cardId;
      }
      calculation();

      update();
    }).catchError((onError) {
      log.e(onError);
    });
    update();
    return _stripeCardModel;
  }

  ///  >>>>>> Start buyCard process
  final _isBuyCardLoading = false.obs;
  bool get isBuyCardLoading => _isBuyCardLoading.value;
  late CommonSuccessModel _buyCardModel;
  CommonSuccessModel get buyCardModel => _buyCardModel;

  Future<CommonSuccessModel> buyCardProcess(context) async {
    _isBuyCardLoading.value = true;
    update();
    Map<String, dynamic> inputBody = {
      "card_amount": fundAmountController.text,
      "currency": selectMainWallet.value!.currency.code,
      "from_currency": selectedSupportedCurrency.value!.code,
    };
    await ApiServices.stripeBuyCardApi(body: inputBody).then((value) {
      _buyCardModel = value!;
      update();

      StatusScreen.show(
        context: context,
        subTitle: '',
        onPressed: () {
          Get.offAllNamed(Routes.bottomNavBarScreen);
        },
      );
      update();
    }).catchError((onError) {
      log.e(onError);
      update();
    });

    _isBuyCardLoading.value = false;
    update();
    return _buyCardModel;
  }

  void calculation() {
    CardCharge data = _stripeCardModel.data.cardCharge;
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
            selectedSupportedCurrency.value!.rate) +
        percentCharge.value;

    //total pay data
    totalPay.value = amount + totalCharge.value;
  }

  updateLimit() {
    var limit = _stripeCardModel.data.cardCharge;
    limitMax.value = limit.maxLimit * selectMainWallet.value!.currency.rate;
    limitMin.value = limit.minLimit * selectMainWallet.value!.currency.rate;
  }
}
