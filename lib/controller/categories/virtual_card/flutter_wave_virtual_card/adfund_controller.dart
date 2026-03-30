import 'package:get/get.dart';
import 'package:qrpay/controller/categories/virtual_card/flutter_wave_virtual_card/virtual_card_controller.dart';

import '../../../../backend/model/common/common_success_model.dart';
import '../../../../backend/services/api_services.dart';
import '../../../../backend/utils/custom_snackbar.dart';
import '../../../../backend/utils/logger.dart';
import '../../../../routes/routes.dart';

final log = logger(AddFundController);

class AddFundController extends GetxController {
  final virtualCardController = Get.put(VirtualCardController());

  List<String> totalAmount = [];

  goToAddMoneyPreviewScreen() {
    Get.toNamed(Routes.addFundPreviewScreen);
  }

  goToAddMoneyCongratulationScreen() {
    Get.toNamed(Routes.addFundPreviewScreen);
  }

  // ---------------------------------------------------------------------------
  //                              Card Block Process
  // ---------------------------------------------------------------------------
  // -------------------------------Api Loading Indicator-----------------------
  //

  final _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  // -------------------------------Define API Model-----------------------------
  //
  late CommonSuccessModel _carAddFundModel;

  CommonSuccessModel get carAddFundModel => _carAddFundModel;

  // ------------------------------API Function---------------------------------
  //
  Future<CommonSuccessModel> carAddFundProcess(String cardId) async {
    _isLoading.value = true;
    Map<String, dynamic> inputBody = {
      'fund_amount': virtualCardController.fundAmountController.text,
      'card_id': cardId,
      'currency': virtualCardController.selectedSupportedCurrency.value!.code,
      'from_currency':
          virtualCardController.selectMainWallet.value!.currency.code
    };

    update();

    await ApiServices.carAddFundApi(body: inputBody).then((value) {
      _carAddFundModel = value!;

      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _carAddFundModel;
  }

  // -------------------------------Api Loading Indicator-----------------------

  late CommonSuccessModel _cardCreateData;

  CommonSuccessModel get cardCreateData => _cardCreateData;

  Future<CommonSuccessModel> cardCreateProcess() async {
    _isLoading.value = true;
    Map<String, dynamic> inputBody = {
      'card_amount': virtualCardController.fundAmountController.text,
      'currency': virtualCardController.selectedSupportedCurrency.value!.code,
      'from_currency':
          virtualCardController.selectMainWallet.value!.currency.code
    };

    update();

    await ApiServices.createCardApi(body: inputBody).then((value) {
      _cardCreateData = value!;

      CustomSnackBar.success(_cardCreateData.message.success.first);
      Get.offAllNamed(Routes.bottomNavBarScreen);

      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _cardCreateData;
  }
}
