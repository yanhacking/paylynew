import 'package:qrpay/utils/basic_screen_imports.dart';
import '../../backend/model/referral_status/refferal_status_info.dart';
import '../../backend/services/api_endpoint.dart';
import '../../backend/utils/request_process.dart';

class ReferralStatusController extends GetxController {
  final searchController = TextEditingController();
  RxList<ReferUser> referUsers = RxList<ReferUser>();
  @override
  void onInit() {
    getReferInfoProcess();
    super.onInit();
  } 
   
   
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late ReferInfoModel _referInfoModel;
  ReferInfoModel get referInfoModel => _referInfoModel;

  Future<ReferInfoModel?> getReferInfoProcess() async {
    return RequestProcess().request<ReferInfoModel>(
      fromJson: ReferInfoModel.fromJson,
      apiEndpoint: ApiEndpoint.referInfoURL,
      isLoading: _isLoading,
      onSuccess: (value) {
        _referInfoModel = value!;
        if (_referInfoModel.data.referUsers.isNotEmpty) {
          referUsers.value = _referInfoModel.data.referUsers;
        }
      },
    );
  }
 
 
  filterUsers() {
    String query = searchController.text.toLowerCase();
    referUsers.value = _referInfoModel.data.referUsers.where((user) {
      return user.username.toLowerCase().contains(query);
    }).toList();
  }
}
