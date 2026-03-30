import 'package:flutter/services.dart';
import 'package:qrpay/backend/utils/custom_snackbar.dart';
import 'package:qrpay/controller/profile/update_profile_controller.dart';

import '../../backend/services/api_endpoint.dart';
import '../../controller/referral_status/referral_status_controller.dart';
import '../../language/language_controller.dart';
import '../../utils/basic_screen_imports.dart';
import '../../widgets/text_labels/title_heading5_widget.dart';

class ProfileAccountInfo extends StatelessWidget {
  ProfileAccountInfo({super.key});
  final controller = Get.put(ReferralStatusController());
  final updateProfileController = Get.put(UpdateProfileController());

  @override
  Widget build(BuildContext context) {
    var basic = controller.referInfoModel.data.basic;
    var level = controller.referInfoModel.data.accountLevels
        .where((v) => v.active == true);
    var data = updateProfileController.profileModel.data;
    final image =
        '${ApiEndpoint.mainDomain}/${data.imagePath}/${data.user.image}';
    final defaultImage =
        '${ApiEndpoint.mainDomain}/${data.imagePath}/${data.defaultImage}';
    return Container(
      padding: EdgeInsets.all(Dimensions.paddingSize * 0.6),
      decoration: BoxDecoration(
        color: Get.isDarkMode
            ? CustomColor.primaryBGDarkColor
            : CustomColor.whiteColor,
        borderRadius: BorderRadius.circular(Dimensions.radius * 1.6),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: Dimensions.radius * 3.5,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                backgroundImage: NetworkImage(
                  data.user.image != '' ? image : defaultImage,
                ),
              ),
              horizontalSpace(Dimensions.widthSize * 1.4),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TitleHeading3Widget(
                    text: level.first.title,
                    color: CustomColor.primaryLightColor,
                  ),
                  verticalSpace(Dimensions.heightSize * 0.8),
                  InfoRow(label: Strings.totalRefers, value: basic.totalRefers),
                  InfoRow(
                    label: Strings.totalDeposit,
                    value: '${basic.totalDeposit} ${basic.currencyCode}',
                  ),
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: basic.referCode))
                          .then(
                        (v) => CustomSnackBar.success(
                          Get.find<LanguageController>()
                              .getTranslation(Strings.referCodeCopy),
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        InfoRow(
                          label: Strings.referCode,
                          value: basic.referCode,
                        ),
                        horizontalSpace(Dimensions.widthSize * 0.4),
                        Icon(
                          Icons.copy_rounded,
                          size: Dimensions.iconSizeDefault * 0.9,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const InfoRow({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            TitleHeading5Widget(
              text: label,
            ),
            TitleHeading5Widget(
              text: ':',
            ),
          ],
        ),
        horizontalSpace(Dimensions.widthSize * 0.25),
        TitleHeading5Widget(
          text: value,
          fontWeight: FontWeight.bold,
        ),
      ],
    );
  }
}
