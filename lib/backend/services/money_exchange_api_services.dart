import '../model/common/common_success_model.dart';
import '../model/money_exchange/money_exchange_info_model.dart';
import '../utils/api_method.dart';
import '../utils/custom_snackbar.dart';
import '../utils/logger.dart';
import 'api_endpoint.dart';

final log = logger(MoneyExchangeApiServices);

mixin MoneyExchangeApiServices {
  ///* Get money exchange info process api
  Future<MoneyExchangeInfoModel?> getMoneyExchangeInfoProcessApi() async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).get(
        ApiEndpoint.moneyExchangeInfoURL,
        code: 200,
      );
      if (mapResponse != null) {
        MoneyExchangeInfoModel result =
            MoneyExchangeInfoModel.fromJson(mapResponse);

        return result;
      }
    } catch (e) {
      log.e(
          '🐞🐞🐞 err from  Get money exchange info process api service ==> $e 🐞🐞🐞');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }

  /// money exchange submit  process api
  Future<CommonSuccessModel?> moneyExchangeSubmitProcess(
      {required Map<String, dynamic> body}) async {
    Map<String, dynamic>? mapResponse;
    try {
      mapResponse = await ApiMethod(isBasic: false).post(
        ApiEndpoint.moneyExchangeSubmitURL,
        body,
        code: 200,
      );
      if (mapResponse != null) {
        CommonSuccessModel result = CommonSuccessModel.fromJson(mapResponse);
        CustomSnackBar.success(result.message.success.first.toString());
        return result;
      }
    } catch (e) {
      log.e('err from post Exchange money submit  process Api service ==> $e');
      CustomSnackBar.error('Something went Wrong!');
      return null;
    }
    return null;
  }
}
