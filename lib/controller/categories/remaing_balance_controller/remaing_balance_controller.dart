import 'package:get/get.dart';

import '../../../backend/model/wallets/remaining_balance_model.dart';
import '../../../backend/services/api_services.dart';

class RemaingBalanceController extends GetxController {
  RxString transactionType = "".obs;
  RxString attribute = "".obs;
  RxString senderAmount = "0".obs;
  RxString senderCurrency = "".obs;
  RxInt cardId = 0.obs;

  // remaing limit
  RxDouble remainingDailyLimit = 0.0.obs;
  RxDouble remainingMonthLyLimit = 0.0.obs;

  // @override
  // void onInit() {
  //   getRemainingBalanceProcess();
  //   super.onInit();
  // }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  late RemainingBalanceModel _remainingBalanceModel;

  RemainingBalanceModel get remainingBalanceModel => _remainingBalanceModel;
  Future<RemainingBalanceModel> getRemainingBalanceProcess() async {
    _isLoading.value = true;
    update();

    await ApiServices.remainingBalanceAPi(
            transactionType.value,
            attribute.value,
            senderAmount.value,
            senderCurrency.value,
            cardId.value)
        .then((value) {
      _remainingBalanceModel = value!;

      remainingDailyLimit.value =
          double.parse(_remainingBalanceModel.data.remainingDaily);

      print(" this is daily limit: ${remainingMonthLyLimit.value}");

      senderCurrency.value = _remainingBalanceModel.data.currency;
      remainingMonthLyLimit.value =
          double.parse(_remainingBalanceModel.data.remainingMonthly);
      print(" this is monthly limit: ${remainingMonthLyLimit.value}");

      _isLoading.value = false;
      update();
    }).catchError((onError) {
      log.e(onError);
      _isLoading.value = false;
    });
    _isLoading.value = false;
    update();
    return _remainingBalanceModel;
  }
}
